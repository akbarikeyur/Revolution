//
//  RBPurchasedItemDetailVC+TableDelegate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 24/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBPurchasedItemDetailVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailDataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == self.detailDataSource.index(of: kCellIdentifierItemInfo) {
            let cell: RBViewSellerOfferTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: RBViewSellerOfferTitleTableViewCell.identifier()) as! RBViewSellerOfferTitleTableViewCell
            cell.configurePurchasedCell(product: self.purchasedItem)
            return cell
        } else if indexPath.row == self.detailDataSource.index(of: kCellIdentifierSellerInfo) {
            let cell: RBItemInterestedBuyerCell = tableView.dequeueReusableCell(withIdentifier: RBItemInterestedBuyerCell.identifier()) as! RBItemInterestedBuyerCell
            let theUser: RBUser? = self.purchasedItem.sellerProductModel()?.user
            cell.configureCellWith(title: "Seller", user: theUser, showFullAddress: false)
            return cell
        } else if indexPath.row == self.detailDataSource.index(of: kCellIdentifierSellerMobileNumber) {
            let cell: RBContactNumberTableViewCell = tableView.dequeueReusableCell(withIdentifier: RBContactNumberTableViewCell.identifier()) as! RBContactNumberTableViewCell
            cell.mobileNumberButton.addTarget(self, action: #selector(clickMobileNumber), for: .touchUpInside)

            let number: String = self.purchasedItem.sellerMobileNumber()
            if number.length > 0 {
                cell.mobileNumberButton.setTitle(number, for: .normal)
            } else {
                cell.mobileNumberButton.setTitle("No Contact", for: .normal)
            }
            return cell
        }

        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.identifierEmptyCell)!
        return cell
    }
}
