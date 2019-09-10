//
//  RBAddItemSelectCategoryListVC+TableviewDelegate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 30/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBAddItemSelectCategoryListVC: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryList.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let category: RBCategory = self.categoryList[indexPath.row]

        let identifier: String = RBSelectCategoryTableViewCell.identifier()
        let categoryCell: RBSelectCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! RBSelectCategoryTableViewCell
        categoryCell.setCellContent(category, selected: self.selectedCategories.contains(category.catId))

        return categoryCell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        var isModified = true
        let categoryId: String = self.categoryList[indexPath.row].catId
        let isCategoryPresent = self.selectedCategories.contains(categoryId)
        if isCategoryPresent {
            self.selectedCategories.remove(categoryId)
        } else {

            if self.selectedCategories.count < self.maxCategorySelectNum {
                self.selectedCategories.add(categoryId)
            } else {
                isModified = false
                RBAlert.showInfoAlert(message: CategoryList.Error.MaximumCategorySelected.Message.rawValue, dismissTitle: CategoryList.Error.MaximumCategorySelected.DismissTitle.rawValue)
            }
        }

        if isModified {
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
    }
}
