//
//  RBSelectCategoryTableViewCell.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 30/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBSelectCategoryTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var categoryTextLabel: UILabel!
    @IBOutlet weak var accessoryImageview: UIImageView!

    class func identifier() -> String {
        return "RBSelectCategoryTableViewCell"
    }

    //MARK: - Methods
    func setCellContent(_ category: RBCategory, selected: Bool) {
        self.categoryTextLabel.text = category.title
        self.setCheckedImage(isMarked: selected)
    }

    private func setCheckedImage(isMarked: Bool) {

        var image = UIImage.init(named: "uncheckedImage")
        if isMarked {
            image = UIImage.init(named: "checkedImage")
        }

        self.accessoryImageview.image = image
    }
}
