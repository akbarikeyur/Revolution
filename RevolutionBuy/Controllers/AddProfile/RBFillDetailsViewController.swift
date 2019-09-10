//
//  RBFillDetailsViewController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 03/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBFillDetailsViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var fullNameTextField: RBCustomTextField!
    @IBOutlet weak var ageTextField: RBCustomTextField!
    @IBOutlet weak var countryTextField: RBCustomTextField!
    @IBOutlet weak var stateTextField: RBCustomTextField!
    @IBOutlet weak var cityTextField: RBCustomTextField!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var addImageImageView: RBCustomImageView!
    @IBOutlet weak var titleProfileLabel: UILabel!
    @IBOutlet weak var nextFillDetailsButton: UIButton!
    @IBOutlet weak var backFillDetailsButton: UIButton!
    @IBOutlet weak var backContentScrollView: UIScrollView!

    //MARK: - Variables -
    var countryAreaModel: UserAreaParameters?
    var stateAreaModel: UserAreaParameters?
    var cityAreaModel: UserAreaParameters?
    var profileImageData: Data?
    var isUserViaSettings: Bool = false
    var isImageActionLaunched: Bool = false
    
    var strAge:String! // For Facebook Logged in User Age

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
 

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true

        self.initializeFillDetailsClass()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let parentController: RBAddProfileContainerViewController = self.navigationController?.parent as? RBAddProfileContainerViewController {
            parentController.activeBottomLabel(true)
        }
    }

    //MARK: - Initialize fill details class -
    private func initializeFillDetailsClass() {

        if isUserViaSettings == true {
            self.titleProfileLabel.text = "Edit Profile"
            self.nextFillDetailsButton.setTitle("Done", for: UIControlState.normal)
        } else {
            self.titleProfileLabel.text = "Create Profile"
            self.nextFillDetailsButton.setTitle("Next", for: UIControlState.normal)
        }

        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.openCameraGestureRecognizer(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.addImageButton.addGestureRecognizer(tapGesture)
        self.addImageButton.isExclusiveTouch = true
        self.nextFillDetailsButton.isExclusiveTouch = true
        self.backFillDetailsButton.isExclusiveTouch = true

        let tapGestureImage: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.openCameraGestureRecognizer(_:)))
        tapGestureImage.numberOfTapsRequired = 1
        self.addImageImageView.addGestureRecognizer(tapGestureImage)

        self.fillProfileData()
    }

    private func fillProfileData() {

        if let userName: String = RBUserManager.sharedManager().activeUser.name {
            self.fullNameTextField.text = userName
        }
        ////
//        if let userAge: Int = RBUserManager.sharedManager().activeUser.age{
//            self.ageTextField.text = "\(userAge)"
//        }
        ////For Facebook Login Data
//        if let aCity = UserDefaults.value(forKey: Constants.FBUserLoginData.city){
//            self.cityTextField.text = "\(aCity)"
//        }
//        if let aState = UserDefaults.value(forKey: Constants.FBUserLoginData.state){
//            self.stateTextField.text = "\(aState)"
//        }
//        if let aCountry = UserDefaults.value(forKey: Constants.FBUserLoginData.country){
//            self.countryTextField.text = "\(aCountry)"
//        }
        
//        if let aUserBirthday = UserDefaults.value(forKey: Constants.FBUserLoginData.birthday){
//            self.calcAge(birthday: aUserBirthday as! String)
//
//        }
        
        

        if RBUserManager.sharedManager().activeUser.isFacebookUser() == true, RBUserManager.sharedManager().activeUser.hasUserCompletedProfile() == false, let placeholderImage: UIImage = UIImage.init(named: "avatarIcon") {

            FacebookManager.sharedManager().facebookProfilePicture(completion: { (url) in

                self.addImageImageView.rb_setImageFrom(url: url, placeholderImage: placeholderImage, onCompletion: { (image, error, url) in
                    if error == nil, image != nil {
                        self.profileImageData = UIImageJPEGRepresentation(image!, 1.0)
                        self.addImageButton.setTitle(SignUpIdentifier.title.editPhoto.rawValue, for: UIControlState.normal)
                    }
                })
            })
        }

        if self.isUserViaSettings == true {
            self.fillDataToEditProfile()
        }
    }
    
    // MARK:- BIRTHDAY TO AGE CALCULATOR
    
//    func calcAge(birthday: String) -> Int {
//        let dateFormater = DateFormatter()
//        dateFormater.dateFormat = "MM/dd/yyyy"
//        let birthdayDate = dateFormater.date(from: birthday)
//        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
//        let now = Date()
//        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
//        let age = calcAge.year
//        print(age!)
//        self.strAge = "\(String(describing: age!))"
//        self.ageTextField.text = self.strAge
//        return age!
//    }

    //MARK: - IBActions -
    @IBAction func nextAddProfileAction(sender: AnyObject) {
        self.view.endEditing(true)

        if self.isImageActionLaunched == false {
            self.validateFillDetailsData()
        }
    }

    @IBAction func addProfileBackAction(sender: AnyObject) {
        self.view.endEditing(true)

        if self.isImageActionLaunched == true {
            return
        }

        // If user is guest or of via settings then he/she should return to same screen
        if RBUserManager.sharedManager().isUserGuestUser() == true {
            self.onGuestUserCancel()
        } else if isUserViaSettings == true {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            RBUserManager.sharedManager().userLogout()
        }
    }

    @IBAction func addCountryAction(sender: AnyObject) {
        self.view.endEditing(true)
        self.addAreaToProfileData(currentAreaId: "", areaType: AddressType.country)
    }

    @IBAction func addStateAction(sender: AnyObject) {
        self.view.endEditing(true)

        if let countryModel: UserAreaParameters = self.countryAreaModel {
            self.addAreaToProfileData(currentAreaId: countryModel.areaId, areaType: AddressType.state)
        } else {
            self.countryTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.selectCountry.rawValue)
        }
    }

    @IBAction func addCityAction(sender: AnyObject) {
        self.view.endEditing(true)

        if self.countryAreaModel == nil {
            self.countryTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.selectCountry.rawValue)
            return
        }

        if let stateModel: UserAreaParameters = self.stateAreaModel {
            self.addAreaToProfileData(currentAreaId: stateModel.areaId, areaType: AddressType.city)
        } else {
            self.stateTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.selectState.rawValue)
        }
    }

    //MARK: - Private methods -
    private func addAreaToProfileData(currentAreaId: String, areaType: AddressType) {

        let address = UIStoryboard.sellerStoryboard().instantiateViewController(withIdentifier: selectAddressIdentifier) as! RBSelectCityViewController

        address.addAddressCompletion(currentAreaId, areaType) { (areaId, areaName, areaCode, type) -> (Void) in

            switch type {
            case AddressType.country:
                self.setCountry(areaId: areaId, areaName: areaName, areaCode: areaCode)

            case AddressType.state:
                self.setState(areaId: areaId, areaName: areaName)

            case AddressType.city:
                self.setCity(areaId: areaId, areaName: areaName)
            }

            self.countryTextField.textFieldType = TextFieldType.accurate
            self.stateTextField.textFieldType = TextFieldType.accurate
            self.cityTextField.textFieldType = TextFieldType.accurate
        }

        self.present(address, animated: true, completion: nil)
    }

    private func setCountry(areaId: String, areaName: String, areaCode: String) {

        self.countryTextField.text = areaName
        self.stateTextField.text = ""
        self.cityTextField.text = ""

        let countryModel: UserAreaParameters = UserAreaParameters(areaId: areaId, areaName: areaName, areaCode: areaCode)
        self.countryAreaModel = countryModel

        self.stateAreaModel = nil
        self.cityAreaModel = nil
    }

    private func setState(areaId: String, areaName: String) {

        self.stateTextField.text = areaName
        self.cityTextField.text = ""

        let stateModel: UserAreaParameters = UserAreaParameters(areaId: areaId, areaName: areaName, areaCode: "")
        self.stateAreaModel = stateModel

        self.cityAreaModel = nil
    }

    private func setCity(areaId: String, areaName: String) {

        self.cityTextField.text = areaName

        let cityModel: UserAreaParameters = UserAreaParameters(areaId: areaId, areaName: areaName, areaCode: "")
        self.cityAreaModel = cityModel
    }

    @objc private func openCameraGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {

        self.view.endEditing(true)
        self.isImageActionLaunched = true

        RBCustomImagePickerView.showCustomImagePickerView { (selectionType) in

            self.isImageActionLaunched = false

            switch selectionType {
            case RBCustomImagePickerView.SelectedSourceType.camera:
                self.captureImageFromDevice(camera: true)
            case RBCustomImagePickerView.SelectedSourceType.photoLibrary:
                self.captureImageFromDevice(camera: false)
            case RBCustomImagePickerView.SelectedSourceType.cancel:
                break
            }
        }
    }

    //MARK: - On guest user cancel action -
    private func onGuestUserCancel() {
        if let addProfileNavigation: UINavigationController = self.navigationController, let addProfileContainerView: RBAddProfileContainerViewController = addProfileNavigation.view.superview?.viewController() as? RBAddProfileContainerViewController, let signUpMenuNavigationController: RBMenuNavigationController = addProfileContainerView.navigationController as? RBMenuNavigationController {
            signUpMenuNavigationController.onSignUpCompletion(false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension RBFillDetailsViewController {
    //MARK: - Validate data -
    fileprivate func validateFillDetailsData() {

        let fillDetailModel: UserAddProfileModelValidation = UserAddProfileModelValidation(fullName: fullNameTextField.text?.trimmed(), age: ageTextField.text, countryId: countryAreaModel?.areaId, stateId: stateAreaModel?.areaId, cityID: cityAreaModel?.areaId, imageData: profileImageData, mobileNumber: nil, countryCode: countryAreaModel?.areaCode)

        do {
            let addDetailModel: UserAddProfileModel = try fillDetailModel.fillUserDetailsValidation()
            LogManager.logDebug("Success! Person created. \(addDetailModel)")

            if isUserViaSettings == true {
                self.editProfileAPICall(editPofileModel: addDetailModel)
            } else {
                self.pushToMobileNumberController(addProfileModel: addDetailModel, viaSettings: false)
            }

        } catch UserAddProfileModelValidation.InputError.EnterName {

            fullNameTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.enterFullName.rawValue, completion: nil)

        } catch UserAddProfileModelValidation.InputError.EnterCorrectName {

            fullNameTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.enterCorrectFullName.rawValue, completion: nil)

        } catch UserAddProfileModelValidation.InputError.SelectAge {

            ageTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.enterAge.rawValue, completion: nil)

        } catch UserAddProfileModelValidation.InputError.InvalidAge {

            ageTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.invalidAge.rawValue, completion: nil)

        } catch UserAddProfileModelValidation.InputError.SelectCountry {

            countryTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.selectCountry.rawValue, completion: nil)

        } catch UserAddProfileModelValidation.InputError.SelectState {

            stateTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.selectState.rawValue, completion: nil)

        } catch UserAddProfileModelValidation.InputError.SelectCity {

            cityTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.selectCity.rawValue, completion: nil)

        } catch UserAddProfileModelValidation.InputError.SelectProfilePicture {

            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.profileImage.rawValue, completion: nil)

        } catch {
            LogManager.logDebug("Any other error")
        }

    }
}

extension RBFillDetailsViewController {
    //MARK: - ImagePickerControllerDelegate -
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {

        if let imageCaptured: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.addImageImageView.image = imageCaptured
            self.profileImageData = UIImageJPEGRepresentation(imageCaptured, 1.0)
            self.addImageButton.setTitle(SignUpIdentifier.title.editPhoto.rawValue, for: UIControlState.normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension RBFillDetailsViewController: UITextFieldDelegate {

    //MARK: - Textfield delegate -
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        if let addProfileTextField: RBCustomTextField = textField as? RBCustomTextField {
            addProfileTextField.textFieldType = TextFieldType.accurate
        }
    }

    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == fullNameTextField, let fullNameTextFieldCount: Int = textField.text?.characters.count, fullNameTextFieldCount >= 40, string != "" {
            return false
        }

        if textField == fullNameTextField, let textName: String = textField.text, let nameTextFieldCount: Int = textField.text?.characters.count, nameTextFieldCount >= 1 {

            let substringString: String = textName.substring(from: textName.index(textName.endIndex, offsetBy: -1))
            if substringString == " " && string == " " {
                return false
            }
        }

        if textField == ageTextField, let ageTextFieldCount: Int = textField.text?.characters.count, ageTextFieldCount > 1, string != "" {
            return false
        }

        return true
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameTextField && fullNameTextField.isFirstResponder {
            fullNameTextField.resignFirstResponder()
            ageTextField.becomeFirstResponder()
        } else {
            ageTextField.resignFirstResponder()
            self.validateFillDetailsData()
        }
        return true
    }
}

extension RBFillDetailsViewController {

    //MARK: - Edit profile fill data -
    fileprivate func fillDataToEditProfile() {

        if let userModel: RBUser = RBUserManager.sharedManager().activeUser {

            self.fullNameTextField.text = userModel.userFullName()
            self.ageTextField.text = "\(userModel.userAgeInt())"

            if let countryModel: UserAreaParameters = userModel.userCountryModel() {
                self.countryAreaModel = countryModel
                self.countryTextField.text = countryModel.areaName
            }

            if let stateModel: UserAreaParameters = userModel.userStateModel() {
                self.stateAreaModel = stateModel
                self.stateTextField.text = stateModel.areaName
            }

            if let cityModel: UserAreaParameters = userModel.userCityAreaModel() {
                self.cityAreaModel = cityModel
                self.cityTextField.text = cityModel.areaName
            }

            if let imageUrl: URL = userModel.userImageUrl(), let placeholderImage: UIImage = UIImage.init(named: "avatarIcon") {

                self.addImageImageView.rb_setImageFrom(url: imageUrl, placeholderImage: placeholderImage, onCompletion: { (image, error, url) in
                    if error == nil, image != nil {
                        self.profileImageData = UIImageJPEGRepresentation(image!, 1.0)
                        self.addImageButton.setTitle(SignUpIdentifier.title.editPhoto.rawValue, for: UIControlState.normal)
                    }
                })
            }
        }
    }

    //MARK: - API Call verify change pin -
    fileprivate func editProfileAPICall(editPofileModel: UserAddProfileModel) {

        //Show loader
        self.view.showLoader(mainTitle: "", subTitle: SignUpIdentifier.identifier.updatingProfile.rawValue)

        //Call API
        RBUser.editProfileWithAPI(editPofileModel) { (status, error, message, user) -> (Void) in
            //Hide loader
            self.view.hideLoader()

            if status == true && user != nil {
                if let navigationController: UINavigationController = self.navigationController, navigationController.viewControllers.count > 0 {
                    self.moveToSettingsFromEditProfile(navigationController: navigationController)
                }
                RBAlert.showSuccessAlert(message: message)
            } else {
                RBAlert.showWarningAlert(message: message, completion: nil)
            }
        }
    }

    //Move to settings screen after profile update
    private func moveToSettingsFromEditProfile(navigationController settings: UINavigationController) {
        for viewController in settings.viewControllers {
            if let controller: RBViewProfileViewController = viewController as? RBViewProfileViewController {
                controller.updateEditProfileData()
                _ = settings.popToViewController(controller, animated: true)
                break
            }
        }
    }
}
