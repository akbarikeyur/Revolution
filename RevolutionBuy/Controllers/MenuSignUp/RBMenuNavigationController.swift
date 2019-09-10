//
//  RBMenuNavigationController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 26/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

typealias SignUpCompletion = ((_ success: Bool) -> Void)

class RBMenuNavigationController: UINavigationController {

    var signUpCompletion: SignUpCompletion?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func onSignUpCompletion(_ success: Bool) {
        self.signUpCompletion?(success)
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
