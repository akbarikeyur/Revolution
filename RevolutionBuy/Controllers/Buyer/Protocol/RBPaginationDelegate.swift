//
//  RBPaginationDelegate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 12/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

enum PaginationLoadingState: Int {
    case NotStarted = -1
    case LoadingInitial = 0
    case LoadingPaging = 1
    case NotLoadingHasMoreData = 2
    case NotLoadingHasNoMoreData = 3
    case EmptyData = 4
}

protocol RBPaginationDelegate: class {
    func loadingStateChanged(state: PaginationLoadingState)
}
