//
//  RBContactNumberTableViewCell.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 25/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBContactNumberTableViewCell: UITableViewCell {

    @IBOutlet weak var mobileNumberButton: RBCustomButton!

    class func identifier() -> String {
        return "RBContactNumberTableViewCell"
    }
}
