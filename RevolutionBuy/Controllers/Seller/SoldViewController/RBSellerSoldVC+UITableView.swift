//
//  RBSellerSoldVC+UITableView.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 04/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

extension RBSellerSoldVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let sellerProduct: RBSellerProduct = self.dataSource.items[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: RBSellingItemCell.identifier(), for: indexPath) as! RBSellingItemCell
        cell.configureCell(sellerProduct: sellerProduct)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // last index
        if indexPath.row == self.dataSource.items.count - 1 && self.dataSource.canLoadMoreResults() {
            self.loadSellerSoldItems(isRefresh: false)
        }
    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let sellerProduct: RBSellerProduct = self.dataSource.items[index]
        self.pushToSellerItemDetails(with: sellerProduct, fromController: nil)
    }
}
