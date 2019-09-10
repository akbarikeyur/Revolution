//
//  RBBuyerWishListVC+PaginationDelegate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 12/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBBuyerWishListVC: RBPaginationDelegate {

    func loadingStateChanged(state: PaginationLoadingState) {

        self.view.hideLoader()

        switch state {

        case .NotStarted, .EmptyData:
            self.showPaginationLoader(show: false)
            self.noDataView.isHidden = false

        case .LoadingInitial:
            self.view.showLoader(subTitle: Constants.APIKey.loading)
            self.showPaginationLoader(show: false)
            self.noDataView.isHidden = true

        case .LoadingPaging, .NotLoadingHasMoreData:
            self.showPaginationLoader(show: true)
            self.noDataView.isHidden = true

        case .NotLoadingHasNoMoreData:
            self.showPaginationLoader(show: false)
            self.noDataView.isHidden = true
        }
    }
}
