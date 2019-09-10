//
//  RBSellerCurrentSellingVC+UITableView.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 04/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

extension RBSellerCurrentSellingVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let theCount = self.dataSource.items.count
        return theCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let sellerProductItem: RBSellerProduct = self.dataSource.items[indexPath.row]

        let cellSellItem = tableView.dequeueReusableCell(withIdentifier: RBSellingItemCell.identifier(), for: indexPath) as! RBSellingItemCell
        cellSellItem.configureCell(sellerProduct: sellerProductItem)
        return cellSellItem
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // last index
        let canLoad: Bool = indexPath.row == self.dataSource.items.count - 1 && self.dataSource.canLoadMoreResults()
        if canLoad {
            self.loadSellerCurrentItems(isRefresh: false)
        }
    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let sellerProduct: RBSellerProduct = self.dataSource.items[index]
        self.pushToSellerItemDetails(with: sellerProduct, fromController: self)
    }
}
