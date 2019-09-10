//
//  RBWishListItemDetailVC+CollectionViewDelegate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 14/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBWishListItemDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - UICollectionView Delegate and Data Source Methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.item.numberOfBuyerImages()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let imgItem = self.item.buyerProductImages?[indexPath.row]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RBImageCollectionViewCell.identifier(), for: indexPath) as! RBImageCollectionViewCell
        cell.configureCellWithImage(imageData: imgItem)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

