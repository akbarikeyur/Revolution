//
//  RBBuyerWishListVC.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 29/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

protocol RBBuyerWishlistDelegate {
    func addItemClicked()
    func openWishListDetail(wishListController: RBBuyerWishListVC, item: RBProduct, index: Int)
}

class RBBuyerWishListVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var wishlistTableview: UITableView!
    @IBOutlet var footer: UIView!

    //MARK: - Variables
    var refreshControl: UIRefreshControl!
    var myDelegate: RBBuyerWishlistDelegate?
    lazy var dataSource: RBWishListDataSourceController! = {
        return RBWishListDataSourceController(delegate: self)
    }()

    //MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.wishlistTableview.tableFooterView = nil

        self.view.clipsToBounds = true
        self.wishlistTableview.register(UINib(nibName: RBItemTableViewCell.identifier(), bundle: nil), forCellReuseIdentifier: RBItemTableViewCell.identifier())
        self.wishlistTableview.contentInset = UIEdgeInsetsMake(8, 0, 8, 0)
        self.wishlistTableview.estimatedRowHeight = 250
        self.wishlistTableview.rowHeight = UITableViewAutomaticDimension
        self.wishlistTableview.separatorStyle = .none

        // Refresh Controller
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.gray
        self.refreshControl.addTarget(self, action: #selector(refreshList), for: UIControlEvents.valueChanged)
        self.wishlistTableview.addSubview(self.refreshControl)

        // Initial Load API call
        self.addWishlistItems(isRefresh: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let visibleIndexPaths = self.wishlistTableview.indexPathsForVisibleRows, visibleIndexPaths.count > 0 {
            self.wishlistTableview.reloadRows(at: visibleIndexPaths, with: .none)
        }
    }

    //MARK: - Clicks
    @IBAction func clickAddWishListItem(_ sender: UIButton) {
        self.myDelegate?.addItemClicked()
    }

    //MARK: - Methods
    func showHideNoDataView() {
        let hasItemsToShow = self.dataSource.items.count > 0
        self.noDataView.isHidden = hasItemsToShow
        //        self.wishlistTableview.isHidden = !hasItems
    }

    func resetFooter() {
        let hasMoreItemToLoad = self.dataSource.hasMoreResultsToLoad()
        self.noDataView.isHidden = hasMoreItemToLoad
        //        self.wishlistTableview.isHidden = !hasItems
    }

    func showPaginationLoader(show: Bool) {
        if show {
            self.wishlistTableview.tableFooterView = footer
        } else {
            self.wishlistTableview.tableFooterView = nil
        }
    }

    func refreshList() {
        self.addWishlistItems(isRefresh: true)
    }

    func addWishlistItems(isRefresh: Bool) {

        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }

        // Guest user check
        if RBUserManager.sharedManager().isUserGuestUser() {
            return
        }

        self.dataSource.loadMoreItems(isReload: isRefresh) { (loaded, message) in

            if loaded {
                self.wishlistTableview.reloadData()
            } else if message.length > 0 {
                RBAlert.showSuccessAlert(message: message)
            }
        }
    }

    func deleteItem(item: RBProduct, completion: @escaping((_ deleted: Bool) -> ())) {

        self.dataSource.removeItem(item: item) { (removed) in
            if removed {
                self.wishlistTableview.reloadData()
            }
            completion(removed)
        }
    }

    //MARK: - Class Methods
    class func identifier() -> String {
        return "RBBuyerWishListVC"
    }
}
