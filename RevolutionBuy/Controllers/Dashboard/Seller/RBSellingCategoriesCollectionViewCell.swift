//
//  RBSellingCategoriesCollectionViewCell.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 27/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBSellingCategoriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewCategory: UIImageView!
    @IBOutlet weak var lblCategoryTitle: UILabel!

    func configureCell(item: RBCategory) {
        lblCategoryTitle.text = item.title
        imageViewCategory.image = UIImage(named: item.image!)
    }

}
