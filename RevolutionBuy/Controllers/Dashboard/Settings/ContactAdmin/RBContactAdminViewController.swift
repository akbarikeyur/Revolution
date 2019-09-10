
//
//  RBContactAdminViewController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 21/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import MessageUI

class RBContactAdminViewController: UIViewController {

    //MARK: - IBOutlet -
    @IBOutlet weak var callAdminButton: RBCustomButton!
    @IBOutlet weak var mailAdminButton: RBCustomButton!

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.intializeContactAdminClass()
    }

    //MARK: - Initialize class -
    private func intializeContactAdminClass() {

        let emailId: String = "   " + ContactAdminIdentifier.contact.mail.rawValue
        let phoneNumber: String = "   " + ContactAdminIdentifier.contact.call.rawValue

        self.callAdminButton.setTitle(phoneNumber, for: UIControlState.normal)
        self.mailAdminButton.setTitle(emailId, for: UIControlState.normal)
    }

    //MARK: - IBAction -
    @IBAction func contactAdminViaCallAction(_ sender: AnyObject) {
        self.callAdminAction(phoneNumber: ContactAdminIdentifier.contact.call.rawValue)
    }

    @IBAction func contactAdminViaEmailAction(_ sender: AnyObject) {
        self.sendFeedbackToEmail(emailId: ContactAdminIdentifier.contact.mail.rawValue)
    }

    @IBAction func contactAdminBackAction(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension RBContactAdminViewController {

    //MARK: - Call number
    fileprivate func callAdminAction(phoneNumber: String) {
        RBGenericMethods.promtToMakeCall(phoneNumber: phoneNumber)
    }
}

extension RBContactAdminViewController: MFMailComposeViewControllerDelegate {

    //MARK: - Send feedback email
    fileprivate func sendFeedbackToEmail(emailId: String) {

        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([emailId])
            mail.setMessageBody("", isHTML: true)

            present(mail, animated: true)
        } else {
            RBAlert.showWarningAlert(message: "Check if you have set up the device for sending email")
        }
    }

    internal func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        if let errorString: String = error?.localizedDescription {
            RBAlert.showWarningAlert(message: errorString)
            return
        }

        switch result {
        case MFMailComposeResult.sent:
            RBAlert.showSuccessAlert(message: "Mail has been sent successfully")
        case MFMailComposeResult.saved:
            RBAlert.showSuccessAlert(message: "Mail has been saved successfully")
        case MFMailComposeResult.cancelled:
            RBAlert.showWarningAlert(message: "You haven't sent the email")
        case MFMailComposeResult.failed:
            RBAlert.showWarningAlert(message: "Failed to send email")
        }

        controller.dismiss(animated: true, completion: nil)
    }
}
