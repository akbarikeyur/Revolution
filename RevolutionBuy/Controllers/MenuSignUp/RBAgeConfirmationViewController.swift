//
//  RBAgeConfirmationViewController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 29/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBAgeConfirmationViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var ageAcceptedButton: UIButton!
    @IBOutlet weak var ageRejectedButton: UIButton!
    @IBOutlet weak var ageConfirmationLabel: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    var isFromGuestUser: Bool = false
    
    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    //MARK: - IBActions -
    @IBAction func ageAcceptedAction(sender: AnyObject) {
        pushToSignUp()
    }

    @IBAction func ageRejectedAction(sender: AnyObject) {
        self.ageConfirmationLabel.text = SignUpIdentifier.title.agePermissionDenied.rawValue
        self.ageRejectedButton.isHidden = true
        self.ageAcceptedButton.isHidden = true
    }

    @IBAction func ageConfirmationBackAction(sender: AnyObject) {
        if isFromGuestUser == true{
            self.dismiss(animated: true, completion: nil)
        }else{
            _ = self.navigationController?.popViewController(animated: true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
