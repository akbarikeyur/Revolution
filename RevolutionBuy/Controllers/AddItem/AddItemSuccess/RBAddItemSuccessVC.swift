//
//  RBAddItemSuccessVC.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 02/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBAddItemSuccessVC: UIViewController {

    weak var addEditBaseController: RBAddItemBaseVC?

    //MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: - Class Methods
    class func controllerInstance(baseController: RBAddItemBaseVC?) -> RBAddItemSuccessVC {
        let controller: RBAddItemSuccessVC = UIStoryboard.addItemStoryboard().instantiateViewController(withIdentifier: RBAddItemSuccessVC.identifier()) as! RBAddItemSuccessVC
        controller.addEditBaseController = baseController
        return controller
    }

    class func identifier() -> String {
        return "RBAddItemSuccessVC"
    }

    //MARK: - Clicks
    @IBAction func clickDone(_ sender: UIButton) {
        self.addEditBaseController?.addEditDelegate?.dismissItemAddition()
    }
}
