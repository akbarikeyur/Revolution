//
//  RBSearchItemViewController.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 28/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

extension RBSearchItemViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        page = 1
        self.fetchSearchResult()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { //
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

