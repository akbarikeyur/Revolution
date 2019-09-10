
//
//  RBConnectStripeViewController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 04/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBConnectStripeViewController: UIViewController {
    
    //MARK: - IBOutlets -
    @IBOutlet weak var accountWebView: UIWebView!
    
    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let cookieJar = HTTPCookieStorage.shared
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
        
        guard let accessToken: String = RBUserManager.sharedManager().activeUser.accessToken else {
            return
        }
        
        //  let urlStripe: URL = URL.init(string: Constants.stripeBaseURL + accessToken + "&redirect_uri=" + Constants.APIServices.stripeRedirectURLAPI)!
        
        let url : URL = URL.init(string: "https://api.revolutionbuy.com/api/paypal-connect")!
        
        let urlRequest: URLRequest = URLRequest.init(url: url)
        
        self.accountWebView.loadRequest(urlRequest)
    }
    
    //MARK: - IBActions -
    @IBAction func backAccountStripeAction(_ sender: AnyObject) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.popToPreviousContoller(withSuccess: false)
    }
    
    fileprivate func popToPreviousContoller(withSuccess: Bool) {
        
        if let navigationController: UINavigationController = self.navigationController, navigationController.viewControllers.count > 0, withSuccess == true {
            
            for viewController in navigationController.viewControllers {
                if let accountSettingsController: RBSellerAccountSettingsController = viewController as? RBSellerAccountSettingsController {
                    accountSettingsController.initializeSellerAccountSettingsClass()
                    break
                }
                if let addAccountController: RBSellerAccountViewController = viewController as? RBSellerAccountViewController {
                    addAccountController.onSuccessfullCompletionAddingStripeAccount()
                    break
                }
            }
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension RBConnectStripeViewController: UIWebViewDelegate {
    
    // MARK: - UIWebViewDelegate -
    internal func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if request.url?.host == "success" {
            webView.stopLoading()
            self.view.hideLoader()
            
            RBUserManager.sharedManager().activeUser.isSellerAccConnected = 1
            RBUserManager.sharedManager().saveActiveUser()
            RBAlert.showSuccessAlert(message: "You have successfully connected your Paypal account")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.popToPreviousContoller(withSuccess: true)
        }
        
        if request.url?.host == "error" {
            webView.stopLoading()
            self.view.hideLoader()
            
            RBAlert.showWarningAlert(message: "Something went wrong. Try again later")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.popToPreviousContoller(withSuccess: false)
        }
        
        return true
    }
    
    internal func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.view.showLoader(mainTitle: "", subTitle: "Fetching\nPayPal\nContent")
    }
    
    internal func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.view.hideAllLoadersForParticularView()
        
        if let errorThrown: NSError = error as NSError?, errorThrown.code != -999 {
            RBAlert.showWarningAlert(message: error.localizedDescription)
            self.popToPreviousContoller(withSuccess: false)
        }
    }
    
    internal func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.view.hideAllLoadersForParticularView()
    }
    
}
