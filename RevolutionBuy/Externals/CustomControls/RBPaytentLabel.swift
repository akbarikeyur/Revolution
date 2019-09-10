//
//  RBPaytentLabel.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 01/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBPaytentLabel: UILabel {
    
    //MARK: - View life cycle -
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }
    
    override public var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size =  CGSize(width: size.width + 36, height: size.height + 20)
        return size
    }
    
    override func drawText(in rect: CGRect) {
        
        let  myLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        self.setNeedsLayout()
        super.drawText(in: UIEdgeInsetsInsetRect(rect, myLabelInsets))
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height: CGFloat = self.bounds.size.height
        self.layer.cornerRadius = height/2
    }
}
