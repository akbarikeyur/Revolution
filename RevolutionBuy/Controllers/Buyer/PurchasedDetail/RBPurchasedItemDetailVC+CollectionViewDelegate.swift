//
//  RBPurchasedItemDetailVC+CollectionViewDelegate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 24/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBPurchasedItemDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - UICollectionView Delegate and Data Source Methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.purchasedItem.numberOfSellerImages()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let sellerImageItem: RBSellerProductImages = self.purchasedItem.sellerImagesArray()[indexPath.row]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RBImageCollectionViewCell.identifier(), for: indexPath) as! RBImageCollectionViewCell
        cell.configureSellerOfferProductCellWithImage(imageData: sellerImageItem)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
