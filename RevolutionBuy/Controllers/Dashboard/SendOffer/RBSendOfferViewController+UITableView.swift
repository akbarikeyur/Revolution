//
//  RBSendOfferViewController+UITableView.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 30/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

extension RBSendOfferViewController {

    // MARK: - UITableView Delegate and Data Source Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RBSendOfferCell = tableView.dequeueReusableCell(withIdentifier: kRBSendOfferCellIdentifier) as! RBSendOfferCell
        
        if self.selectedCurrency != nil {

            cell.btnSelectCurrency.setTitle("  Selected Currency: \((self.selectedCurrency ?? ""))", for: .normal)
            cell.btnSelectCurrency.setTitleColor(Constants.color.themeDarkBlueColor, for: .normal)
            
        } else {
            
            cell.btnSelectCurrency.setTitle("  Select Currency", for: .normal)
            cell.btnSelectCurrency.setTitleColor(UIColor.lightGray, for: .normal)
            
        }
        

        return cell
    }
}
