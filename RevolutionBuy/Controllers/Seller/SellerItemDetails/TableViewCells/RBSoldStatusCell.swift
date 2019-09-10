//
//  RBSoldStatusCell.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 05/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBSoldStatusCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var lblSoldStatus: UILabel!
    @IBOutlet weak var labelContainerView: UIView!

    // MARK: - Instance Methods
    func configureCellWithSellerOffer(offer: RBSellerProduct) {
        self.lblSoldStatus.text = offer.stateString()
        self.lblSoldStatus.textColor = self.textColorForState(state: offer.state)
        self.labelContainerView.backgroundColor = self.backColorForState(state: offer.state)

        self.contentView.layoutIfNeeded()

        // Corner radius from right side only
        let path = UIBezierPath(roundedRect: self.labelContainerView.bounds,
            byRoundingCorners: [.topRight, .bottomRight],
            cornerRadii: CGSize(width: self.labelContainerView.bounds.size.height / 2, height: self.labelContainerView.bounds.size.height / 2))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.labelContainerView.layer.mask = maskLayer
    }

    private func textColorForState(state: SellerProductState) -> UIColor {
        switch state {
        case SellerProductState.ItemSoldToBuyer:
            return Constants.color.soldTextColor
        default:
            return Constants.color.offerSentTextColor
        }
    }

    private func backColorForState(state: SellerProductState) -> UIColor {
        switch state {
        case SellerProductState.ItemSoldToBuyer:
            return Constants.color.soldBackColor
        default:
            return Constants.color.offerSentBackColor
        }
    }

    // MARK: - Class Methods
    class func identifier() -> String {
        return "RBSoldStatusCellIdentifier"
    }
}
