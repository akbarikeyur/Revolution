//
//  RBConstantIdentifier.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 27/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

//MARK: - Seller identifier -

//MARK: - Onboarding -
enum Onboarding {

    enum title: String {
        case first = "Everything is in reverse"
        case second = "Less time searching"
        case third = "Want to sell an item?"
        case fourth = "No listing fees"
    }

    enum subtitle: String {
        case first = "Buyers place items and sellers make the offers."
        case second = "Post items you want to buy then sit back and wait for sellers to respond."
        case third = "View a list of interested buyers then make an offer."
        case fourth = "Items can be placed for free with no time limit."
    }

    enum imageTitle: String {
        case first = "TutorialFirst"
        case second = "TutorialSecond"
        case third = "TutorialThird"
        case fourth = "TutorialFourth"
        case pageControlBold = "PageBoldIcon"
        case pageControlRegular = "PageRegularIcon"
    }

    enum buttonTitle: String {
        case next = "Next"
        case gotIt = "Got It"
    }

}

enum PlaceHolderImage: String {
    case cartGrey = "itemPlaceholderGrey"
    case cartBlueNormal = "itemPlaceholderBlueNormal"
    case cartBlueLong = "itemPlaceholderBlueLong"
    case cartBlueSquare = "itemPlaceholderBlueSquare"
}

enum Seller: String {
    case CategoryPlist = "Categories"
    case plist = "plist"
}

enum Alert: String {
    case reasonOfReportRequired = "Please enter reason for reporting"
    case imageOfProductRequired = "Please select atleast one photo of this product"
    case priceRequired = "You need to enter the price for this item"
    case validPriceRequired = "Please enter valid price"
    case descriptionLengthValidation = "Description cannot be more than 255 characters"
    case reasonOfReportLengthValidation = "Reason of report cannot be more than 255 characters"
    case reportSuccessfullysent = "Report sent"
    case selectCurrency = "Please select a currency."
}

//MARK: - Signup -
enum SignUpIdentifier {

    enum imageTitle: String {
        case revolutionLogo = "revolutionBuyLogo"
        case avatar = "avatarIcon"
    }

    enum title: String {
        case agePermission = "Are you over 18? This is legally required to use the app."
        case agePermissionDenied = "Sorry, you must be over 18 to use this app."
        case addPhoto = "Add Photo"
        case editPhoto = "Edit Photo"
        case gotIt = "Got It"
    }

    enum UserRegistrationType: Int {
        case email = 0, facebook
    }

    enum identifier: String {
        case signingUp = "Signing up"
        case logingIn = "Signing in"
        case generatingOtp = "Generating\nPIN"
        case resendOTP = "Resending\nPIN"
        case verifyingPin = "Verifying\nPIN"
        case generatingPassword = "Generating\npassword"
        case facebookFetch = "Fetching\nFacebook\ninfo"
        case updatingProfile = "Updating\nProfile"
    }

    enum alert: String {
        case enterEmail = "Please enter your email address"
        case enterValidEmail = "Please enter a valid email address"
        case enterPassword = "Please enter password"
        case passwordLength = "Password must be between 5 to 15 characters long"
        case enterFullName = "Please enter your Full Name"
        case enterCorrectFullName = "Only alphabets and spaces are allowed in Full Name"
        case enterAge = "Please enter your age"
        case invalidAge = "You must be 18 years or older to use this app."
        case selectCountry = "Please select your country"
        case selectState = "Please select your state"
        case selectCity = "Please select your city"
        case profileImage = "Please select your profile image"
        case enterMobile = "Please enter your mobile number"
        case enterValidMobile = "Mobile number must start with '+' and country code"
        case enterPin = "Please enter a valid PIN"
        case verifyEmail = "An email has been sent for verification. Please verify your email to login.\nIf you do not find the email in your inbox, please check your spam filter or bulk email folder."
        case unverifiedUser = "You haven't verified email yet. Please verify your email to login."
        case profileSetUp = "Your profile has been set up"
        case currentPassword = "Please enter current password"
        case enterNewPassword = "Please enter new password"
        case enterConfirmPassword = "Please enter confirm password"
        case passwordUnmatched = "New password and confirm password did not match"
    }
}

//MARK: - Terms and Conditions constants -
enum TermsIdentifier {

    enum TermsType: Int {
        case Terms = 0, Privacy
    }

    enum Title: String {
        case Terms = "Terms of Use"
        case Privacy = "Privacy Policy"
    }

    enum Alert: String {
        case Error = "Unable to load the page"
    }

}

//MARK: - Add category Item
enum CategoryList {

    enum Error {
        enum SelectAtleastOneCategory: String {
            case Message = "You need to select at least one category."
            case DismissTitle = "Got It"
        }

        enum MaximumCategorySelected: String {
            case Message = "You can select 5 categories at max."
            case DismissTitle = "Got It"
        }
    }
}

//MARK: - Add Title
enum AddTitleIdentifier {

    enum Error: String {
        case TitleRequired = "You need to have a title for your item."
    }
}

enum AddDescriptionIdentifier {
    
    enum Error: String {
        case TitleRequired = "Please enter item description."
    }
}

//MARK: - Add Image
enum AddImageIdentifier {

    enum RemoveImageAlert: String {
        case Title = "Are you sure you want to remove this photo?"
        case YesTitle = "Remove"
        case CancelTitle = "Cancel"
    }

    enum NoPrimaryImageSelectedAlert: String {
        case Title = "You have not selected a primary image."
        case YesTitle = "Add primary"
        case CancelTitle = "Auto-Adjust"
    }

    enum LoaderText: String {
        case AddingItem = "Adding item"
        case UpdatingItem = "Updating item"
    }
}

//MARK: - Forgot Password
enum ForgotPasswordIdentifier {

    enum forgotPasswordScreenType: Int {
        case forgotPassword = 0, facebookEmail
    }

    enum title: String {
        case forgot = "Forgot Password?"
        case facebook = "Email Required"
    }

    enum subtitle: String {
        case forgot = "Please enter your registered email address below to receive your reset link."
        case facebook = "Please enter email to proceed. We are unable to fetch your email address from facebook."
    }

}

//MARK: - Terms and Conditions -
enum ContactAdminIdentifier {

    enum contact: String {
        case call = "+61447472141"
        case mail = "admin@revolutionbuy.com"
    }

}

//MARK: - Search Area Controller -
enum SearchAreaController {

    enum imageTitle: String {
        case countryIcon = "countryIcon"
        case stateIcon = "stateIcon"
        case cityIcon = "cityIcon"
    }

}

//MARK: - Analytics Identifier -
enum AnalyticsIdentifier {

    enum userType: String {
        case facebook = "Facebook"
        case email = "Email"
    }

    enum eventName: String {
        case signUpEvent = "SignUp Event"
        case sucessfullDeal = "Succesfull Deal"
    }
}

//MARK: - Seller Account Controller -
enum SellerAccountIdentifier {

    enum imageTitle: String {
        case accountConnected = "accountConnectedIcon"
        case accountDisconnected = "accountDisconnectedIcon"
    }

    enum text: String {
        case accountConnected = "You have connected to PayPal account. Enjoy your online transaction."
        case accountDisconnected = "Tap the button below to start connecting to PayPal and start an online transaction."
    }

    enum buttonTitle: String {
        case accountConnected = "Connect to PayPal"
        case accountDisconnected = "Update PayPal account"
    }

}

//MARK: -
enum WishListDetailIdentifier {

    enum LoaderText: String {
        case Deleting = "Deleting"
    }
}

//MARK: - Notification Controller -
enum NotificationIdentifier {

    /**
     notificationType - Type of notification to be handled
     1. offerSentBySeller = Seller has sent offer on product posted by buyer.
     2. buyerUnlockedDetails = Buyer has unlocked seller's details.
     3. buyerMarkedTransactionAsComplete = Buyer has confirmed the purchase of offer sent by seller.
     4. productSoldByAnotherSeller = Buyer has purhased product from another seller.
     5. sellerMarkedTransactionAsComplete = Seller has confirmed the selling of his product.
     */
    enum notificationType: Int {
        case offerSentBySeller = 1
        case buyerUnlockedDetails = 2
        case buyerMarkedTransactionAsComplete = 3
        case productSoldByAnotherSeller = 4
        case sellerMarkedTransactionAsComplete = 5
    }
}
