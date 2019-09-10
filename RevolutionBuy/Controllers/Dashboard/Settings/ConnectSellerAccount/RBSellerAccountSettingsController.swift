//
//  RBSellerAccountSettingsController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 04/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBSellerAccountSettingsController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var descriptionLabel: RBCustomLabel!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var connectSellerAccountButton: UIButton!

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.initializeSellerAccountSettingsClass),name: NSNotification.Name(rawValue: "payment_success"), object: nil)
        
        self.initializeSellerAccountSettingsClass()
    }
    
    func openSafariVC() {
        UIApplication.shared.open(URL(string: Constants.PAYMENT_API)!, options: [:]) { (isDone) in
            
        }
    }

    //MARK: - Private method -
    func initializeSellerAccountSettingsClass() {

        if let user: RBUser = RBUserManager.sharedManager().activeUser, user.hasSellerConnectedAccount() {
            self.descriptionLabel.text = SellerAccountIdentifier.text.accountConnected.rawValue
            self.imageLogo.image = UIImage.init(named: SellerAccountIdentifier.imageTitle.accountConnected.rawValue)
            self.connectSellerAccountButton.setTitle(SellerAccountIdentifier.buttonTitle.accountDisconnected.rawValue, for: UIControlState.normal)
        } else {
            self.descriptionLabel.text = SellerAccountIdentifier.text.accountDisconnected.rawValue
            self.imageLogo.image = UIImage.init(named: SellerAccountIdentifier.imageTitle.accountDisconnected.rawValue)
            self.connectSellerAccountButton.setTitle(SellerAccountIdentifier.buttonTitle.accountConnected.rawValue, for: UIControlState.normal)
        }
    }

    //MARK: - IBActions -
    @IBAction func backSellerAccountSettingsAction(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func addSellerAccountSettingsAction(_ sender: AnyObject) {
      //  self.pushToAddStipeAccountController()
        openSafariVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
