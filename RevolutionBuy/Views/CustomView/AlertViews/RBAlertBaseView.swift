//
//  RBAlertBaseView.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 01/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

typealias ClickClosure = (() -> Void)

enum AlertDismissType: Int {
    case userInitiatedDismiss = 0
    case autoDismiss = 1
}

class RBAlertBaseView: UIView {

    // MARK: - Variable
    var dismissType: AlertDismissType = .userInitiatedDismiss
    var whiteViewFinalHeight: CGFloat = 0.0
    var messageString: String = "Message"
    var dismissTitleString: String = "Ok"
    var isHideInitiated: Bool = false
    var showBackgroundColor = UIColor.black.withAlphaComponent(0.4)

    let showDuration: TimeInterval = 2.5
    let animationDuration: TimeInterval = 0.3

    var bottomConstraint: NSLayoutConstraint?

    // MARK: - Method
    func showAlert()  {

        // Shift white view down
        self.bottomConstraint?.constant = self.whiteViewFinalHeight
        self.setNeedsUpdateConstraints()
        self.layoutIfNeeded()

        // Bring white view up
        // wait for animation block
        self.backgroundColor = UIColor.clear
        self.bottomConstraint?.constant = 0.0
        self.setNeedsUpdateConstraints()

        // Add to subview
        UIApplication.shared.keyWindow?.addSubview(self)

        // Animate white view up
        UIView.animate(withDuration: self.animationDuration, animations: {
            self.layoutIfNeeded()
            self.backgroundColor = self.showBackgroundColor
        }) { (completed) in
            if self.dismissType == .autoDismiss {
                self.perform(#selector(self.dismissAlert), with: nil, afterDelay: self.showDuration)
            }
        }
    }

    func dismissAlert(completion: ClickClosure?)  {

        if self.isHideInitiated {
            return
        }

        self.isHideInitiated = true
        self.isUserInteractionEnabled = false
        self.bottomConstraint?.constant = self.whiteViewFinalHeight
        self.setNeedsUpdateConstraints()

        UIView.animate(withDuration: self.animationDuration, animations: {
            self.backgroundColor = UIColor.clear
            self.layoutIfNeeded()
        }, completion: { (completed) in
            self.removeFromSuperview()
            completion?()
        })
    }

    class func getHeightForText(messageString: String, font: UIFont) -> CGFloat {

        let labelMaxWidth: CGFloat = Constants.KSCREEN_WIDTH - (2.0 * 16.0)
        let fontUsed: UIFont = font

        let constraintRect = CGSize(width: labelMaxWidth, height: CGFloat.greatestFiniteMagnitude)

        let boundingBox = messageString.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: fontUsed], context: nil)

        return ceil(boundingBox.height)
    }
}
