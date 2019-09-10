//
//  ProductPaymentCV.swift
//  RevolutionBuy
//
//  Created by PC on 24/06/19.
//  Copyright © 2019 Appster. All rights reserved.
//

import UIKit


class ProductPaymentCV: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    
    var redirectUrl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        webView.delegate = self
        if redirectUrl != "" {
            webView.loadRequest(URLRequest(url: URL(string: redirectUrl)!))
       //     self.view.showLoader(subTitle: "Processing...")
        }
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print(webView.request?.url)
        self.view.showLoader(subTitle: "Processing...")
        print(webView.request?.url)
        if (webView.request!.url?.absoluteString.contains("http://api.revolutionbuy.com/api/product-payment-success"))! {
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name:NSNotification.Name(rawValue: "paypal_success"), object: nil)
            }
        }
        else if (webView.request!.url?.absoluteString.contains("http://api.revolutionbuy.com/api/product-payment-cancel"))! {
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name:NSNotification.Name(rawValue: "paypal_cancel"), object: nil)
            }
        }
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.view.hideAllLoadersForParticularView()
    }
    
//    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        if (request.url?.absoluteString.contains("http://api.revolutionbuy.com/api/product-payment-success"))! {
//            self.dismiss(animated: true) {
//                NotificationCenter.default.post(name:NSNotification.Name(rawValue: "paypal_success"), object: nil)
//            }
//            return true
//        }
//        else if (request.url?.absoluteString.contains("http://api.revolutionbuy.com/api/product-payment-cancel"))! {
//            self.dismiss(animated: true) {
//                NotificationCenter.default.post(name:NSNotification.Name(rawValue: "paypal_cancel"), object: nil)
//            }
//            return true
//        }
//        return false
//    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
    
    

}
