//
//  RBAddDescriptionVC+TextViewDelegate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 06/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBAddDescriptionVC: UITextViewDelegate {

    internal func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return RBGenericMethods.evaluateDescriptionTextView(textView, shouldChangeTextIn: range, replacementText: text, descriptionMaxLimit: self.descriptionMaxLimit)
    }

    internal func textViewDidBeginEditing(_ textView: UITextView) {
        self.placeholderLabel.isHidden = true
    }

    internal func textViewDidEndEditing(_ textView: UITextView) {

        let text = textView.text.trimmed()
        if text.length == 0 {
            self.placeholderLabel.isHidden = false
        }
    }
}
