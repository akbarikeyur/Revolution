//
//  PXCustomTextField.swift
//  RevolutionBuy
//
//  Created by Appster on 02/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

enum TextFieldType: Int {
    case accurate = 0, warning, filled
}

class RBCustomTextField: JVFloatLabeledTextField {

    //MARK: - Inspectable -
    @IBInspectable var leftPadding: CGFloat = 0.0 {
        didSet {
            self.addLeftPadding(paddingWidth: leftPadding)
        }
    }

    @IBInspectable var leftImage: UIImage = UIImage() {
        didSet {
            self.inputLeftView(img: leftImage)
        }
    }

    @IBInspectable var rightImage: UIImage = UIImage() {
        didSet {
            self.inputRightView(img: rightImage)
        }
    }

    @IBInspectable var currency: String = "AUD" {
        didSet {
            self.inputLeftCurrencyView(currency: currency)
        }
    }
    
    var textFieldType: TextFieldType = TextFieldType.accurate {
        didSet {
            self.changeTextFeildType(type: textFieldType)
        }
    }

    //MARK: - Variable -
    internal let kJVFieldHMargin: CGFloat = 10.0
    internal let kJVFieldFloatingLabelFontSize: CGFloat = 11.0

    var leftImageView: UIImageView = UIImageView()
    var rightImageView: UIImageView = UIImageView()

    var leftLabel: UILabel = UILabel()
    
    //MARK: - View life cycle -
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        //Set textfield configuration
        self.font = UIFont.avenirNextRegular(15.0)
        self.textColor = Constants.color.textFieldTextColor

        //Set Placeholder configuration
        self.floatingLabelTextColor = Constants.color.textFieldPlaceholderColor
        self.floatingLabelActiveTextColor = Constants.color.textFieldPlaceholderColor
        self.floatingLabelFont = UIFont.systemFont(ofSize: 11.0)

        self.updateProperties()

    }

    //MARK: - Fileprivate methods -
    private func inputLeftView(img: UIImage) {
        self.leftViewMode = UITextFieldViewMode.always
        self.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 70, height: 65))
        self.leftView?.backgroundColor = UIColor.white

        leftImageView.frame = CGRect(x: 0, y: 0, width: 54, height: 54)
        leftImageView.contentMode = UIViewContentMode.center
        leftImageView.clipsToBounds = true
        leftImageView.backgroundColor = Constants.color.textFieldImageBackColor
        leftImageView.image = img

        self.removeEarlierSubviews(viewSuperView: self.leftView)
        self.leftView?.addSubview(leftImageView)
    }

    private func inputLeftCurrencyView(currency: String) {
        self.leftViewMode = UITextFieldViewMode.always
        self.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 70, height: 65))
        self.leftView?.backgroundColor = UIColor.white
        
        leftLabel.frame = CGRect(x: 0, y: 0, width: 54, height: 54)
        leftLabel.contentMode = UIViewContentMode.center
        leftLabel.clipsToBounds = true
        leftLabel.backgroundColor = Constants.color.textFieldImageBackColor
        leftLabel.textColor = Constants.color.themeBlueColor
        leftLabel.adjustsFontSizeToFitWidth = true
        leftLabel.text = currency
        leftLabel.textAlignment = .center
        
        self.removeEarlierSubviews(viewSuperView: self.leftView)
        self.leftView?.addSubview(leftLabel)
    }
    
    private func inputRightView(img: UIImage) {
        self.rightViewMode = UITextFieldViewMode.always
        self.rightView = UIView.init(frame: CGRect(x: self.bounds.size.width - 54, y: 0, width: 50, height: 65))
        self.rightView?.backgroundColor = UIColor.white

        rightImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 54)
        rightImageView.contentMode = UIViewContentMode.center
        rightImageView.backgroundColor = UIColor.white
        rightImageView.image = img

        self.removeEarlierSubviews(viewSuperView: self.rightView)
        self.rightView?.addSubview(rightImageView)
    }

    private func changeTextFeildType(type: TextFieldType) {
        switch type {
        case TextFieldType.accurate:
            self.layer.borderColor = Constants.color.textFieldBorderDefaultColor.cgColor

        case TextFieldType.warning:
            self.layer.borderColor = Constants.color.textFieldBorderWarningColor.cgColor

        case TextFieldType.filled:
            self.layer.borderColor = Constants.color.textFieldBorderFilledColor.cgColor

        }
        self.setNeedsLayout()
    }

    private func updateProperties() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 4.0
        self.layer.borderWidth = 0.8
        self.layer.borderColor = Constants.color.textFieldBorderDefaultColor.cgColor
    }

    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }

    private func removeEarlierSubviews(viewSuperView: UIView?) {
        if let earlierSubviews: [UIView] = viewSuperView?.subviews, earlierSubviews.count > 0 {
            for addedView in earlierSubviews {
                addedView.removeFromSuperview()
            }
        }
    }

    //MARK: - Padding
    private func addLeftPadding(paddingWidth: CGFloat) {

        self.removeEarlierSubviews(viewSuperView: self.leftView)

        if paddingWidth >= 0.0 {
            self.leftViewMode = UITextFieldViewMode.always
            self.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: paddingWidth, height: 65))
            self.leftView?.backgroundColor = UIColor.white
            self.leftView?.addSubview(leftImageView)
        }
    }
}
