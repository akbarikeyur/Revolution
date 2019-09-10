//
//  RBWishListItemDetailVC+TableViewDelegate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 14/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBWishListItemDetailVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableDataSource.count
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return RBViewSellerOfferFooterView.height()
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        // Dequeue with the reuse identifier
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: RBViewSellerOfferFooterView.identifier()) as! RBViewSellerOfferFooterView
        footer.viewoOfferButton.addTarget(self, action: #selector(clickNavigateToSellerOffers), for: .touchUpInside)
        return footer
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == self.tableDataSource.index(of: kCellIdentifierName) {
            let cell: RBItemNameCell = tableView.dequeueReusableCell(withIdentifier: RBItemNameCell.identifier()) as! RBItemNameCell
            cell.configureCell(data: self.item)
            return cell
        } else if indexPath.row == self.tableDataSource.index(of: kCellIdentifierDesc) {
            let cell: RBItemDescriptionCell = tableView.dequeueReusableCell(withIdentifier: RBItemDescriptionCell.identifier()) as! RBItemDescriptionCell
            cell.configureCell(data: self.item)
            return cell
        }

        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.identifierEmptyCell)!
        return cell
    }
}
