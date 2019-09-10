//
//  RBSellerPageVC+PageViewController.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 03/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

extension RBSellerPageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate  {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = self.sellerControllersArray.index(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }

        guard self.sellerControllersArray.count > previousIndex else {
            return nil
        }

        return self.sellerControllersArray[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = self.sellerControllersArray.index(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = self.sellerControllersArray.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }

        return self.sellerControllersArray[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if let pageContentViewController = pageViewController.viewControllers?[0], let index = self.sellerControllersArray.index(of: pageContentViewController) {
            self.currentPage = index
            self.baseDelegate?.buttonSelectedWithTag(index)
        }
    }
}
