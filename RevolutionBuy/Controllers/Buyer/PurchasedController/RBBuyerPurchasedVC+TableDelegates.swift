//
//  RBBuyerPurchasedVC+tableDelegates.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 20/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBBuyerPurchasedVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let product: RBPurchasedProduct = self.dataSource.items[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: RBItemTableViewCell.identifier(), for: indexPath) as! RBItemTableViewCell
        cell.populateDataFromPurchasedProduct(data: product)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        // last index
        if indexPath.row == self.dataSource.items.count - 1 && self.dataSource.canLoadMoreResults() {
            self.loadPurchasedItems(isRefresh: false)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product: RBPurchasedProduct = self.dataSource.items[indexPath.row]
        self.theDelegate?.openPurchasedDetail(purchasedController: self, item: product)
    }
}

