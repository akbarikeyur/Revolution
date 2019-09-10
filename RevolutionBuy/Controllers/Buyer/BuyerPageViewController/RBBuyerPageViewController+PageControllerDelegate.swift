//
//  RBBuyerPageViewController+PageControllerDelegate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 30/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

//MARK: - UIPageViewControllerDataSource
extension RBBuyerPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = self.buyerControllersArray.index(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }

        guard self.buyerControllersArray.count > previousIndex else {
            return nil
        }

        return self.buyerControllersArray[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = self.buyerControllersArray.index(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = self.buyerControllersArray.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }

        return self.buyerControllersArray[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if let pageContentViewController = pageViewController.viewControllers?[0], let index = self.buyerControllersArray.index(of: pageContentViewController) {
            self.currentPage = index
            self.baseDelegate?.buttonSelectedWithTag(index)
        }
    }
}
