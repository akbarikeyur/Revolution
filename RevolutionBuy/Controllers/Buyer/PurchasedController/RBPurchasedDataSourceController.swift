//
//  RBPurchasedDataSourceController.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 20/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

class RBPurchasedDataSourceController: NSObject {

    //MARK: - Variables
    private let limit = 5
    private var totalItemCount: Int = 0
    private var purchasedListItems: [RBPurchasedProduct] = [RBPurchasedProduct]()
    weak var parentController: RBPaginationDelegate?

    private var loadingState: PaginationLoadingState = .NotStarted {
        didSet {
            self.parentController?.loadingStateChanged(state: self.loadingState)
        }
    }

    var items: [RBPurchasedProduct] {
        return purchasedListItems
    }

    //MARK: - Class Methods
    convenience init(delegate: RBPaginationDelegate?) {
        self.init()
        self.parentController = delegate
    }

    //MARK: - Methods
    func loadMoreItems(isReload: Bool, completion: ((_ success: Bool, _ msg: String) -> ())?) {

        if !self.canLoadMoreResults() && !isReload {
            completion?(false, "")
            return
        }

        var offset = self.purchasedListItems.count
        if isReload {
            offset = 0
            self.loadingState = .LoadingInitial
        } else {
            self.loadingState = .LoadingPaging
        }

        RBProduct.fetchPurchasedProducts(offSet: offset, limit: self.limit) { (success, msg, result) in

            if success, let theResult = result {

                if let total: Int = theResult.totalCount {
                    self.totalItemCount = total
                }

                if let products: [RBPurchasedProduct] = theResult.buyerProduct {

                    if isReload {
                        self.purchasedListItems.removeAll()
                    }

                    self.purchasedListItems.append(contentsOf: products)
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
        return self.purchasedListItems.count < self.totalItemCount
    }

    func canLoadMoreResults() -> Bool {
        return (self.hasMoreResultsToLoad() && self.loadingState == .NotLoadingHasMoreData) || self.loadingState == .NotStarted
    }

    //MARK: - Add items
    func addNewPurchasedProduct(newItem: RBPurchasedProduct!) {
        self.totalItemCount += 1
        self.purchasedListItems.insert(newItem, at: 0)

        if self.loadingState == .EmptyData || self.loadingState == .NotStarted {
            self.loadingState = .NotLoadingHasNoMoreData
        }
    }
}
