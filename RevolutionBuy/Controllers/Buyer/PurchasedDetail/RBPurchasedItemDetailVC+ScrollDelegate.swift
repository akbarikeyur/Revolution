//
//  RBPurchasedItemDetailVC+ScrollDelegate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 24/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBPurchasedItemDetailVC {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.detailTableView {

            // Pull to stretch
            let scrollOffsetY: CGFloat = scrollView.contentOffset.y
            if scrollOffsetY < 0.0 {
                let incHeight = 1.0 * abs(scrollOffsetY)
                self.topSpaceCollectionView.constant = 0.0 - incHeight
                self.collectionViewItemImages.reloadData()
            }

            //Navigation header alpha update
            self.checkScrollOffSetForHeaderAnimation()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionViewItemImages, self.purchasedItem.numberOfSellerImages() > 0 {
            let page = self.collectionViewItemImages.contentOffset.x / self.collectionViewItemImages.frame.size.width
            self.pageControl.currentPage = Int(page)
        }
    }
}
