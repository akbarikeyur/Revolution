//
//  RBSellerDataSourceController.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 08/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

enum SellerItemType: Int {
    case CurrentOffered = 1
    case Sold = 2
}

class RBSellerDataSourceController: NSObject {

    private let limit = 5
    private var totalItemCount: Int = 0

    private var itemType: SellerItemType = SellerItemType.CurrentOffered
    private var sellerItems: [RBSellerProduct] = [RBSellerProduct]()
    weak var parentController: RBPaginationDelegate?

    private var loadingState: PaginationLoadingState = .NotStarted {
        didSet {
            self.parentController?.loadingStateChanged(state: self.loadingState)
        }
    }

    var items: [RBSellerProduct] {
        return sellerItems
    }

    //MARK: - Class Methods
    convenience init(delegate: RBPaginationDelegate?, type: SellerItemType) {
        self.init()
        self.parentController = delegate
        self.itemType = type
    }

    //MARK: - Methods
    func loadMoreItems(isReload: Bool, completion: ((_ success: Bool, _ msg: String) -> ())?) {

        if !self.canLoadMoreResults() && !isReload {
            completion?(false, "")
            return
        }

        var offset = self.sellerItems.count
        if isReload {
            offset = 0
            self.loadingState = .LoadingInitial
        } else {
            self.loadingState = .LoadingPaging
        }

        RBSellerProduct.fetchSellerProducts(offSet: offset, limit: self.limit, type: self.itemType) { (success, msg, result) in

            if success, let theResult = result {

                if let total: Int = theResult.totalCount {
                    self.totalItemCount = total
                }

                if let sellerProduct: [RBSellerProduct] = theResult.sellerProduct {
                    if isReload {
                        self.sellerItems.removeAll()
                    }
                    self.sellerItems.append(contentsOf: sellerProduct)
                }
            }

            self.setLoadingState()
            completion?(success, msg)
        }
    }

    private func setLoadingState() {

        if self.totalItemCount == 0 {
            self.loadingState = .EmptyData
        } else if hasMoreResultsToLoad() {
            self.loadingState = .NotLoadingHasMoreData
        } else {
            self.loadingState = .NotLoadingHasNoMoreData
        }
    }

    func hasMoreResultsToLoad() -> Bool {
        return self.sellerItems.count < self.totalItemCount
    }

    func canLoadMoreResults() -> Bool {
        return (self.hasMoreResultsToLoad() && self.loadingState == .NotLoadingHasMoreData) || self.loadingState == .NotStarted
    }

    //MARK: - Remove
    func removeOffer(offer: RBSellerProduct, completion: @escaping((_ removed: Bool) -> ())) {
        if let theIndex: Int = self.sellerItems.index(where: { $0 === offer }) {
            self.sellerItems.remove(at: theIndex)
            self.totalItemCount -= 1
            if self.items.count == 0 {
                self.loadingState = .EmptyData
            }
            completion(true)
        } else {
            completion(false)
        }
    }
}
