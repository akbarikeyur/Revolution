//
//  RBAddProfileContainerViewController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 03/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBAddProfileContainerViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var firstLevelLabel: RBActiveInactiveLabel!
    @IBOutlet weak var secondLevelLabel: RBActiveInactiveLabel!

    //MARK: - Variables -
    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Active bottom label -
    func activeBottomLabel(_ shouldActiveFirst: Bool) {
        if shouldActiveFirst == true {
            self.firstLevelLabel.isLabelActive = true
            self.secondLevelLabel.isLabelActive = false
        } else {
            self.firstLevelLabel.isLabelActive = false
            self.secondLevelLabel.isLabelActive = true
        }
    }
}
