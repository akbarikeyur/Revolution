//
//  RBAddDescriptionVC.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 02/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBAddDescriptionVC: UIViewController {

    //MARK: - Variables
    let descriptionMaxLimit = 255
    weak var addEditBaseController: RBAddItemBaseVC?

    //MARK: - Outlets
    @IBOutlet weak var descriptionTextView: RBCustomTextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var headerTitleLabel: UILabel!

    //MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.descriptionTextView.textContainer.lineFragmentPadding = 0
        self.descriptionTextView.textContainerInset = UIEdgeInsets.init(top: 17.0, left: 16.0, bottom: 0.0, right: 16.0)

        self.upadateHeaderAndContentIfNeeded()
        RBGenericMethods.setHeaderButtonExclusive(controller: self)
    }

    //MARK: - Method
    private func proceedToAddImages() {

        self.view.endEditing(true)
        if let description = self.descriptionTextView.text?.trimmed() {
            self.addEditBaseController?.updateDescription(descp: description)
        }
        self.addEditBaseController?.nextClicked()
        self.performSegue(withIdentifier: Constants.Segue.kSegueFromAddDescriptionToAddPictures.rawValue, sender: nil)
    }

    private func upadateHeaderAndContentIfNeeded() {
        if let editController = self.addEditBaseController, editController.isEditingAnItem() {
            self.headerTitleLabel.text = "Edit Description"

            if let desc = editController.tempItem.itemDescription, desc.length > 0 {
                self.descriptionTextView.text = desc
                self.placeholderLabel.isHidden = true
            }
        }
    }

    //MARK: - Clicks
    @IBAction func clickCancel(_ sender: UIButton) {
        self.addEditBaseController?.cancelClicked()
    }

    @IBAction func clickSkipNext(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let title = self.descriptionTextView.text?.trimmed(), title.length > 0 else {
//            self.descriptionTextView.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: AddDescriptionIdentifier.Error.TitleRequired.rawValue)
            return
        }
        
        
        
        self.proceedToAddImages()
    }

    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == Constants.Segue.kSegueFromAddDescriptionToAddPictures.rawValue, let addPhotoController = segue.destination as? RBAddItemPictureVC {
            addPhotoController.addEditBaseController = self.addEditBaseController
        }
    }
}
