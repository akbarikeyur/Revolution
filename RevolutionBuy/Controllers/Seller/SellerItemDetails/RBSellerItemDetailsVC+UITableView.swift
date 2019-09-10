//
//  RBSellerItemDetailsVC+UITableView.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 05/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

extension RBSellerItemDetailsVC: UITableViewDelegate, UITableViewDataSource {

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableDataSource.count
    }

    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    internal func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == self.tableDataSource.index(of: kCellIdentifierName) {
            let cell: RBItemNameCell = tableView.dequeueReusableCell(withIdentifier: RBItemNameCell.identifier()) as! RBItemNameCell
            cell.configureCellWithSellerOffer(data: self.offer)
            return cell
        } else if indexPath.row == self.tableDataSource.index(of: kCellIdentifierYourOffer) {
            let cell: RBYourOfferCell = tableView.dequeueReusableCell(withIdentifier: RBYourOfferCell.identifier()) as! RBYourOfferCell
            cell.configureCellWithSellerOffer(offer: self.offer)
            return cell
        } else if indexPath.row == self.tableDataSource.index(of: kCellIdentifierStatus) {
            let cell: RBSoldStatusCell = tableView.dequeueReusableCell(withIdentifier: RBSoldStatusCell.identifier()) as! RBSoldStatusCell
            cell.configureCellWithSellerOffer(offer: self.offer)
            return cell
        } else if indexPath.row == self.tableDataSource.index(of: kCellIdentifierInterestedBuyer) {
            let cell: RBItemInterestedBuyerCell = tableView.dequeueReusableCell(withIdentifier: RBItemInterestedBuyerCell.identifier()) as! RBItemInterestedBuyerCell
            let theUser: RBUser? = self.offer.buyerProduct?.user

            var placeholderText = "Interested Buyer"
            if self.offer.state == .ItemSoldToBuyer {
                placeholderText = "Buyer"
            }

            cell.configureCellWith(title: placeholderText, user: theUser, showFullAddress: false)
            return cell
        }

        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.kCellIdentifierEmpty)!
        return cell
    }
}
