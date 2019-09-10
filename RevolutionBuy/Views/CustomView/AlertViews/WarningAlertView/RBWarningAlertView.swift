//
//  RBWarningAlertView.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 02/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBWarningAlertView: RBAlertBaseView {

    //MARK: - Outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!

    //MARK: - Variables
    var tapClosure: ClickClosure?

    //MARK: - Public Methods
    class func showAlert(message: String, isSuccessAlert: Bool = false, onCompletion: ClickClosure?)  {

        let warningAlert = self.makeView(msg: message, onCompletion: onCompletion)
        if isSuccessAlert {
            warningAlert.messageLabel.textColor = UIColor.white
            warningAlert.backView.backgroundColor = Constants.color.themeDarkBlueColor
        }
        warningAlert.showAlert()
    }

    //MARK: - Private Methods
    private class func makeView(msg: String, onCompletion: ClickClosure?) -> RBWarningAlertView  {

        // View
        let view: RBWarningAlertView = UINib(nibName: "RBWarningAlertView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RBWarningAlertView
        view.messageLabel.text = msg
        view.tapClosure = onCompletion

        // Height of string
        let remainingHeight: CGFloat = 60.0 - 20.5
        let heightOfText = self.getHeightForText(messageString: msg, font: view.messageLabel.font)
        let finalHeight = remainingHeight + heightOfText

        view.frame = CGRect(x: 0.0, y: Constants.KSCREEN_HEIGHT - finalHeight, width: Constants.KSCREEN_WIDTH, height: finalHeight)

        // Parent class Variables
        // Negate the value of finalHeight
        // As the view animates from below
        view.whiteViewFinalHeight = -finalHeight
        view.bottomConstraint = view.bottomSpaceConstraint
        view.dismissType = .autoDismiss
        view.showBackgroundColor = UIColor.clear

        view.isUserInteractionEnabled = true
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.alertViewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)

        return view
    }

    //MARK: - Tap gesture
    @objc private class func alertViewTapped(_ notification: UIGestureRecognizer) {
        if let alertView: RBWarningAlertView = notification.view as? RBWarningAlertView {
            alertView.tapClosure?()
        }
    }
}
