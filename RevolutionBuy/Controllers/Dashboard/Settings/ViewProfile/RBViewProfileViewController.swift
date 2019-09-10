
//
//  RBViewProfileViewController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 20/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBViewProfileViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var userProfileImageView:  RBCustomImageView!
    @IBOutlet weak var fullNameLabel:  UILabel!
    @IBOutlet weak var locationLabel:  UILabel!
    @IBOutlet weak var ageLabel:  UILabel!
    @IBOutlet weak var itemsSoldLabel:  UILabel!
    @IBOutlet weak var itemsPurchasedLabel:  UILabel!
    @IBOutlet weak var componentsBackView:  UIView!
    @IBOutlet var locationLabelWidthConstant:  NSLayoutConstraint!

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        //Update address contraints
        self.componentsBackView.layer.borderColor = Constants.color.viewProfileComponentBorderColor.cgColor
        self.locationLabelWidthConstant.constant = Constants.KSCREEN_WIDTH - 42

        self.initializeViewProfileClass()
        self.viewProfilAPICall()
    }

    func initializeViewProfileClass() {
        
        //// From Facebook Log in
        let socialUser = SocialUser()
            print("\(socialUser.name )")
            print("\(socialUser.city)")
            print("\(socialUser.country)")
        
        if let userModel: RBUser = RBUserManager.sharedManager().activeUser {
            self.fullNameLabel.text = userModel.userFullName()
            self.locationLabel.text = userModel.userLocationString()
            self.ageLabel.text = userModel.userAge()
            self.itemsSoldLabel.text = userModel.itemsSoldCount()
            self.itemsPurchasedLabel.text = userModel.itemsPurchasedCount()

            if let imageURL: URL = userModel.userImageUrl() {
                self.userProfileImageView.rb_setImageFrom(url: imageURL, placeholderImage: UIImage.init(named: SignUpIdentifier.imageTitle.avatar.rawValue))
            }
        }
    }

    //MARK: - IBAction -
    @IBAction func backViewProfileAction(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func editProfileAction(_ sender: AnyObject) {
        self.editProfileController(userModel: nil, viaSettings: true)
    }

    func updateEditProfileData() {
        self.initializeViewProfileClass()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension RBViewProfileViewController {
    //MARK: - View profile API -
    fileprivate func viewProfilAPICall() {

        //Show loader
        self.view.showLoader(mainTitle: "", subTitle: "Fetching\nProfile")

        //Fetch profile
        RBUser.viewProfileWithAPI(completion: { (status, error, message, user) -> (Void) in
            //Hide loader
            self.view.hideLoader()

            if status == true && user != nil {
                self.initializeViewProfileClass()
            } else {
                RBAlert.showWarningAlert(message: message, completion: nil)
            }
        })
    }
}
