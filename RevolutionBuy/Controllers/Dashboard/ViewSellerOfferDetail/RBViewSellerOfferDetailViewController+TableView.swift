//
//  RBItemDetailsViewController+TableView.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 29/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

extension RBViewSellerOfferDetailViewController {

    // MARK: - UITableView Delegate and Data Source Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableDataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == self.tableDataSource.index(of: kCellIdentifierName) {
            // Item Name
            let cell: RBViewSellerOfferTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: RBViewSellerOfferTitleTableViewCell.identifier()) as! RBViewSellerOfferTitleTableViewCell
            cell.configureCell(data: product)
            cell.lblCategories.text = self.wishlistProduct.categories()
            return cell
        } else if indexPath.row == self.tableDataSource.index(of: kCellIdentifierDesc) {
            // Item Desc
            let cell: RBItemDescriptionCell = tableView.dequeueReusableCell(withIdentifier: RBItemDescriptionCell.identifier()) as! RBItemDescriptionCell
            cell.configureCellWithProductOffer(data: product)
            return cell
        } else if indexPath.row == self.tableDataSource.index(of: kCellIdentifierSellerInfo) {
            // Interested Seller
            let cell: RBItemInterestedBuyerCell = tableView.dequeueReusableCell(withIdentifier: RBItemInterestedBuyerCell.identifier()) as! RBItemInterestedBuyerCell
            cell.configureCellWith(title: "Seller", user: self.product.user, showFullAddress: self.wishlistProduct.isUnlocked)
            return cell
        } else if indexPath.row == self.tableDataSource.index(of: kCellIdentifierSellerContact) {
            // Interested Seller
            let cell: RBMarkTransactionCompleteTableViewCell = tableView.dequeueReusableCell(withIdentifier: RBMarkTransactionCompleteTableViewCell.identifier()) as! RBMarkTransactionCompleteTableViewCell
            cell.cellDelegate = self
            cell.btnCall.setTitle(self.product.sellerNumber(), for: .normal)
            cell.btnWhatsThis.isSelected = self.isShowingWhatsThis
            if !self.isShowingWhatsThis {
                cell.descriptionHeightConstraint.constant = 0.0
            }
            return cell
        }

        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.identifierEmptyCell)!
        return cell
    }

}
