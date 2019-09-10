//
//  AppDelegate.swift
//  RevolutionBuy
//
//  Created by Arvind Singh on 03/02/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

//        RBProduct.init(map: Nil)?.convertCurrency(selectedCurrency: "USD", finalPrice: "100")
                
        // Setup Logger
        self.setupLogger()
        Fabric.with([Crashlytics.self])

        // Register device for push notification
        self.registerRemoteNotification()

        // Enable inputAccessoryView for all textfields
        self.enableInputAccessoryView()

        // Present application root view controller
        AppDelegate.presentRootControllerOnApplicationLaunch()

        /**
         *  setup facebook with default configuration
         */
        _ = FacebookConfiguration.defaultConfiguration()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        // Initialize event tracker
        AppDelegate.configureAnalyticsOperations()

        //Initialize stripe
        STPPaymentConfiguration.shared().publishableKey =  ConfigurationManager.sharedManager().stripePublishableKey()

        // Setting universal appearances of controls
        setAppearances()

        return true
    }

    func setAppearances() {
        UITextField.appearance().tintColor = UIColor(red: 35.0 / 255.0, green: 66.0 / 255.0, blue: 112.0 / 255.0, alpha: 1.0)
        UITextView.appearance().tintColor = UIColor(red: 35.0 / 255.0, green: 66.0 / 255.0, blue: 112.0 / 255.0, alpha: 1.0)
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
        if (url.scheme?.contains("revolutionpayment"))!{
            RBUserManager.sharedManager().getAppUserID { (status, data, str, error) -> (Void) in
                NotificationCenter.default.post(name:NSNotification.Name(rawValue: "payment_success"), object: nil)
            }
            return true
        }
        else if (url.scheme?.contains("paypalsuccess"))! {
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "paypal_success"), object: nil)
            return true
        }
        else if (url.scheme?.contains("paypalcancel"))! {
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "paypal_cancel"), object: nil)
            return true
        }
        
        LogManager.logDebug(url.absoluteString)

        // Deeplinking
        let deepLinkAbsUrl = Constants.kDeepLinkUrl.lowercased()
        if let hostName = url.host, hostName == Constants.kDeepLinkHost, url.absoluteString.lowercased().range(of: deepLinkAbsUrl) != nil  {
            self.openProductWith(url: url)
            return true
        }

        // Facebook
        return (FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation]))
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

        LogManager.logDebug("app delegate application openURL called url=\(url)")

        // Deeplinking
        if let hostName = url.host, hostName == Constants.kDeepLinkHost {
            return true
        }

        return (FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation))
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        AppDelegate.fetchUnreadNotificationCount()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        //App activation code
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate {

    // MARK: - App Delegate Ref
    class func delegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func switchAppToStoryboard(_ name: String, storyboardId: String) {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: storyboardId)
    }

    // MARK: - Root View Controller
    class func presentRootViewController(_ animated: Bool = false) {

        if animated {
            let animation: CATransition = CATransition()
            animation.duration = CFTimeInterval(0.5)
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.type = kCATransitionMoveIn
            animation.subtype = kCATransitionFromTop
            animation.fillMode = kCAFillModeForwards
            AppDelegate.delegate().window?.layer.add(animation, forKey: "animation")
            AppDelegate.delegate().window?.rootViewController = AppDelegate.rootViewController(viaApplicationLaunch: false)
        } else {
            AppDelegate.delegate().window?.rootViewController = AppDelegate.rootViewController(viaApplicationLaunch: false)
        }
    }

    fileprivate class func presentRootControllerOnApplicationLaunch() {
        if RBUserManager.sharedManager().isUserLoggedIn(), RBUserManager.sharedManager().activeUser.isTemporaryPassword() {
            RBUserManager.sharedManager().deleteActiveUser()
        }
        AppDelegate.delegate().window?.rootViewController = AppDelegate.rootViewController(viaApplicationLaunch: true)
    }

    fileprivate class func rootViewController(viaApplicationLaunch: Bool) -> UIViewController! {

        if RBUserManager.sharedManager().isUserGuestUser() == true {
            return AppDelegate.setDashboardAsIntialController()
        } else if RBUserManager.sharedManager().isUserLoggedIn() {
            return self.rootControllerForLoggenInUser()
        } else if viaApplicationLaunch == false {
            let storyboard = UIStoryboard.mainStoryboard()
            let navigationController: UINavigationController = storyboard.instantiateViewController(withIdentifier: signUpMenuNavigationIdentifier) as! UINavigationController
            return navigationController
        } else {
            let storyboard = UIStoryboard.mainStoryboard()
            let navigationController: UINavigationController = storyboard.instantiateViewController(withIdentifier: onboardingNavigationIdentifier) as! UINavigationController
            return navigationController
        }
    }

    fileprivate class func rootControllerForLoggenInUser() -> UIViewController {

        if RBUserManager.sharedManager().activeUser.hasUserCompletedProfile() == true {
            return self.setDashboardAsIntialController()
        } else {
            let storyboard = UIStoryboard.mainStoryboard()
            let navigationController: UIViewController = storyboard.instantiateViewController(withIdentifier: addProfileContainerIdentifier) as! RBAddProfileContainerViewController
            return navigationController
        }
    }

    private class func setDashboardAsIntialController() -> UIViewController {
        let storyboard: UIStoryboard = UIStoryboard.sellerStoryboard()
        let dashboardTabBarController: RBTabBarController = storyboard.instantiateViewController(withIdentifier: tabbarIdentifier) as! RBTabBarController
        return dashboardTabBarController
    }

    fileprivate func enableInputAccessoryView() {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().toolbarTintColor = UIColor.orange
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
    }

    fileprivate func setupLogger() {
        #if DEBUG
            LogManager.setup(.debug)
        #else
            LogManager.setup(.error)
        #endif
    }
}
extension AppDelegate {
    
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
}
}
