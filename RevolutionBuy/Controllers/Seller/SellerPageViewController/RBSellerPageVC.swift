//
//  RBSellerPageVC.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 03/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

protocol RBSellerPageControllerDelegate {
    func buttonSelectedWithTag(_ tag: Int)
}

class RBSellerPageVC: UIPageViewController {

    //MARK: - Variables
    var currentPage: Int = 0
    var baseDelegate: RBSellerPageControllerDelegate?

    lazy var currentController: RBSellerCurrentSellingVC = {
        let controller: RBSellerCurrentSellingVC = UIStoryboard.sellerOfferStoryboard().instantiateViewController(withIdentifier: RBSellerCurrentSellingVC.sellingCellIdentifier()) as! RBSellerCurrentSellingVC
        return controller
    }()

    lazy var soldController: RBSellerSoldVC = {
        let controller: RBSellerSoldVC = UIStoryboard.sellerOfferStoryboard().instantiateViewController(withIdentifier: RBSellerSoldVC.identifier()) as! RBSellerSoldVC
        return controller
    }()

    private(set) lazy var sellerControllersArray: [UIViewController] = {
        return [self.currentController,
            self.soldController]
    }()

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
        if let firstViewController = self.sellerControllersArray.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}

// MARK: - Go to previous and next page

extension RBSellerPageVC {

    func goToNextPage(currentPageNumber: Int, nextPageNumber: Int) {
        let pageDifference: Int = nextPageNumber - currentPageNumber
        for _ in 1 ... pageDifference {

            guard let currentViewController = self.viewControllers?.first else { return }
            guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
            setViewControllers([nextViewController], direction: .forward, animated: false, completion: nil)
            self.currentPage += 1
        }
    }

    func goToPreviousPage(currentPageNumber: Int, nextPageNumber: Int) {

        let pageDifference: Int = currentPageNumber - nextPageNumber
        for _ in 1 ... pageDifference {
            guard let currentViewController = self.viewControllers?.first else { return }
            guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
            setViewControllers([previousViewController], direction: .reverse, animated: false, completion: nil)
            self.currentPage -= 1
        }
    }
}
