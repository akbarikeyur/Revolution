//
//  RBGenericMethods.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 04/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

typealias ClickCompletion = (() -> Swift.Void)

class RBGenericMethods: NSObject {

    //MARK: - Get error text -
    class func serviceResponseMessage(response: Response) -> String {

        var responseText: String = ""
        if let messageString: String = response.resultDictionary?.value(forKey: "message") as? String, messageString.characters.count > 0 {
            responseText = messageString
        } else if let errorText: String = response.responseError?.localizedDescription {
            responseText = errorText
        } else {
            responseText = ""
        }
        return responseText

    }

    class func showUnderDevelopmentAlert() {
        RBAlert.showSuccessAlert(message: "Under development")
    }

    // MARK: - Make phone calls
    class func promtToMakeCall(phoneNumber: String) {

        let phoneUrl = NSURL.init(string: "tel:\(phoneNumber)")

        if UIApplication.shared.canOpenURL(phoneUrl! as URL) {

            let confirmAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: "Call", borderType: ConfirmationButtonType.BorderedOnly) {
                UIApplication.shared.openURL(phoneUrl! as URL)
            }

            let declineAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: "Cancel")

            RBAlert.showConfirmationAlert(message: "You are going to call \(phoneNumber). Carrier charges may apply.", leftButtonAttributes: declineAction, rightButtonAttributes: confirmAction)

        } else {
            RBAlert.showWarningAlert(message: "Device does not support calling")
        }
    }

    class func askGuestUserPermission(completion: @escaping ClickCompletion) {
        let confirmAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: "Continue As Guest") {
            completion()
        }

        let declineAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: "Cancel", borderType: ConfirmationButtonType.BorderedOnly)
       //Manisha
       ///orignal
      //  RBAlert.showConfirmationAlert(message: "Are you sure you want to continue as a guest user?", leftButtonAttributes: confirmAction, rightButtonAttributes: declineAction)
        //changes
            RBAlert.showConfirmationAlert(message: "Are you sure you want to continue as a guest user?", leftButtonAttributes: declineAction, rightButtonAttributes: confirmAction)
    }

    class func askGuestUserToSignUp(completion: @escaping ClickCompletion) {

        if RBUserManager.sharedManager().isUserGuestUser() == false {
            completion()
        } else {

            let confirmAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: "Sign Up") {
                self.signUpUserThroughGuestFlow { success in
                    if success == true {
                        completion()
                    }
                }
            }

            let declineAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: "Cancel", borderType: ConfirmationButtonType.BorderedOnly)

            RBAlert.showConfirmationAlert(message: "You need to be a member to do this.", leftButtonAttributes: declineAction, rightButtonAttributes: confirmAction)
        }
    }

    private class func signUpUserThroughGuestFlow(completion: @escaping(_ succcess: Bool) -> Void) {

        let storyboard = UIStoryboard.mainStoryboard()
        let navigationController: RBMenuNavigationController = storyboard.instantiateViewController(withIdentifier: signUpMenuNavigationIdentifier) as! RBMenuNavigationController
        navigationController.signUpCompletion = { success in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                completion(success)
            })
        }
//// Old one
//        if let windowCurrent: UIWindow = UIApplication.shared.keyWindow, let visibleController: UIViewController = windowCurrent.rootViewController {
//            visibleController.present(navigationController, animated: true, completion: nil)
//        }
        //// new one
        let aObjVC = storyboard.instantiateViewController(withIdentifier: "RBAgeConfirmationViewController")as! RBAgeConfirmationViewController
        if let windowCurrent: UIWindow = UIApplication.shared.keyWindow, let visibleController: UIViewController = windowCurrent.rootViewController {
             aObjVC.isFromGuestUser = true
            let aNavController = UINavigationController.init(rootViewController: aObjVC)
                aNavController.isNavigationBarHidden = true
            visibleController.present(aNavController, animated: true, completion: nil)
        }
    }

    // To fetch category name string
    class func fetchCategoriesName(arrCat: [RBBuyerProductCategories]) -> String {

        var catNameArray: [String] = [String]()
        for i in 0 ..< arrCat.count {
            if let name = arrCat[i].category?.catName() {
                catNameArray.append(name)
            }
        }
        let str = catNameArray.joined(separator: ", ")
        return str
    }

    // MARK : - Promt to rate app
    class func promtToRateApp(clickCompletion : @escaping ClickCompletion) {
        let appId  = Constants.kAppId
        guard let appstoreUrl = URL(string : "itms-apps://itunes.apple.com/app/id" + appId) else {
            return
        }

        if UIApplication.shared.canOpenURL(appstoreUrl) {
            let confirmAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: "Proceed", borderType: ConfirmationButtonType.BorderedOnly) {
                UIApplication.shared.openURL(appstoreUrl)
                clickCompletion()
            }

            let declineAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: "Cancel")

            RBAlert.showConfirmationAlert(message: "You will be redirected to App Store for a feedback.", leftButtonAttributes: declineAction, rightButtonAttributes: confirmAction)

        } else {
            RBAlert.showWarningAlert(message: "There was a problem redirecting to AppStore.")
        }
    }

    class func createError(code: Int, message: String) -> NSError {
        let errorDictionary = [NSLocalizedFailureReasonErrorKey: NSLocalizedString("Error", comment: "Error"), NSLocalizedDescriptionKey: message]
        return NSError(domain: "domain.validation", code: code, userInfo: errorDictionary)
    }

    //MARK: - Complete Transaction Prompt
    class func showMarkTransactionCompleteProceedPrompt(clickCompletion: @escaping ClickCompletion) {
        let msg = "Are you sure this transaction is complete?"
        let confirmAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: "Yes") {
            clickCompletion()
        }
        let declineAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: "Cancel", borderType: ConfirmationButtonType.BorderedOnly)
        RBAlert.showConfirmationAlert(message: msg, leftButtonAttributes: declineAction, rightButtonAttributes: confirmAction)
    }

    class func deeplinkURL(with itemId: Int) -> String {
        return Constants.APIServices.deepLinkShareURL + "\(itemId)"
    }

    private class func evaluatePaste(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String, descriptionMaxLimit: Int, completion: (() -> ())) {

        if let pastedText = UIPasteboard.general.string, pastedText == text {
            let nsString = textView.text as NSString?
            if let newString = nsString?.replacingCharacters(in: range, with: text), newString.length > descriptionMaxLimit {
                let index = newString.index(newString.startIndex, offsetBy: descriptionMaxLimit)
                textView.text = newString.substring(to: index)
                textView.resignFirstResponder()
                RBAlert.showWarningAlert(message: "Maximum limit is " + "\(descriptionMaxLimit)" + " characters")
                completion()
            }
        }
    }

    class func evaluateDescriptionTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String, descriptionMaxLimit: Int) -> Bool {

        self.evaluatePaste(textView, shouldChangeTextIn: range, replacementText: text, descriptionMaxLimit: descriptionMaxLimit) {
            return false
        }

        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }

        if let characterCount = textView.text?.length, characterCount >= descriptionMaxLimit, text != "" {
            return false
        }

        if let characterCount = textView.text?.length, characterCount == 0, text == " " {
            return false
        }

        return true
    }

    class func setHeaderButtonExclusive(controller: UIViewController) {

        if let btnCancel: UIButton = controller.view.viewWithTag(400) as? UIButton {
            btnCancel.isExclusiveTouch = true
        }

        if let btnNext: UIButton = controller.view.viewWithTag(401) as? UIButton {
            btnNext.isExclusiveTouch = true
        }
    }
}
