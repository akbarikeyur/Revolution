//
//  RBBuyerPurchasedVC+PaginationDelegate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 20/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBBuyerPurchasedVC: RBPaginationDelegate {

    func loadingStateChanged(state: PaginationLoadingState) {

        self.view.hideLoader()

        switch state {

        case .NotStarted, .EmptyData:
            self.showPaginationLoaderView(shouldShow: false)
            self.noDataView.isHidden = false

        case .LoadingInitial:
            self.view.showLoader(subTitle: Constants.APIKey.loading)
            self.showPaginationLoaderView(shouldShow: false)
            self.noDataView.isHidden = true

        case .LoadingPaging, .NotLoadingHasMoreData:
            self.showPaginationLoaderView(shouldShow: true)
            self.noDataView.isHidden = true

        case .NotLoadingHasNoMoreData:
            self.showPaginationLoaderView(shouldShow: false)
            self.noDataView.isHidden = true
        }
    }
}
