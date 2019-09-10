//
//  RBSellingCategoriesViewController.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 27/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

extension RBSellingCategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }

    func collectionView(_ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let category: RBCategory = self.categoryList[indexPath.row]

        let cell: RBSellingCategoriesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RBSellingCategoriesCollectionViewCell", for: indexPath as IndexPath) as! RBSellingCategoriesCollectionViewCell
        //configuring the new cell
        cell.configureCell(item: category)
        return cell

    }

    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.ScreenSize.SCREEN_WIDTH / 2 - 0.5, height: Constants.ScreenSize.SCREEN_WIDTH / 2 - 0.5)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category: RBCategory = self.categoryList[indexPath.row]
        pushToCategoryItemDetail(categoryItem: category)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: Constants.ScreenSize.SCREEN_WIDTH, height: 52)
    }
}

