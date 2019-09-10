//
//  RBConfirmationAlertView.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 01/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBConfirmationAlertView: RBAlertBaseView {

    //MARK: - Outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!

    //MARK: - Variables
    var yesClosure: ClickClosure?
    var cancelClosure: ClickClosure?

    //MARK: - Public Methods
    class func showAlert(message: String, declineAttributes: RBConfirmationButtonAttribute, confirmAttributes: RBConfirmationButtonAttribute)  {

        let confirmationAlert = self.makeView(msg: message, declineButtonAttributes: declineAttributes, confirmButtonAttributes: confirmAttributes)
        confirmationAlert.showAlert()
    }

    //MARK: - Private Methods
    private class func makeView(msg: String, declineButtonAttributes: RBConfirmationButtonAttribute, confirmButtonAttributes: RBConfirmationButtonAttribute) -> RBConfirmationAlertView  {

        // View
        let view: RBConfirmationAlertView = UINib(nibName: "RBConfirmationAlertView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RBConfirmationAlertView
        view.messageLabel.text = msg

        // -- YES
        view.setAttribute(attribue: confirmButtonAttributes, on: view.yesButton)
        view.yesClosure = confirmButtonAttributes.clickcompletion

        // -- NO
        view.setAttribute(attribue: declineButtonAttributes, on: view.cancelButton)
        view.cancelClosure = declineButtonAttributes.clickcompletion

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

    private func setAttribute(attribue: RBConfirmationButtonAttribute, on button: UIButton) {

        let theColor: UIColor = Constants.color.themeBlueColor
        button.layer.cornerRadius = 4.0
        button.layer.borderWidth = 1.0
        button.setTitle(attribue.buttonTitle, for: .normal)

        if attribue.type == ConfirmationButtonType.BorderedOnly {
            button.layer.borderColor = theColor.cgColor
            button.backgroundColor = UIColor.clear
            button.setTitleColor(theColor, for: .normal)
        } else {
            button.backgroundColor = theColor
            button.layer.borderColor = UIColor.clear.cgColor
            button.setTitleColor(UIColor.white, for: .normal)
        }
    }

    //MARK: - Clicks
    @IBAction func clickOkay(_ sender: UIButton) {
        self.dismissAlert(completion: self.yesClosure)
    }

    @IBAction func clickCancel(_ sender: UIButton) {
        self.dismissAlert(completion: self.cancelClosure)
    }
}
