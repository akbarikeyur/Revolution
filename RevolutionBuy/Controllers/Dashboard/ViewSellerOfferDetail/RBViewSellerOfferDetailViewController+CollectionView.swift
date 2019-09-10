//
//  RBViewSellerOfferDetailViewController+CollectionView.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 29/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

extension RBViewSellerOfferDetailViewController {

    // MARK: - UICollectionView Delegate and Data Source Methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrImages.count == 0 {
            return 1
        }
        return arrImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRBImageCollectionViewCell, for: indexPath) as! RBImageCollectionViewCell
        if arrImages.count == 0 {
            cell.configureSellerOfferProductCellWithImage(imageData: nil)
        } else {
            cell.configureSellerOfferProductCellWithImage(imageData: arrImages[indexPath.row])
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
