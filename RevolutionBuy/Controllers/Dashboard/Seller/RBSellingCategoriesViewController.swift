//
//  RBSellingCategoriesViewController.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 27/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit


class RBSellingCategoriesViewController: UIViewController {

    //MARK: -----------Outlets-----------------

    @IBOutlet weak var collectionViewCategories: UICollectionView!
    @IBOutlet weak var cartButton: UIButton!

    //MARK: -----------Variables---------------

    lazy var categoryList: [RBCategory] = {
        return RBCategory.categoryListFromPlist()
    }()
    var arrayCategory: NSMutableArray = NSMutableArray()

    //MARK: -----------View Life Cycle--------

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        self.cartButton.isExclusiveTouch = true
        //   pushTosearchAddress()

    }

    //MARK: -----------Private Methods---------


    func initialize() {
        if let path = Bundle.main.path(forResource: Seller.CategoryPlist.rawValue, ofType: Seller.plist.rawValue), let arr = NSArray(contentsOfFile: path) {
            self.arrayCategory.addObjects(from: arr as [AnyObject])
            self.collectionViewCategories.reloadData()
        }

        let layout = collectionViewCategories.collectionViewLayout as? UICollectionViewFlowLayout // casting is required because UICollectionViewLayout doesn't offer header pin. Its feature of UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchAction(_ sender: AnyObject) {
        // Search action
    }

    @IBAction func cartAction(_ sender: AnyObject) {
        RBGenericMethods.askGuestUserToSignUp {
            self.pushToCartScreen()
        }
    }

}

