//
//  RBAlert.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 31/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBAlert: NSObject {

    //MARK: - INFO ALERT
    class func showInfoAlert(message msg: String, dismissTitle: String = "Ok", completion: ClickClosure? = nil) {
        RBInfoAlertView.showAlert(message: msg, buttonTitle: dismissTitle, onCompletion: completion)
    }

    class func showDemoAlert() {
        RBAlert.showInfoAlert(message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting", dismissTitle: "OKAY")
    }

    //MARK: - CONFIRMATION ALERT
    class func showConfirmationAlert(message msg: String, leftButtonAttributes: RBConfirmationButtonAttribute, rightButtonAttributes: RBConfirmationButtonAttribute) {

        RBConfirmationAlertView.showAlert(message: msg, declineAttributes: leftButtonAttributes, confirmAttributes: rightButtonAttributes)
    }

    class func showDemoConfirmationAlert() {
        let confirmAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: "YES") {
            self.showDemoAlert()
        }
        let declineAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: "NO", borderType: ConfirmationButtonType.BorderedOnly)
        RBAlert.showConfirmationAlert(message: "Show sample info alert?", leftButtonAttributes: declineAction, rightButtonAttributes: confirmAction)
    }

    //MARK: - WARNING ALERT
    class func showWarningAlert(message msg: String, completion: ClickClosure? = nil) {
        RBWarningAlertView.showAlert(message: msg, onCompletion: completion)
    }

    class func showDemoWarningAlert() {
        RBWarningAlertView.showAlert(message: "WARNING - Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", onCompletion: nil)
    }

    //MARK: - SUCCESS ALERT
    class func showSuccessAlert(message msg: String, completion: ClickClosure? = nil) {
        RBWarningAlertView.showAlert(message: msg, isSuccessAlert: true, onCompletion: completion)
    }

    class func showDemoSuccessAlert() {
        RBWarningAlertView.showAlert(message: "WARNING - Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", isSuccessAlert: true, onCompletion: nil)
    }
}
