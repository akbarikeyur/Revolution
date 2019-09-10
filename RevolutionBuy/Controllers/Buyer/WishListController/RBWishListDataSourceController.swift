//
//  RBWishListDataSourceController.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 11/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBWishListDataSourceController: NSObject {

    //MARK: - Variables
    private let limit = 5
    private var totalItemCount: Int = 0
    private var wishListItems: [RBProduct] = [RBProduct]()
    weak var parentController: RBPaginationDelegate?

    private var loadingState: PaginationLoadingState = .NotStarted {
        didSet {
            self.parentController?.loadingStateChanged(state: self.loadingState)
        }
    }

    var items: [RBProduct] {
        return wishListItems
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

        var offset = self.wishListItems.count
        if isReload {
            offset = 0
            self.loadingState = .LoadingInitial
        } else {
            self.loadingState = .LoadingPaging
        }

        RBProduct.fetchWishListProducts(offSet: offset, limit: self.limit) { (success, msg, result) in

            if success, let theResult = result {

                if let total: Int = theResult.totalCount {
                    self.totalItemCount = total
                }

                if let products: [RBProduct] = theResult.buyerProduct {

                    if isReload {
                        self.wishListItems.removeAll()
                    }

                    self.wishListItems.append(contentsOf: products)
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
        return self.wishListItems.count < self.totalItemCount
    }

    func canLoadMoreResults() -> Bool {
        return (self.hasMoreResultsToLoad() && self.loadingState == .NotLoadingHasMoreData) || self.loadingState == .NotStarted
    }

    //MARK: - Add items
    func addNewProduct(newItem: RBProduct!) {
        self.totalItemCount += 1
        self.wishListItems.insert(newItem, at: 0)

        if self.loadingState == .EmptyData || self.loadingState == .NotStarted {
            self.loadingState = .NotLoadingHasNoMoreData
        }
    }

    func updateProduct(updatedItem: RBProduct!, atIndex: Int) {
        self.wishListItems[atIndex] = updatedItem
    }

    func removeItem(item: RBProduct, completion: @escaping((_ removed: Bool) -> ())) {

        if let theIndex: Int = self.wishListItems.index(where: { $0.internalIdentifier == item.internalIdentifier }) {
            self.wishListItems.remove(at: theIndex)
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
