//
//  RBAddItemBaseVC.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 30/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

protocol RBAddItemDelegate: class {
    func newItemAddedFromServer(with newItem: RBProduct)
    func itemUpdatedFromServer(with updatedItem: RBProduct)
    func dismissItemAddition()
}

class RBAddItemBaseVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var stepNumberView: RBAddItemStepNumberView!

    //MARK: - Variables
    weak var addEditDelegate: RBAddItemDelegate?
    var naviController: UINavigationController?
    var tempItem: RBTempItem = RBTempItem.init()

    //MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Class Methods
    class func instanceController() -> RBAddItemBaseVC {
        let controller: RBAddItemBaseVC = UIStoryboard.addItemStoryboard().instantiateViewController(withIdentifier: RBAddItemBaseVC.identifier()) as! RBAddItemBaseVC
        return controller
    }

    class func identifier() -> String {
        return "RBAddItemBaseVC"
    }

    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == Constants.Segue.kSegueToSelectCategory.rawValue, let navi = segue.destination as? UINavigationController {
            self.naviController = navi

            if let rootController = navi.viewControllers.first as? RBAddItemSelectCategoryListVC {
                rootController.addEditBaseController = self
            }
        }
    }
}
