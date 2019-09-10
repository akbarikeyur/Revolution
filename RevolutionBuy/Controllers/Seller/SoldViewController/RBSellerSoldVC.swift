//
//  RBSellerSoldVC.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 03/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBSellerSoldVC: UIViewController {

    // MARK: - Variables
    var refreshControl: UIRefreshControl!
    lazy var dataSource: RBSellerDataSourceController! = {
        return RBSellerDataSourceController(delegate: self, type: SellerItemType.Sold)
    }()

    // MARK: - IBOutlets
    @IBOutlet var footer: UIView!
    @IBOutlet weak var noSoldItemView: UIView!
    @IBOutlet weak var tblSold: UITableView!

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tblSold.register(UINib(nibName: RBSellingItemCell.identifier(), bundle: nil), forCellReuseIdentifier: RBSellingItemCell.identifier())

        // Refresh Controller
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.gray
        self.refreshControl.addTarget(self, action: #selector(refreshSellerSoldProductList), for: UIControlEvents.valueChanged)
        self.tblSold.addSubview(self.refreshControl)

        // Initial Load API call
        self.loadSellerSoldItems(isRefresh: true)
    }

    // MARK: - Class Methods
    class func identifier() -> String {
        return "RBSellerSoldVC"
    }

    // MARK: - Methods
    func showPaginationLoader(show: Bool) {
        if show {
            self.tblSold.tableFooterView = footer
        } else {
            self.tblSold.tableFooterView = nil
        }
    }

    func refreshSellerSoldProductList() {
        self.loadSellerSoldItems(isRefresh: true)
    }

    // MARK: - API
    func loadSellerSoldItems(isRefresh: Bool) {

        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }

        // Guest user check
        if RBUserManager.sharedManager().isUserGuestUser() {
            return
        }

        self.dataSource.loadMoreItems(isReload: isRefresh) { (loaded, message) in

            if loaded {
                self.tblSold.reloadData()
            } else if message.length > 0 {
                RBAlert.showSuccessAlert(message: message)
            }
        }
    }
}
