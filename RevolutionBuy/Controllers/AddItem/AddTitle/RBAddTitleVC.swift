//
//  RBAddTitleVC.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 02/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBAddTitleVC: UIViewController {

    //MARK: - Variables
    weak var addEditBaseController: RBAddItemBaseVC?

    //MARK: - Outlets
    @IBOutlet weak var titleTextField: RBCustomTextField!
    @IBOutlet weak var headerTitleLabel: UILabel!

    //MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.upadateHeaderAndContentIfNeeded()
        RBGenericMethods.setHeaderButtonExclusive(controller: self)
    }

    //MARK: - Method
    private func pushToAddDescription(with title: String) {
        self.addEditBaseController?.updateTitle(title: title)
        self.addEditBaseController?.nextClicked()
        self.performSegue(withIdentifier: Constants.Segue.kSegueFromAddTitleToAddDescription.rawValue, sender: nil)
    }

    private func upadateHeaderAndContentIfNeeded() {
        if let editController = self.addEditBaseController, editController.isEditingAnItem() {
            self.headerTitleLabel.text = "Edit Title"

            if editController.tempItem.title.length > 0 {
                self.titleTextField.text = editController.tempItem.title
            }
        }
    }

    //MARK: - Clicks
    @IBAction func clickCancel(_ sender: UIButton) {
        self.addEditBaseController?.cancelClicked()
    }

    @IBAction func clickNext(_ sender: UIButton) {

        self.view.endEditing(true)
        guard let title = self.titleTextField.text?.trimmed(), title.length > 0 else {
            self.titleTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: AddTitleIdentifier.Error.TitleRequired.rawValue)
            return
        }

        self.pushToAddDescription(with: title)
    }

    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == Constants.Segue.kSegueFromAddTitleToAddDescription.rawValue, let addDescpController = segue.destination as? RBAddDescriptionVC {
            addDescpController.addEditBaseController = self.addEditBaseController
        }
    }
}
