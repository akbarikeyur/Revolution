//
//  RBItemConfirmationViewController.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 04/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBItemConfirmationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func viewItemSellingBtnAction(_ sender: Any) {
        self.pushToCartScreen()
    }

    @IBAction func backToCategoryBtnAction(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
