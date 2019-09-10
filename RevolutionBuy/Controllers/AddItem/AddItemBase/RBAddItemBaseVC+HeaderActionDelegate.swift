//
//  RBAddItemBaseVC+HeaderActionDelegate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 02/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBAddItemBaseVC  {

    func nextClicked() {
        self.stepNumberView.incrementStep()
    }

    func cancelClicked() {
        self.view.endEditing(true)
        let confirmAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: "Confirm", borderType: ConfirmationButtonType.BorderedOnly) {
            self.addEditDelegate?.dismissItemAddition()
        }
        let declineAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: "Cancel")
        RBAlert.showConfirmationAlert(message: "Are you sure you want to dismiss?", leftButtonAttributes: declineAction, rightButtonAttributes: confirmAction)
    }

    func updateCategories(categoryIds: [String]) {
        self.tempItem.categoryIds = categoryIds
    }

    func updateTitle(title: String) {
        self.tempItem.title = title
    }

    func updateDescription(descp: String) {
        self.tempItem.itemDescription = descp
    }

    func updateImages(images: [UIImage?]) {
        self.tempItem.itemImages = images
    }

    func addTempItemToServer() {
        self.callAddItemToServerAPI()
    }

    func isEditingAnItem() -> Bool {
        return self.tempItem.isExisting()
    }
}
