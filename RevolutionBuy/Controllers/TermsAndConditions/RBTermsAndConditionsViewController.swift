
//
//  RBTermsAndConditionsViewController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 30/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBTermsAndConditionsViewController: UIViewController, UIWebViewDelegate {

    // MARK: - Parameters
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var shadowTopView: ShadowView!

    // MARK: - variable
    var typeTerms: TermsIdentifier.TermsType = TermsIdentifier.TermsType.Terms

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if typeTerms.rawValue == TermsIdentifier.TermsType.Terms.rawValue {
            self.openTermsAndConditions()
        } else {
            self.openPrivacyPolicy()
        }
    }

    //MARK: - Private methods -
    private func openTermsAndConditions() {
        self.headerLabel.text = TermsIdentifier.Title.Terms.rawValue

        let request = URLRequest.init(url: URL.init(string: Constants.APIServices.termsAndConditons)!)
        self.webView.loadRequest(request)
    }

    private func openPrivacyPolicy() {
        self.headerLabel.text = TermsIdentifier.Title.Privacy.rawValue

        let request = URLRequest.init(url: URL.init(string: Constants.APIServices.privacyPolicy)!)
        self.webView.loadRequest(request)
    }

    //MARK: - IBActions -
    @IBAction func clickBackAction(sender: AnyObject) {

        if UIApplication.shared.isNetworkActivityIndicatorVisible {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        _ = self.navigationController?.popViewController(animated: true)
    }

    // MARK: - UIWebViewDelegate -
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.dismiss(animated: true, completion: nil)
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
