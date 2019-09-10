//
//  RBSearchItemViewController.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 28/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import StoreKit

extension RBViewSellerOfferViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productOfferList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: RBSellerOffersCell.identifier(), for: indexPath) as! RBSellerOffersCell
        cell.configueCellWithData(data: productOfferList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushToViewSellerOfferControllerDetail(productDetail: productOfferList[indexPath.row], wishlistProduct: self.product, parentController: self)
    }

}
