//
//  RBSellerSoldVC+PaginationDelegate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 08/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBSellerSoldVC: RBPaginationDelegate {

    func loadingStateChanged(state: PaginationLoadingState) {

        self.view.hideLoader()

        switch state {
        case .NotStarted, .EmptyData:
            self.showPaginationLoader(show: false)
            self.noSoldItemView.isHidden = false

        case .LoadingInitial:
            self.view.showLoader(subTitle: Constants.APIKey.loading)
            self.showPaginationLoader(show: false)
            self.noSoldItemView.isHidden = true

        case .LoadingPaging, .NotLoadingHasMoreData:
            self.showPaginationLoader(show: true)
            self.noSoldItemView.isHidden = true

        case .NotLoadingHasNoMoreData:
            self.showPaginationLoader(show: false)
            self.noSoldItemView.isHidden = true
        }
    }

}
