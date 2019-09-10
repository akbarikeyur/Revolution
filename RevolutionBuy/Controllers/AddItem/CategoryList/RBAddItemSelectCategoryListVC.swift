//
//  RBAddItemSelectCategoryListVC.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 30/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBAddItemSelectCategoryListVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var headerTitleLabel: UILabel!

    @IBOutlet weak var categoryListTableview: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    //MARK: - Variables
    let maxCategorySelectNum = 5
    weak var addEditBaseController: RBAddItemBaseVC?
    var selectedCategories: NSMutableSet = NSMutableSet()
    lazy var categoryList: [RBCategory] = {
        return RBCategory.categoryListFromPlist()
    }()

    //MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        self.upadateHeaderAndContentIfNeeded()

        // Exclusive touch
        self.nextButton.isExclusiveTouch = true
        self.cancelButton.isExclusiveTouch = true
        self.categoryListTableview.isExclusiveTouch = true
    }

    //MARK: - Methods
    private func pushToNextController(with categoryIds: [String]) {
        self.addEditBaseController?.updateCategories(categoryIds: categoryIds)
        self.addEditBaseController?.nextClicked()
        self.performSegue(withIdentifier: Constants.Segue.kSegueFromSelectCategoryToAddTitle.rawValue, sender: nil)
    }

    private func upadateHeaderAndContentIfNeeded() {
        if let editController = self.addEditBaseController, editController.isEditingAnItem() {
            self.headerTitleLabel.text = "Edit Categories"
            self.selectedCategories.addObjects(from: editController.tempItem.categoryIds)
        }
    }

    //MARK: - Clicks
    @IBAction func clickCancel(_ sender: UIButton) {
        self.addEditBaseController?.cancelClicked()
    }

    @IBAction func clickNext(_ sender: UIButton) {

        guard let selCategoryIds: [String] = self.selectedCategories.allObjects as? [String], selCategoryIds.count > 0 else {
            RBAlert.showInfoAlert(message: CategoryList.Error.SelectAtleastOneCategory.Message.rawValue, dismissTitle: CategoryList.Error.SelectAtleastOneCategory.DismissTitle.rawValue)
            return
        }

        self.pushToNextController(with: selCategoryIds)
    }

    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == Constants.Segue.kSegueFromSelectCategoryToAddTitle.rawValue, let addTitleController = segue.destination as? RBAddTitleVC {
            addTitleController.addEditBaseController = self.addEditBaseController
        }
    }
}
