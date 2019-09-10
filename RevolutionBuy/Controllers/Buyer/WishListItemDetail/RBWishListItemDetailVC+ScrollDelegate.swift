//
//  RBWishListItemDetailVC+ScrollDelegate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 15/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBWishListItemDetailVC {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.itemDetailTableView {

            // Pull to stretch
            let scrollOffsetY: CGFloat = scrollView.contentOffset.y
            if scrollOffsetY < 0.0 {
                let increasedHeight = 1.0 * abs(scrollOffsetY)
                self.topSpaceCollectionView.constant = 0.0 - increasedHeight
                self.collectionViewItemImages.reloadData()
            }

            // Navigation bar animation to white
            self.checkScrollOffSetForHeaderAnimation()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionViewItemImages, self.item.numberOfBuyerImages() > 0 {
            let page = self.collectionViewItemImages.contentOffset.x / self.collectionViewItemImages.frame.size.width
            self.pageControl.currentPage = Int(page)
        }
    }
}
