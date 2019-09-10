//
//  RBCustomLabel.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 30/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@IBDesignable
class RBCustomLabel: UILabel {

    //MARK: - View life cycle -
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    //MARK: - For Text Spacing -
    @IBInspectable var lineSpacingHeight: CGFloat = 1.0
    @IBInspectable var characterSpacingHeight: CGFloat = 0.0

    //MARK: - Text
    override internal var text: String? {

        didSet {
            self.updateTextAttributes()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateTextAttributes()
    }

    //MARK: - Update attributes -
    func updateTextAttributes() {

        if let string = self.text {
            let paragraphStyle = NSMutableParagraphStyle()

            paragraphStyle.lineSpacing = self.lineSpacingHeight
            paragraphStyle.alignment = self.textAlignment

            let attrString = NSMutableAttributedString(string: string)

            attrString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, string.length))
            attrString.addAttribute(NSKernAttributeName, value: self.characterSpacingHeight, range: NSMakeRange(0, string.length))

            self.attributedText = attrString
        }
    }
}
