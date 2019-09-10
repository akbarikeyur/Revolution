//
//  RBBuyerPageViewController.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 29/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

protocol RBBuyerPageControllerDelegate {
    func buttonSelectedWithTag(_ tag: Int)
    func newItemAddButtonClicked()
    func openWishListDetail(pageController: RBBuyerPageViewController, item: RBProduct, index: Int)
    func openPurchasedDetail(pageController: RBBuyerPageViewController, purchasedItem: RBPurchasedProduct)
}

class RBBuyerPageViewController: UIPageViewController {

    //MARK: - Variables
    lazy var wishListController: RBBuyerWishListVC = {
        let controller: RBBuyerWishListVC = UIStoryboard.buyerStoryboard().instantiateViewController(withIdentifier: RBBuyerWishListVC.identifier()) as! RBBuyerWishListVC
        controller.myDelegate = self
        return controller
    }()

    lazy var purchasedController: RBBuyerPurchasedVC = {
        let controller: RBBuyerPurchasedVC = UIStoryboard.buyerStoryboard().instantiateViewController(withIdentifier: RBBuyerPurchasedVC.identifier()) as! RBBuyerPurchasedVC
        controller.theDelegate = self
        return controller
    }()

    private(set) lazy var buyerControllersArray: [UIViewController] = {

        let vc1 = self.wishListController
        let vc2 = self.purchasedController

        return [vc1,
            vc2]
    }()

    var currentPage: Int = 0
    var baseDelegate: RBBuyerPageControllerDelegate?

    //MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initalizePageControllerClass()
    }

    //MARK: - Methods
    private func initalizePageControllerClass() {

        self.delegate = self
        self.dataSource = self

        //Set first controller
        if let firstViewController = self.buyerControllersArray.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}

// MARK: - Go to previous and next page
extension RBBuyerPageViewController {

    func goToNextPage(crntPageNumber: Int, nxtPageNumber: Int) {
        let pageDiff: Int = nxtPageNumber - crntPageNumber
        for _ in 1 ... pageDiff {

            guard let currentVC = self.viewControllers?.first else { return }
            guard let nextVC = dataSource?.pageViewController(self, viewControllerAfter: currentVC) else { return }
            setViewControllers([nextVC], direction: .forward, animated: false, completion: nil)
            self.currentPage += 1
        }
    }

    func goToPreviousPage(crntPageNumber: Int, nxtPageNumber: Int) {

        let pageDiff: Int = crntPageNumber - nxtPageNumber
        for _ in 1 ... pageDiff {
            guard let currentVC = self.viewControllers?.first else { return }
            guard let previousVC = dataSource?.pageViewController(self, viewControllerBefore: currentVC) else { return }
            setViewControllers([previousVC], direction: .reverse, animated: false, completion: nil)
            self.currentPage -= 1
        }
    }
}
