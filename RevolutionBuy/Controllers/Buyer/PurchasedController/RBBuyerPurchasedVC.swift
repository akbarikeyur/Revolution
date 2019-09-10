//
//  RBBuyerPurchasedVC.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 29/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

protocol RBBuyerPurchasedDelegate {
    func openPurchasedDetail(purchasedController: RBBuyerPurchasedVC, item: RBPurchasedProduct)
}

class RBBuyerPurchasedVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var purchasedTableview: UITableView!
    @IBOutlet var tableFooter: UIView!

    //MARK: - Variables
    var refreshControl: UIRefreshControl!
    var theDelegate: RBBuyerPurchasedDelegate?
    lazy var dataSource: RBPurchasedDataSourceController! = {
        return RBPurchasedDataSourceController(delegate: self)
    }()

    //MARK: - Variables

    //MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.purchasedTableview.tableFooterView = nil

        self.view.clipsToBounds = true
        self.purchasedTableview.register(UINib(nibName: RBItemTableViewCell.identifier(), bundle: nil), forCellReuseIdentifier: RBItemTableViewCell.identifier())
        self.purchasedTableview.contentInset = UIEdgeInsetsMake(8, 0, 8, 0)
        self.purchasedTableview.estimatedRowHeight = 250
        self.purchasedTableview.rowHeight = UITableViewAutomaticDimension
        self.purchasedTableview.separatorStyle = .none

        // Refresh Controller
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.gray
        self.refreshControl.addTarget(self, action: #selector(refreshPurchasedList), for: UIControlEvents.valueChanged)
        self.purchasedTableview.addSubview(self.refreshControl)

        // Initial Load API call
        self.loadPurchasedItems(isRefresh: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let visibleIndexPaths = self.purchasedTableview.indexPathsForVisibleRows, visibleIndexPaths.count > 0 {
            self.purchasedTableview.reloadRows(at: visibleIndexPaths, with: .none)
        }
    }

    //MARK: - Methods
    func showHideNoDataView() {
        let hasItemsToShow = self.dataSource.items.count > 0
        self.noDataView.isHidden = hasItemsToShow
        //        self.wishlistTableview.isHidden = !hasItems
    }

    func resetTableFooter() {
        let hasMoreItemToLoad = self.dataSource.hasMoreResultsToLoad()
        self.noDataView.isHidden = hasMoreItemToLoad
    }

    func showPaginationLoaderView(shouldShow: Bool) {
        if shouldShow {
            self.purchasedTableview.tableFooterView = tableFooter
        } else {
            self.purchasedTableview.tableFooterView = nil
        }
    }

    func refreshPurchasedList() {
        self.loadPurchasedItems(isRefresh: true)
    }

    func loadPurchasedItems(isRefresh: Bool) {

        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }

        // Guest user check
        if RBUserManager.sharedManager().isUserGuestUser() {
            return
        }

        self.dataSource.loadMoreItems(isReload: isRefresh) { (loaded, message) in

            if loaded {
                self.purchasedTableview.reloadData()
            } else if message.length > 0 {
                RBAlert.showSuccessAlert(message: message)
            }
        }
    }

    //MARK: - Class Methods
    class func identifier() -> String {
        return "RBBuyerPurchasedVC"
    }
}
