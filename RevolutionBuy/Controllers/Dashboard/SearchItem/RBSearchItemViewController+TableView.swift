//
//  RBSearchItemViewController.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 28/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

extension RBSearchItemViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Rows for product list array
        return productList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellSearchItem: RBItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RBItemTableViewCell", for: indexPath) as! RBItemTableViewCell
        cellSearchItem.populateData(data: productList[indexPath.row])
        return cellSearchItem
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Push to item detail page
        self.pushToItemDetail(productDetail: productList[indexPath.row])
    }
}
