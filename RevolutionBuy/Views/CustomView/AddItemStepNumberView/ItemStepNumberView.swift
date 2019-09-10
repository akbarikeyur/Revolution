//
//  ItemStepNumberView.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 30/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class ItemStepNumberView: UIView {

    //MARK: - Outlets
    @IBOutlet weak var stepOneLabel: UILabel!
    @IBOutlet weak var stepTwoLabel: UILabel!
    @IBOutlet weak var stepThreeLabel: UILabel!
    @IBOutlet weak var stepFourLabel: UILabel!

    @IBOutlet var stepLabels: [UILabel]!

    @IBOutlet weak var stepView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        LogManager.logDebug("awaken")
    }
}
