//
//  UIViewController+Additions.swift
//
//  Created by Pawan Joshi on 12/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import Reachability

// MARK: - UIViewController Extension
extension UIViewController {

    func isInternetConnected() -> Bool {
        let reach: Reachability = Reachability.forInternetConnection()
        return reach.currentReachabilityStatus() != .NotReachable
    }

    /**
     Shows a simple alert view with a title and dismiss button

     - parameter title:   title for alerview
     - parameter message: message to be shown
     */

    func showAlert(_ alert: UIAlertController) {
        guard self.presentedViewController != nil else {
            self.present(alert, animated: true, completion: nil)
            return
        }
    }

    func showAlertViewWithMessage(_ title: String, message: String) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    /**
     Shows a simple alert view with a title, dismiss button and action handler for dismiss button

     - parameter title:         title for alerview
     - parameter message:       message description
     - parameter actionHandler: actionHandler code/closer/block
     */
    func showAlertViewWithMessageAndActionHandler(_ title: String, message: String, actionHandler: (() -> Void)?) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default) { (action) in

            if let _ = actionHandler {
                actionHandler!()
            }
        }
        alertController.addAction(alAction)
        present(alertController, animated: true, completion: nil)
    }

    /**
     Shows a simple alert view with a simple text field

     - parameter title:                title description
     - parameter message:              message description
     - parameter textFieldPlaceholder: placeholder text for text field in alert view
     - parameter submitActionHandler:  submitActionHandler block/closer/code
     */
    func showAlertViewWithTextField(_ title: String, message: String, textFieldPlaceholder: String, submitActionHandler: @escaping(_ textFromTextField: String?) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = textFieldPlaceholder
            textField.borderStyle = UITextBorderStyle.none
        }

        let submitAction = UIAlertAction(title: NSLocalizedString("Submit", comment: "Submit"), style: .default) { (action: UIAlertAction!) in
            let answerTF = alertController.textFields![0]
            let text = answerTF.text
            submitActionHandler(text)
        }
        alertController.addAction(submitAction)

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    /**
     Shows a simple alert view with a secure text field

     - parameter title:                title description
     - parameter message:              message description
     - parameter textFieldPlaceholder: placeholder text for text field in alert view
     - parameter submitActionHandler:  submitActionHandler block/closer/code
     */
    func showAlertViewWithSecureTextField(_ title: String, message: String, textFieldPlaceholder: String, submitActionHandler: @escaping(_ textFromTextField: String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = textFieldPlaceholder
            textField.isSecureTextEntry = true
        }

        let submitAction = UIAlertAction(title: NSLocalizedString("Submit", comment: "Submit"), style: .default) { (action: UIAlertAction!) in
            let answer = alertController.textFields![0]
            submitActionHandler(answer.text!)
        }
        alertController.addAction(submitAction)

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)

        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController {
    /**
     shows activity controller with supplied items. at least one type of item must be supplied

     - parameter image:      image to be shared
     - parameter text:       text to be shared
     - parameter url:        url to be shared
     - parameter activities: array of UIActivity which you want to show in controller. nil value will show every available active by default
     */
    func showActivityController(_ image: UIImage?, text: String?, url: String?, activities: [UIActivity]? = nil) {

        var array = [AnyObject]()

        if image != nil {
            array.append(image!)
        }
        if text != nil {
            array.append(text! as AnyObject)
        }
        if url != nil {
            array.append(URL(string: url!)! as AnyObject)
        }
        assert(array.count != 0, "Please specify at least element to share among image, text or url")

        let activityController = UIActivityViewController(activityItems: array, applicationActivities: activities)
        present(activityController, animated: true, completion: nil)
    }
}
