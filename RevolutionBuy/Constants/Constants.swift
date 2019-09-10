//
//  Constants.swift
//
//  Created by Sourabh Bhardwaj on 01/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

let UserDefaults = Foundation.UserDefaults.standard
struct Constants {

    static let kDeepLinkHost = "RevoultionBuyHost"
    static let kDeepLinkUrl = "RevBuyDeepLink://RevoultionBuyHost?itemId="

    static let kAppId = "1220281025"

    static let DEFAULT_SCREEN_RATIO: CGFloat = 375.0
    static let KSCREEN_WIDTH: CGFloat = UIScreen.main.bounds.size.width
    static let KSCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.size.height

    struct ScreenSize {
        static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

    }

    static let KSCREEN_WIDTH_RATIO: CGFloat = UIScreen.main.bounds.size.width / 375.0
    static let KSCREEN_HEIGHT_RATIO: CGFloat = UIScreen.main.bounds.size.height / 667.0

    static let stripeBaseURL: String = "https://connect.stripe.com/oauth/authorize?response_type=code&scope=read_write&client_id=" + ConfigurationManager.sharedManager().stripeClientId() + "&state="

    // MARK: Api keys
    struct APIKey {
        static let catId = "catId"
        static let page = "page"
        static let keyword = "keyword"
        static let description = "description"
        static let buyerProductId = "buyerProductId"
        static let price = "price"
        static let key = "key"
        static let fileName = "fileName"
        static let value = "value"
        static let contentType = "contentType"
        static let loading = "Loading..."
        static let refreshing = "Refreshing..."
        static let limit = "limit"
        static let limitValue = "20"
        static let stateId = "stateId"
        static let countryId = "countryId"
        static let id = "id"
    }
    
    
    // FOR FB USER LOGIN
    
    struct FBUserLoginData{
        static let city = "city"
        static let country = "country"
        static let state = "state"
        static let birthday = "birthday"
    }
    
    //payment
    static let PAYMENT_API = "https://api.revolutionbuy.com/api/paypal-connect"//"http://technlogi.com/dev/revbuy/API/payment.php/"
    

    // MARK: APIServices
    struct APIServices {
        static let termsAndConditons = Constants.APIServices.apiURL("terms-conditions")
        static let privacyPolicy = Constants.APIServices.apiURL("privacy-policies")

        static let sigupAPI: String = Constants.APIServices.apiURL("users/sign-up")
        static let loginAPI = Constants.APIServices.apiURL("users/sign-in")
        static let createMobileOTPAPI = Constants.APIServices.apiURL("users/mobile-pin")
        static let addProfileWithVerifyPinAPI = Constants.APIServices.apiURL("users/add-profile")
        static let logoutAPI = Constants.APIServices.apiURL("users/logout")
        static let resetPasswordAPI = Constants.APIServices.apiURL("users/forget-password")
        static let resetNewPasswordAPI = Constants.APIServices.apiURL("users/reset-password")
        static let socialLoginAPI = Constants.APIServices.apiURL("users/fb-sign-up")
        static let changePasswordAPI = Constants.APIServices.apiURL("users/change-password")
        static let verifyChangeMobileNumberPINAPI = Constants.APIServices.apiURL("users/verify-mobile")
        static let editProfileAPI = Constants.APIServices.apiURL("users/edit-profile")
        static let updateDeviceTokenAPI = Constants.APIServices.apiURL("users/update-device-token")
        static let unreadNotificationCountAPI = Constants.APIServices.apiURL("users/unread-notification")
        static let fetchNotificationDetailAPI = Constants.APIServices.apiURL("users/read-notification")
        static let fetchProfileDetailsAPI = Constants.APIServices.apiURL("users/profile")

        static let productSearchAPI = Constants.APIServices.apiURL("products/search")
        static let productReportBySellerAPI = Constants.APIServices.apiURL("products/seller-reports")
        static let sendOfferBySellerAPI = Constants.APIServices.apiURL("products/seller-products")
        static let notificationListAPI = Constants.APIServices.apiURL("users/notification")
        static let countryListAPI = Constants.APIServices.apiURL("countries")
        static let cityListAPI = Constants.APIServices.apiURL("cities")
        static let stateListAPI = Constants.APIServices.apiURL("states")

        static let createProductURL = Constants.APIServices.apiURL("products/buyer-products")
        static let deleteProductURL = Constants.APIServices.apiURL("products")

        // Wishlist items list
        static let wishlistItemsListURL = Constants.APIServices.apiURL("buyer-wishlist-products")
        static let productDetailURL = Constants.APIServices.apiURL("product/search")

        // Purchased items list
        static let purchasedItemsListURL = Constants.APIServices.apiURL("buyer-purchased-products")

        static let viewSellersOfferAPI = Constants.APIServices.apiURL("products/seller-offers")

        static let unlockPhoneUrl = Constants.APIServices.apiURL("products/unlock-phone")

        static let markTransactionCompleteBuyerUrl = Constants.APIServices.apiURL("products/buyer-complete-transaction")
        static let checkPaymentStatusByBuyer = Constants.APIServices.apiURL("products/check-payment")

        //Stripe connect
        static let stripeRedirectURLAPI = Constants.APIServices.apiURL("stripe-connect")
        static let stripePaymentOnlineAPI = Constants.APIServices.apiURL("products/payment")

        // Seller items list
        static let sellerProductsItemsListURL = Constants.APIServices.apiURL("seller-products")
        static let sellerProductDeleteURL = Constants.APIServices.apiURL("products/delete-enquiry")
        static let markTransactionCompleteSellerUrl = Constants.APIServices.apiURL("products/seller-complete-transaction")

        // Deeplink
        static let deepLinkShareURL = Constants.APIServices.apiURL("share-link?itemId=")

        static func apiURL(_ methodName: String) -> String {
            let BASE_URL = ConfigurationManager.sharedManager().applicationEndPoint()
            return BASE_URL + "/" + methodName
        }
    }

    struct color {
        //Onboarding
        static let onboardingTitleColor: UIColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.87)

        //Button corner radius
        static let buttonCornerRadiusColor: UIColor = UIColor.init(red: 31.0 / 255.0, green: 89.0 / 255.0, blue: 156.0 / 255.0, alpha: 1.0)

        // Theme blue color
        static let themeBlueColor: UIColor = UIColor.init(red: 31.0 / 255.0, green: 89.0 / 255.0, blue: 156.0 / 255.0, alpha: 1.0)
        static let themeDarkBlueColor: UIColor = UIColor.init(red: 34.0 / 255.0, green: 66.0 / 255.0, blue: 112.0 / 255.0, alpha: 1.0)

        //Textfield text color
        static let textFieldTextColor: UIColor = UIColor.init(red: 35.0 / 255.0, green: 66.0 / 255.0, blue: 112.0 / 255.0, alpha: 0.87)
        static let textFieldPlaceholderColor: UIColor = UIColor.init(red: 128.0 / 255.0, green: 149.0 / 255.0, blue: 172.0 / 255.0, alpha: 1.0)
        static let textFieldBorderDefaultColor: UIColor = UIColor.init(red: 224.0 / 255.0, green: 224.0 / 255.0, blue: 224.0 / 255.0, alpha: 1.0)
        static let textFieldBorderWarningColor: UIColor = UIColor.init(red: 208.0 / 255.0, green: 1.0 / 255.0, blue: 27.0 / 255.0, alpha: 1.0)
        static let textFieldImageBackColor: UIColor = UIColor.init(red: 246.0 / 255.0, green: 250.0 / 255.0, blue: 1.0, alpha: 1.0)
        static let textFieldBorderFilledColor: UIColor = UIColor.init(red: 31.0 / 255.0, green: 89.0 / 255.0, blue: 156.0 / 255.0, alpha: 1.0)

        //Blur view color
        static let topBlurColor: UIColor = UIColor.init(red: 226.0 / 255.0, green: 226.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0)

        static let borderColorTextview: UIColor = UIColor.init(red: 224.0 / 255.0, green: 224.0 / 255.0, blue: 224.0 / 255.0, alpha: 0.5)

        static let placeholderTextView: UIColor = UIColor.init(red: 128.0 / 255.0, green: 149.0 / 255.0, blue: 172.0 / 255.0, alpha: 0.5)

        //Add image
        static let borderGreyColor: UIColor = UIColor.init(red: 176.0 / 255.0, green: 176.0 / 255.0, blue: 176.0 / 255.0, alpha: 1.0)

        //UIlabel Active/Inactive
        static let labelActiveColor: UIColor = UIColor.init(red: 31.0 / 255.0, green: 89.0 / 255.0, blue: 156.0 / 255.0, alpha: 1.0)
        static let labelInActiveTextColor: UIColor = UIColor.init(red: 176.0 / 255.0, green: 176.0 / 255.0, blue: 176.0 / 255.0, alpha: 1.0)

        //Profile view components border color
        static let viewProfileComponentBorderColor: UIColor = UIColor.init(red: 176.0 / 255.0, green: 176.0 / 255.0, blue: 176.0 / 255.0, alpha: 50.0)

        //Notification read unread color
        static let notificationReadColor: UIColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        static let notificationUnReadColor: UIColor = UIColor.init(red: 239.0 / 255.0, green: 243.0 / 255.0, blue: 1.0, alpha: 1.0)

        //Seller Product status
        static let soldTextColor: UIColor = UIColor.init(red: 32.0 / 255.0, green: 152.0 / 255.0, blue: 96.0 / 255.0, alpha: 1.0)
        static let soldBackColor: UIColor = UIColor.init(red: 238.0 / 255.0, green: 251.0 / 255.0, blue: 241.0 / 255.0, alpha: 1.0)

        static let offerSentTextColor: UIColor = buttonCornerRadiusColor
        static let offerSentBackColor: UIColor = notificationUnReadColor
    }

    enum Segue: String {
        case kSegueToSelectCategory = "SegueToSelectCategory"
        case kSegueFromSelectCategoryToAddTitle = "SegueFromSelectCategoryToAddTitle"
        case kSegueFromAddTitleToAddDescription = "SegueFromAddTitleToAddDescription"
        case kSegueFromAddDescriptionToAddPictures = "SegueFromAddDescriptionToAddPictures"
    }

    enum NotificationsIdentifier: String {
        case kNotificationItemPurchasedByBuyer = "NotificationItemPurchasedByBuyer"
        case kNotificationItemSoldBySeller = "NotificationItemSoldBySeller"
        case kNotificationItemSoldByBuyerPushNotified = "NotificationItemPurchasedByBuyerPushNotified"
    }

    enum NotificationsObjectIdentifier: String {
        case kWishlistItem = "NotificationsObjectIdentifierWishlistItem"
        case kOfferItem = "NotificationsObjectIdentifierOfferItem"
    }
}
