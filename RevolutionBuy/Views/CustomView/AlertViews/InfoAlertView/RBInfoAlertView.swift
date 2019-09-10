//
//  RBInfoAlertView.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 01/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBInfoAlertView: RBAlertBaseView {

    //MARK: - Outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var OkButton: RBCustomButton!
    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!

    //MARK: - Variables
    var tapClosure: ClickClosure?

    //MARK: - Public Methods
    class func showAlert(message: String, buttonTitle: String = "Ok", onCompletion: ClickClosure? = nil)  {

        let infoAlert = self.makeView(msg: message, btnTitle: buttonTitle, onCompletion: onCompletion)
        infoAlert.showAlert()
    }

    //MARK: - Private Methods
    private class func makeView(msg: String, btnTitle: String, onCompletion: ClickClosure? = nil) -> RBInfoAlertView  {

        // View
        let view: RBInfoAlertView = UINib(nibName: "RBInfoAlertView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RBInfoAlertView
        view.messageLabel.text = msg
        view.OkButton.setTitle(btnTitle, for: .normal)
        view.tapClosure = onCompletion
        view.frame = CGRect(x: 0.0, y: 0.0, width: Constants.KSCREEN_WIDTH, height: Constants.KSCREEN_HEIGHT)

        // Height of string
        let remainingHeight: CGFloat = 129.0 - 21.0
        let heightOfText = self.getHeightForText(messageString: msg, font: view.messageLabel.font)
        let finalHeight = remainingHeight + heightOfText

        // Negate the value
        // As the view animates from below
        view.whiteViewFinalHeight = -finalHeight
        view.bottomConstraint = view.bottomSpaceConstraint

        return view
    }

    //MARK: - Clicks
    @IBAction func clickOkay(_ sender: UIButton) {
        self.dismissAlert(completion: self.tapClosure)
    }
}
