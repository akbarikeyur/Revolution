//
//  RBCustomImageView.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 05/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBCustomImageView: UIImageView {

    //MARK: - IBOutlets -
    @IBOutlet var imageViewHeightContraint: NSLayoutConstraint!
    @IBOutlet var imageViewWidthContraint: NSLayoutConstraint!

    //MARK: - View life cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateImageViewProperties()
    }

    //MARK: - Update properties -
    private func updateImageViewProperties() {
        self.imageViewHeightContraint.constant = imageViewHeightContraint.constant * Constants.KSCREEN_WIDTH_RATIO
        self.imageViewWidthContraint.constant = imageViewWidthContraint.constant * Constants.KSCREEN_WIDTH_RATIO

        let roundCornerRadius: CGFloat = self.imageViewHeightContraint.constant / 2

        self.layer.cornerRadius = roundCornerRadius
        self.clipsToBounds = true
    }

}
