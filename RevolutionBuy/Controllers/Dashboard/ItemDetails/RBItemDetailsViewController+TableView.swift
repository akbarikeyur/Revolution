//
//  RBItemDetailsViewController+TableView.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 29/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

extension RBItemDetailsViewController {

    // MARK: - UITableView Delegate and Data Source Methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 10.0))
        vw.backgroundColor = UIColor.clear
        return vw
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        } else {
            return 10.0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // Item Name
            let cell: RBItemNameCell = tableView.dequeueReusableCell(withIdentifier: RBItemNameCell.identifier()) as! RBItemNameCell
            cell.configureCell(data: product!)
            return cell
        } else if indexPath.section == 1 {
            // Item Desc
            let cell: RBItemDescriptionCell = tableView.dequeueReusableCell(withIdentifier: RBItemDescriptionCell.identifier()) as! RBItemDescriptionCell
            cell.configureCell(data: product)
            return cell
        } else if indexPath.section == 2 {
            // Interested buyer
            let cell: RBItemInterestedBuyerCell = tableView.dequeueReusableCell(withIdentifier: RBItemInterestedBuyerCell.identifier()) as! RBItemInterestedBuyerCell
            let theUser: RBUser? = self.product?.user
            cell.configureCellWith(title: "Interested Buyer", user: theUser, showFullAddress: false)
            return cell
        } else {
            // Report this item

            let cell: RBReportItemCell = tableView.dequeueReusableCell(withIdentifier: kRBReportItemCellIdentifier) as! RBReportItemCell
            cell.configureCell(data: product)

            return cell
        }
    }
}
