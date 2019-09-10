//
//  RBReportItemViewController.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 30/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBReportItemViewController: UIViewController {

    let descriptionMaxLimit: Int = 255

    let placeholder: String = "Reason for reporting…"
    var product: RBProduct?

    @IBOutlet weak var textViewReport: RBTextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        textViewReport.text = placeholder
        textViewReport.textColor = Constants.color.placeholderTextView
        textViewReport.selectedTextRange = textViewReport.textRange(from: textViewReport.beginningOfDocument, to: textViewReport.beginningOfDocument)

    }

    private func processReportError(error: Error) {
        /*
         statusCode :
         208 = Offer Already Reported
         204 = Offer Deleted
         */
        let statusCodeAlreadyReported = 208
        let statusCodeOfferDeleted = 204
        let reportedCode = (error as NSError).code
        if statusCodeAlreadyReported == reportedCode {
            self.product?.sellerReports = 1
            if let controllers = self.navigationController?.viewControllers, controllers.count >= 2, let itemDetailController = controllers[controllers.count - 2] as? RBItemDetailsViewController {
                itemDetailController.tblItemDetails.reloadData()
                _ = self.navigationController?.popToViewController(itemDetailController, animated: true)
            } else {
                _ = self.navigationController?.popViewController(animated: true)
            }
        } else if reportedCode == statusCodeOfferDeleted {
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }

    func reportProduct() {

        self.view.showLoader(mainTitle: "", subTitle: Constants.APIKey.loading)

        if let productId = product?.internalIdentifier {
            let params = [Constants.APIKey.description: textViewReport.text, Constants.APIKey.buyerProductId: productId] as [String: Any]
            RBCategoryItemRecords.reportProduct(params: params as [String: AnyObject]) { (success, error, message) -> (Void) in
                self.view.hideLoader()
                RBAlert.showSuccessAlert(message: message, completion: nil)

                if success {
                    self.product?.sellerReports = 1
                    RBAlert.showSuccessAlert(message: Alert.reportSuccessfullysent.rawValue, completion: nil)
                    _ = self.navigationController?.popViewController(animated: true)

                } else {
                    RBAlert.showWarningAlert(message: message, completion: nil)
                    if let theError = error {
                        self.processReportError(error: theError)
                    }
                }
            }
        }
    }

    @IBAction func submitReportBtnAction(_ sender: Any) {

        if textViewReport.text.characters.count > self.descriptionMaxLimit {
            RBWarningAlertView.showAlert(message: Alert.reasonOfReportLengthValidation.rawValue, onCompletion: nil)
            return
        }

        if self.textViewReport.text != nil, self.textViewReport.text.trimmed().characters.count > 0, textViewReport.textColor != Constants.color.placeholderTextView {
            reportProduct()
        } else {
            RBAlert.showWarningAlert(message: Alert.reasonOfReportRequired.rawValue, completion: nil)
        }
    }

    @IBAction func cancelBtnAction(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension RBReportItemViewController: UITextViewDelegate {

    // MARK: - TextVield Delegate

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {

        if textView.textColor == Constants.color.placeholderTextView {
            textView.text = nil
        }
        textView.textColor = Constants.color.textFieldTextColor
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = Constants.color.placeholderTextView
            textView.text = placeholder
        }
        self.view.endEditing(true)

    }

    internal func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return RBGenericMethods.evaluateDescriptionTextView(textView, shouldChangeTextIn: range, replacementText: text, descriptionMaxLimit: self.descriptionMaxLimit)
    }
}
