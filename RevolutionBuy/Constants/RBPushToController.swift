//
//  RBPushToController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 29/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

//MARK: - UIViewController Identifiers -
let onboardingIdentifier = "RBOnboardingViewController"
let signUpMenuIdentifier = "RBSignUpMenuViewController"
let ageConfirmationIdentifier = "RBAgeConfirmationViewController"
let signUpIdentifier = "RBSignUpViewController"
let termsIdentifier = "RBTermsAndConditionsViewController"
let tabbarIdentifier = "RBTabBarController"
let itemDetailIdentifier = "RBItemDetailsViewController"
let sellerItemDetailsIdentifier = "RBSellerItemDetailsVC"
let reportItemIdentifier = "RBReportItemViewController"
let loginIdentifier = "RBLoginViewController"
let categoryItemDetailIdentifier = "RBCategoriesItemListViewController"
let addProfileContainerIdentifier = "RBAddProfileContainerViewController"
let fillDetailsIdentifier = "RBFillDetailsViewController"
let addMobileNumberIdentifier = "RBAddMobileViewController"
let verifyNumberIdentifier = "RBVerifyMobileViewController"
let sendOfferIdentifier = "RBSendOfferViewController"
let itemConfirmationIdentifier = "RBItemConfirmationViewController"
let selectAddressIdentifier = "RBSelectCityViewController"
let viewSellerIdentifier = "RBViewSellerOfferViewController"
let forgotIdentifier = "RBForgotPasswordViewController"
let forgotConfirmationIdentifier = "RBForgotConfirmationViewController"
let createNewPasswordIdentifier = "RBCreateNewPasswordViewController"
let viewSellerOfferDetailIdentifier = "RBViewSellerOfferDetailViewController"
let viewProfileViewControllerIdentifier = "RBViewProfileViewController"
let changePasswordViewControllerIdentifier = "RBChangePasswordViewController"
let contactAdminViewControllerIdentifier = "RBContactAdminViewController"
let sellerAccountSettingsControllerIdentifier = "RBSellerAccountSettingsController"
let sellerAccountControllerIdentifier = "RBSellerAccountViewController"
let connectStripeViewControllerIdentifier = "RBConnectStripeViewController"
let currencySelectorViewControllerIdentifier = "RBCurrencySelectorViewController"

//MARK: - UINavigationController Identifiers -
let onboardingNavigationIdentifier = "RBOnboardingNavigationController"
let signUpMenuNavigationIdentifier = "RBSignUpMenuNavigationController"
let addCreditCardNavigationIdentifier = "RBAddCreditCardNavi"

//MARK: - UIViewController Extension -
extension UIViewController {

    //Onboarding
    func pushToOnboardingController(viaSettings: Bool) {
        let onboardingController: RBOnboardingViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: onboardingIdentifier) as! RBOnboardingViewController
        onboardingController.onBoardingViaSettings = viaSettings
        if viaSettings == true {
            onboardingController.hidesBottomBarWhenPushed = true
        }
        self.navigationController?.pushViewController(onboardingController, animated: true)
    }

    //Signup menu
    func pushToSignUpMenu() {
        let signUpMenuController: RBSignUpMenuViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: signUpMenuIdentifier) as! RBSignUpMenuViewController
        self.navigationController?.pushViewController(signUpMenuController, animated: true)
    }

    //Age confirmation
    func pushToAgeConfirmation() {
        let ageConfirmationController: RBAgeConfirmationViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: ageConfirmationIdentifier) as! RBAgeConfirmationViewController
        self.navigationController?.pushViewController(ageConfirmationController, animated: true)
    }

    ////Signup view controller *OLD
//    func pushToSignUp() {
//
//        let signupController: RBSignUpViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: signUpIdentifier) as! RBSignUpViewController
//        self.navigationController?.pushViewController(signupController, animated: true)
//    }

    ////Signup view controller *New
    // Signup view controller
    func pushToSignUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RBSignUpViewController") as! RBSignUpViewController
        self.navigationController?.pushViewController(controller, animated: true)
       // let aObjNavController = UINavigationController(rootViewController: controller)
       // aObjNavController.isNavigationBarHidden = true
       // AppDelegate.getAppDelegate().window?.rootViewController = aObjNavController

    }
    
    //Terms view controller
    func pushToTermsController(type: TermsIdentifier.TermsType, viaSettings: Bool) {
        let termsController: RBTermsAndConditionsViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: termsIdentifier) as! RBTermsAndConditionsViewController
        termsController.typeTerms = type

        if viaSettings == true {
            termsController.hidesBottomBarWhenPushed = true
        }

        self.navigationController?.pushViewController(termsController, animated: true)
    }

    //Login view controller
    func pushToLoginController() {
        let loginController: RBLoginViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: loginIdentifier) as! RBLoginViewController
        self.navigationController?.pushViewController(loginController, animated: true)
    }

    //Forgot Password controller
    func pushToForgotPasswordController(type: ForgotPasswordIdentifier.forgotPasswordScreenType, facebookDictionary: [String: AnyObject]?) {
        let forgotController: RBForgotPasswordViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: forgotIdentifier) as! RBForgotPasswordViewController
        forgotController.forgotPasswordScreenWithType = type

        if facebookDictionary != nil {
            forgotController.facebookDictionary = facebookDictionary!
        }
        self.navigationController?.pushViewController(forgotController, animated: true)
    }

    //Create New Password controller
    func pushToCreateNewPasswordController() {
        let createNewPasswordController: RBCreateNewPasswordViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: createNewPasswordIdentifier) as! RBCreateNewPasswordViewController
        self.navigationController?.pushViewController(createNewPasswordController, animated: true)
    }

    //Add profile container controller
    func addProfileContainerController() {
        let addProfileController: RBAddProfileContainerViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: addProfileContainerIdentifier) as! RBAddProfileContainerViewController
        self.navigationController?.pushViewController(addProfileController, animated: true)
    }

    //Add mobile number controller
    func pushToMobileNumberController(addProfileModel: UserAddProfileModel?, viaSettings: Bool) {
        let addMobileNumberController: RBAddMobileViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: addMobileNumberIdentifier) as! RBAddMobileViewController
        addMobileNumberController.addProfileModel = addProfileModel
        addMobileNumberController.isUserViaSettings = viaSettings
        addMobileNumberController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addMobileNumberController, animated: true)
    }

    //Add verify mobile number controller
    func pushToVerifyNumberController(addProfileModel: UserAddProfileModel?, viaSettings: Bool) {
        let verifyNumberController: RBVerifyMobileViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: verifyNumberIdentifier) as! RBVerifyMobileViewController
        verifyNumberController.userSignUpModel = addProfileModel
        verifyNumberController.isUserViaSettings = viaSettings
        self.navigationController?.pushViewController(verifyNumberController, animated: true)
    }

    //View profile controller
    func pushToViewProfileController() {
        let viewProfileViewController: RBViewProfileViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: viewProfileViewControllerIdentifier) as! RBViewProfileViewController
        viewProfileViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewProfileViewController, animated: true)
    }

    //View change password controller
    func pushToChangePasswordController() {
        let changePasswordController: RBChangePasswordViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: changePasswordViewControllerIdentifier) as! RBChangePasswordViewController
        changePasswordController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(changePasswordController, animated: true)
    }

    //Edit profile controller
    func editProfileController(userModel: RBUser?, viaSettings: Bool) {
        let editProfileController: RBFillDetailsViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: fillDetailsIdentifier) as! RBFillDetailsViewController
        editProfileController.hidesBottomBarWhenPushed = true
        editProfileController.isUserViaSettings = viaSettings
        self.navigationController?.pushViewController(editProfileController, animated: true)
    }

    //Seller account setttings controller
    func pushTosellerAccountSettingsController() {
        let sellerAccountSettingsController: RBSellerAccountSettingsController = UIStoryboard.settingsStoryboard().instantiateViewController(withIdentifier: sellerAccountSettingsControllerIdentifier) as! RBSellerAccountSettingsController
        sellerAccountSettingsController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(sellerAccountSettingsController, animated: true)
    }

    //Seller account setttings controller
    func pushToAddSellerAccountFromSellNowController(completion: @escaping(_ success: Bool) -> (Void)) {

        let sellerAccountController: RBSellerAccountViewController = UIStoryboard.settingsStoryboard().instantiateViewController(withIdentifier: sellerAccountControllerIdentifier) as! RBSellerAccountViewController

        let navigationController: UINavigationController = UINavigationController.init(rootViewController: sellerAccountController)

        sellerAccountController.addStripeCompletion = { success in
            completion(success)
        }

        self.present(navigationController, animated: true, completion: nil)
    }

    //Add stripe accoount screen
    func pushToAddStipeAccountController() {
        let addStipeAccountController: RBConnectStripeViewController = UIStoryboard.settingsStoryboard().instantiateViewController(withIdentifier: connectStripeViewControllerIdentifier) as! RBConnectStripeViewController
        self.navigationController?.pushViewController(addStipeAccountController, animated: true)
    }

    //Contact admin controller
    func pushToContactAdminControllerController() {
        let contactAdminController: RBContactAdminViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: contactAdminViewControllerIdentifier) as! RBContactAdminViewController
        contactAdminController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(contactAdminController, animated: true)
    }

    //Seller Home
    func pushToTabbarController() {
        let sellerDashboardController: RBTabBarController = UIStoryboard.sellerStoryboard().instantiateViewController(withIdentifier: tabbarIdentifier) as! RBTabBarController
        self.navigationController?.pushViewController(sellerDashboardController, animated: true)
    }

    func pushToItemDetail(productDetail: RBProduct) {
        let itemDetailVC = UIStoryboard.itemDetailsStoryboard().instantiateViewController(withIdentifier: itemDetailIdentifier) as! RBItemDetailsViewController
        itemDetailVC.product = productDetail
        itemDetailVC.arrImages = productDetail.buyerProductImages!

        self.navigationController?.pushViewController(itemDetailVC, animated: true)
    }

    func pushToReportItem(productDetail: RBProduct?) {
        let itemDetailVC = UIStoryboard.sellerStoryboard().instantiateViewController(withIdentifier: reportItemIdentifier) as! RBReportItemViewController
        itemDetailVC.product = productDetail
        self.navigationController?.pushViewController(itemDetailVC, animated: true)
    }

    func pushToCategoryItemDetail(categoryItem: RBCategory) {
        let categoryDetailVC = UIStoryboard.sellerStoryboard().instantiateViewController(withIdentifier: categoryItemDetailIdentifier) as! RBCategoriesItemListViewController
        categoryDetailVC.category = categoryItem
        self.navigationController?.pushViewController(categoryDetailVC, animated: true)
    }

    func pushToSendOfferController(productDetail: RBProduct?) {
        let categoryDetailVC = UIStoryboard.itemDetailsStoryboard().instantiateViewController(withIdentifier: sendOfferIdentifier) as! RBSendOfferViewController
        categoryDetailVC.product = productDetail
        self.navigationController?.pushViewController(categoryDetailVC, animated: true)
    }

    func pushToSellerItemDetails(with sellerProduct: RBSellerProduct, fromController: RBSellerCurrentSellingVC?) {
        let controller: RBSellerItemDetailsVC = RBSellerItemDetailsVC.controllerInstance(with: sellerProduct)
        controller.parentController = fromController
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func pushToItemConfirmationController() {
        let categoryDetailVC = UIStoryboard.sellerStoryboard().instantiateViewController(withIdentifier: itemConfirmationIdentifier) as! RBItemConfirmationViewController
        self.navigationController?.pushViewController(categoryDetailVC, animated: true)
    }

    func pushToViewSellerOfferController(productDetail: RBProduct) {
        let categoryDetailVC = UIStoryboard.sellerStoryboard().instantiateViewController(withIdentifier: viewSellerIdentifier) as! RBViewSellerOfferViewController
        categoryDetailVC.product = productDetail
        self.navigationController?.pushViewController(categoryDetailVC, animated: true)
    }

    func pushToViewSellerOfferControllerDetail(productDetail: RBSellerProduct, wishlistProduct: RBProduct, parentController: RBViewSellerOfferViewController) {
        let categoryDetailVC = UIStoryboard.sellerStoryboard().instantiateViewController(withIdentifier: viewSellerOfferDetailIdentifier) as! RBViewSellerOfferDetailViewController
        categoryDetailVC.wishlistProduct = wishlistProduct
        categoryDetailVC.product = productDetail
        categoryDetailVC.offerListController = parentController
        self.navigationController?.pushViewController(categoryDetailVC, animated: true)
    }
    
    
//    func presentPayViaPayPal(with completion: @escaping CardAddCompletion) {
//        let storyboard = UIStoryboard.sellerStoryboard()
//        let navigationController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "ProductPaymentCV") as! UINavigationController
//        if let addCardController = navigationController.viewControllers.first as? ProductPaymentCV {
//            addCardController.completion = completion
//        }
//        self.present(navigationController, animated: true, completion: nil)
//    }
    
    

    func presentPayViaCreditCard(with completion: @escaping CardAddCompletion) {
        let storyboard = UIStoryboard.stripeStoryboard()
        let navigationController: UINavigationController = storyboard.instantiateViewController(withIdentifier: addCreditCardNavigationIdentifier) as! UINavigationController
        if let addCardController = navigationController.viewControllers.first as? RBAddCreditCardVC {
            addCardController.completion = completion
        }
        self.present(navigationController, animated: true, completion: nil)
    }

    func pushToCartScreen() {
        let cartController: RBSellerBaseVC = RBSellerBaseVC.controllerInstance()
        if let rootController: UIViewController = self.navigationController?.viewControllers.first {
            self.navigationController?.setViewControllers([rootController, cartController], animated: true)
        } else {
            RBAlert.showWarningAlert(message: "Cannot go to cart")
        }
    }

    func pushToWishListDetailScreen(item: RBProduct, itemIndex: Int, wishlistController: RBBuyerWishListVC?) {
        let controller: RBWishListItemDetailVC = RBWishListItemDetailVC.controllerInstance(with: item, index: itemIndex)
        controller.wishListController = wishlistController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func pushToCurrencySelectorViewController() {
        let controller: RBCurrencySelectorViewController = storyboard?.instantiateViewController(withIdentifier: currencySelectorViewControllerIdentifier) as! RBCurrencySelectorViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
