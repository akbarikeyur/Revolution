//
//  RBSellerCurrentSellingVC.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 03/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBSellerCurrentSellingVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var footer: UIView!
    @IBOutlet weak var vwNoItem: UIView!
    @IBOutlet weak var tblCurrentSelling: UITableView!

    // MARK: - Variables
    var refreshControl: UIRefreshControl!
    lazy var dataSource: RBSellerDataSourceController! = {
        return RBSellerDataSourceController(delegate: self, type: SellerItemType.CurrentOffered)
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        self.tblCurrentSelling.register(UINib(nibName: RBSellingItemCell.identifier(), bundle: nil), forCellReuseIdentifier: RBSellingItemCell.identifier())

        // Refresh Controller
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.gray
        self.refreshControl.addTarget(self, action: #selector(refreshSellerCurrentProductList), for: UIControlEvents.valueChanged)
        self.tblCurrentSelling.addSubview(self.refreshControl)

        // Initial Load API call
        self.loadSellerCurrentItems(isRefresh: true)
    }

    // MARK: - Class Methods
    class func sellingCellIdentifier() -> String {
        return "RBSellerCurrentSellingVC"
    }

    // MARK: - Methods
    func showPaginationLoader(show: Bool) {
        if show {
            self.tblCurrentSelling.tableFooterView = footer
        } else {
            self.tblCurrentSelling.tableFooterView = nil
        }
    }

    func refreshSellerCurrentProductList() {
        self.loadSellerCurrentItems(isRefresh: true)
    }

    func deleteOfferFromDatasource(offer: RBSellerProduct) {
        self.dataSource.removeOffer(offer: offer) { (deleted) in
            self.tblCurrentSelling.reloadData()
        }
    }

    // MARK: - API
    func loadSellerCurrentItems(isRefresh: Bool) {

        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }

        // Guest user check
        if RBUserManager.sharedManager().isUserGuestUser() {
            return
        }

        self.dataSource.loadMoreItems(isReload: isRefresh) { (loaded, message) in

            if loaded {
                self.tblCurrentSelling.reloadData()
            } else if message.length > 0 {
                RBAlert.showSuccessAlert(message: message)
            }
        }
    }
}
