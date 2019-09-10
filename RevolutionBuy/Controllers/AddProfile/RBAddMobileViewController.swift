
//
//  RBAddMobileViewController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 03/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBAddMobileViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var mobileTextField: RBCustomTextField!
    @IBOutlet var mobileHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleMobileLabel: UILabel!
    @IBOutlet weak var backMobileButton: UIButton!

    //MARK: - Variables -
    var addProfileModel: UserAddProfileModel?
    var isUserViaSettings: Bool = false

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.initializeAddMobileClass()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let parentController: RBAddProfileContainerViewController = self.navigationController?.parent as? RBAddProfileContainerViewController {
            parentController.activeBottomLabel(false)
        }
    }

    //MARK: - Initialize class -
    fileprivate func initializeAddMobileClass() {

        if isUserViaSettings == true {
            self.titleMobileLabel.text = "Change Mobile Number"
            self.backMobileButton.setImage(UIImage.init(named: "back"), for: UIControlState.normal)
            self.backMobileButton.setTitle("", for: UIControlState.normal)
        } else {
            self.titleMobileLabel.text = "Mobile Verification"
            self.backMobileButton.setImage(nil, for: UIControlState.normal)
            self.backMobileButton.setTitle("Back", for: UIControlState.normal)
            self.backMobileButton.titleLabel?.font = UIFont.avenirNextRegular(15.0)
        }

        if mobileHeightConstraint != nil {
            mobileHeightConstraint.constant = mobileHeightConstraint.constant * Constants.KSCREEN_HEIGHT_RATIO
        }

        if isUserViaSettings == true, let userMobileNumber: String = RBUserManager.sharedManager().activeUser.mobile {
            self.mobileTextField.text = userMobileNumber
        } else if let userMobileCode: String = self.addProfileModel?.countryCode {
            self.mobileTextField.text = userMobileCode
        }
    }

    //MARK: - IBAction -
    @IBAction func addMobileAction(sender: AnyObject) {
        self.view.endEditing(true)
        self.validateMobileNumber()
    }

    @IBAction func addMobileBackAction(sender: AnyObject) {
        self.view.endEditing(true)
        _ = navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RBAddMobileViewController: UITextFieldDelegate {

    //MARK: - Textfield delegate -
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        if let mobileTextField: RBCustomTextField = textField as? RBCustomTextField {
            mobileTextField.textFieldType = TextFieldType.accurate
        }
    }

    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == mobileTextField, let mobileNumberTextField: Int = textField.text?.characters.count, mobileNumberTextField >= 40, string != "" {
            return false
        }

        return true
    }

    internal func textFieldDidEndEditing(_ textField: UITextField) {
        if let mobielText: String = textField.text, self.isUserViaSettings == false, mobielText.characters.count == 0, let countryCode: String = self.addProfileModel?.countryCode {
            textField.text = countryCode
        }
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.validateMobileNumber()
        return true
    }

}

extension RBAddMobileViewController {

    //MARK: - Validate mobile number -
    fileprivate func validateMobileNumber() {

        let mobileValidator: UserMobileNumberValidation = UserMobileNumberValidation(mobileNumber: mobileTextField.text)

        do {
            let mobileNumber: String = try mobileValidator.validateUserMobile()
            LogManager.logDebug("Mobile number: \(mobileNumber)")
            self.callCreateMobileOTP(mobileNumber: mobileNumber)

        } catch UserMobileNumberValidation.InputError.EnterMobile {

            mobileTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.enterMobile.rawValue, completion: nil)

        } catch UserMobileNumberValidation.InputError.EnterCorrectMobile {

            mobileTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.enterValidMobile.rawValue, completion: nil)

        } catch {
            LogManager.logDebug("Any other error")
        }
    }

    //MARK: - API Call -
    fileprivate func callCreateMobileOTP(mobileNumber: String) {

        //Show loader
        self.view.showLoader(mainTitle: "", subTitle: SignUpIdentifier.identifier.generatingOtp.rawValue)

        //Call API
        RBUserManager.sharedManager().generateOTPAPI(mobileNumber) { (status, error, message) -> (Void) in

            //Hide loader
            self.view.hideLoader()

            if status == true {
                self.moveToConfirmMobileController(mobileNumber: mobileNumber)
            } else {
                RBAlert.showWarningAlert(message: message, completion: nil)
            }

        }
    }

    private func moveToConfirmMobileController(mobileNumber: String) {
        if isUserViaSettings == true {
            self.addProfileModel = UserAddProfileModel(fullName: "", age: "", countryId: "", stateId: "", cityID: "", imageData: Data(), mobileNumber: mobileNumber, countryCode: "")
        } else {
            self.addProfileModel?.mobileNumber = mobileNumber
        }
        self.pushToVerifyNumberController(addProfileModel: self.addProfileModel, viaSettings: self.isUserViaSettings)
    }

}
