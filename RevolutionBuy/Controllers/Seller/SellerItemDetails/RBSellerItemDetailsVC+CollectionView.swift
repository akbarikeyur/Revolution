//
//  RBSellerItemDetailsVC+CollectionView.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 05/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

extension RBSellerItemDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - UICollectionView Delegate and Data Source Methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let theCount = arrImages.count
        if theCount == 0 {
            return 1
        }
        return theCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellDetail = collectionView.dequeueReusableCell(withReuseIdentifier: kRBImageCollectionViewCell, for: indexPath) as! RBImageCollectionViewCell
        if arrImages.count == 0 {
            cellDetail.configureSellerOfferProductCellWithImage(imageData: nil)
        } else {
            cellDetail.configureSellerOfferProductCellWithImage(imageData: arrImages[indexPath.row])
        }
        return cellDetail
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

