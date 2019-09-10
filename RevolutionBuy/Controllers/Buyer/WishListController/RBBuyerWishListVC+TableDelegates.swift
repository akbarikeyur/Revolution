//
//  RBBuyerWishListVC+TableDelegates.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 11/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBBuyerWishListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let product: RBProduct = self.dataSource.items[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: RBItemTableViewCell.identifier(), for: indexPath) as! RBItemTableViewCell
        cell.populateData(data: product)
        return cell
    }


    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        // last index
        if indexPath.row == self.dataSource.items.count - 1 && self.dataSource.canLoadMoreResults() {
            self.addWishlistItems(isRefresh: false)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedItem: RBProduct = self.dataSource.items[indexPath.row]
        self.myDelegate?.openWishListDetail(wishListController: self, item: selectedItem, index: indexPath.row)
    }
}
