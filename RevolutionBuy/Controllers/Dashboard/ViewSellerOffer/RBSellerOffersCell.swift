//
//  RBSellerOffersCell.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 11/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBSellerOffersCell: UITableViewCell {

    @IBOutlet weak var lblSellerName: UILabel!
    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Class Methods

    class func identifier() -> String {
        return "RBSellerOffersCellIdentifier"
    }

    func configueCellWithData(data: RBSellerProduct) {

        lblSellerName.text = "By \(data.sellerName())"
        lblAddress.text = "From \(data.cityNameSeller())"
//        lblPrice.text = "$\(data.priceProduct())" // developer commented
        
        if data.description().components(separatedBy: "&&").count > 0 {
            self.lblPrice.text =  data.description().components(separatedBy: "&&")[0] + "\(data.priceProduct())"
        } else {
            lblPrice.text = "$\(data.priceProduct())"
        }
        
        self.imageViewItem.sd_cancelCurrentImageLoad()

        if let images = data.sellerProductImages, images.count > 0, let url = images[0].imageName, let theUrl: URL = URL(string: url) {
            //            imageViewItem.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named:PlaceHolderImage.cartBlueSquare.rawValue))
            self.imageViewItem.rb_setImageFrom(url: theUrl)
        } else {
            imageViewItem.image = UIImage(named: PlaceHolderImage.cartBlueSquare.rawValue)
        }
    }
}
