//
//  ItemStepNumberView.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 30/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class ImagePickView: UIView {

    let animationDuration: TimeInterval = 0.3

    //MARK: - Outlets
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var removeImageButton: UIButton!
    @IBOutlet weak var primaryImageLabel: UILabel!

    @IBOutlet weak var primaryLabelHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var primaryLabelTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var removeImageButtonHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var removeImageButtonBottomConstraint: NSLayoutConstraint!

    func showRemoveButton(show: Bool, animated: Bool) {

        var bottomSpace: CGFloat = -self.removeImageButtonHeightContraint.constant
        if show {
            bottomSpace = 0.0
        }

        self.removeImageButtonBottomConstraint.constant = bottomSpace
        self.runLayoutAnimation(animated: animated)
    }

    func showPrimaryPlaceHolder(show: Bool, animated: Bool) {

        var topSpace: CGFloat = -self.primaryLabelHeightContraint.constant
        if show {
            topSpace = 0.0
        }

        self.primaryLabelTopConstraint.constant = topSpace
        self.runLayoutAnimation(animated: animated)
    }

    private func runLayoutAnimation(animated: Bool) {

        var duration: TimeInterval = 0.0
        if animated {
            duration = self.animationDuration
        }

        self.setNeedsUpdateConstraints()

        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: duration, animations: {
            self.layoutIfNeeded()
        }) { (completed) in
            self.isUserInteractionEnabled = true
        }
    }
}
