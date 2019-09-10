//
//  RBAddItemBaseVC+AddItem.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 10/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBAddItemBaseVC {

    func callAddItemToServerAPI() {
        // on success
        // Add new item to addItemDelegate

        //Show Loader
        var loaderText: String = AddImageIdentifier.LoaderText.AddingItem.rawValue
        if self.isEditingAnItem() {
            loaderText = AddImageIdentifier.LoaderText.UpdatingItem.rawValue
        }
        self.view.showLoader(subTitle: loaderText)

        self.tempItem.createItemOnServer { (isCreated, msg, item) in

            //Hide loader
            self.view.hideLoader()

            if isCreated == true && item != nil {

                if self.isEditingAnItem() {
                    self.addEditDelegate?.itemUpdatedFromServer(with: item!)
                } else {
                    self.addEditDelegate?.newItemAddedFromServer(with: item!)
                    self.navigateToItemSuccessController()
                }
            } else {
                RBAlert.showWarningAlert(message: msg, completion: nil)
            }
        }
    }

    func navigateToItemSuccessController() {
        let addItemSuccessCntrlr = RBAddItemSuccessVC.controllerInstance(baseController: self)
        self.present(addItemSuccessCntrlr, animated: true, completion: nil)
    }
}
