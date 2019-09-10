
//
//  RBCustomBadgeView.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 03/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBCustomBadgeView: UIView {

    //MARK: - Variables -
    var badgeCount: Int = 0 {
        didSet {
            self.updateBadgeCount()
        }
    }

    private var initialRect: CGRect = CGRect()

    //MARK: - View life cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        //Add initial rect
        self.initialRect = frame

        //Set up the view
        self.updateViewProperties()
        self.addBadgeLabel()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }

    //MARK: - Private methods -
    private func updateViewProperties() {
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.size.height / 2.0
        self.clipsToBounds = true
        self.tag = 100
    }

    //Add badge label
    private func addBadgeLabel() {

        let badgeLabelRect: CGRect = CGRect(x: 1.5, y: 1.5, width: self.frame.size.height - 3.0, height: self.frame.size.width - 3.0)

        let badgeLabel: UILabel = UILabel.init(frame: badgeLabelRect)
        badgeLabel.backgroundColor = UIColor.init(red: 208.0 / 255.0, green: 1.0 / 255.0, blue: 27.0 / 255.0, alpha: 1.0)
        badgeLabel.textAlignment = NSTextAlignment.center
        badgeLabel.font = UIFont.avenirNextRegular(10.0)
        badgeLabel.textColor = UIColor.white
        badgeLabel.clipsToBounds = true
        badgeLabel.textAlignment = NSTextAlignment.center

        badgeLabel.layer.cornerRadius = (self.frame.height - 3.0) / 2.0
        self.addSubview(badgeLabel)

        self.updateBadgeCount()
    }

    private func updateBadgeCount() {

        //Unhide label
        self.isHidden = false

        if self.badgeCount == 0 {

            self.isHidden = true

        } else if self.badgeCount > 0 && self.badgeCount < 10 {

            self.updateLabelInside(addBy: 0.0)

        } else if self.badgeCount >= 10 && self.badgeCount < 100 {

            self.updateLabelInside(addBy: 8.0)

        } else if self.badgeCount >= 100 && self.badgeCount < 999 {

            self.updateLabelInside(addBy: 16.0)

        } else {

            self.updateLabelInside(addBy: 22.0)

        }
    }

    private func updateLabelInside(addBy: CGFloat) {

        var rectView: CGRect = self.frame
        rectView.size.width = 15.0 + addBy
        self.frame = rectView

        for labelBadgeIcon in self.subviews {
            if let labelBadge: UILabel = labelBadgeIcon as? UILabel {

                var rectLabel: CGRect = labelBadge.frame
                rectLabel.size.width = self.frame.width - 3.0
                labelBadge.frame = rectLabel

                if badgeCount > 999 {
                    labelBadge.text = "999+"
                } else {
                    labelBadge.text = "\(self.badgeCount)"
                }

                break
            }
        }

        self.setNeedsDisplay()
    }
}
