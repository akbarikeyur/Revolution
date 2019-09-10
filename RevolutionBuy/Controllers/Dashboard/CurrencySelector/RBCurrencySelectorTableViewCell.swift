//
//  RBCurrencySelectorTableViewCell.swift
//  RevolutionBuy
//
//  Created by Rahul Chona  on 05/09/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBCurrencySelectorTableViewCell: UITableViewCell {

    //MARK:- IBOUTLETS
    
    @IBOutlet weak var txtfCountry: UILabel!
    @IBOutlet weak var txtfCurrency: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
