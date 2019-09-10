//
//  RBCityTableViewCell.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 10/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBCityTableViewCell: UITableViewCell {

    @IBOutlet weak var lblAddress: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func identifier() -> String {
        return "RBCityTableViewCell"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configueWithCountry(country: RBCountry) {

        lblAddress.text = country.name
    }

    func configueWithState(state: RBState) {

        lblAddress.text = state.name

    }

    func configueWithCity(city: RBCity) {
        lblAddress.text = city.name

    }

}
