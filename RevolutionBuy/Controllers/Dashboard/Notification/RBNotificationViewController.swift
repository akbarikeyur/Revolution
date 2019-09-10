//
//  RBNotificationViewController.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 06/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBNotificationViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var tableViewNotification: UITableView!
    @IBOutlet weak var viewPlaceholder: UIView!
    @IBOutlet weak var lblPlaceholder: UILabel!
    @IBOutlet weak var btnReload: UIButton!

    //MARK: - Variables -
    let placeholderText: String = "No Notifications Yet"
    var refreshControl: UIRefreshControl!
    var notificationList: [RBNotificationDetail] = [RBNotificationDetail]()
    var totalProductCount: Int = 0
    var page: Int = 1

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        //Hide navigation bar
        self.navigationController?.navigationBar.isHidden = true

        initialize()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if RBUserManager.sharedManager().isUserGuestUser() == false {
            self.page = 1

            if let window: UIWindow = self.currentWindowInApplication() {
                window.showLoader(mainTitle: "", subTitle: "Fetching\nlatest\nnotifications")
            } else {
                self.view.showLoader(mainTitle: "", subTitle: "Fetching\nlatest\nnotifications")
            }

            self.fetchProductList(isRefresh: true)
        }
    }

    func initialize() {

        tableViewNotification.tableFooterView = UIView()
        tableViewNotification.estimatedRowHeight = 57
        tableViewNotification.rowHeight = UITableViewAutomaticDimension
        tableViewNotification.reloadData()

        viewPlaceholder.isHidden = true

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.tintColor = UIColor.lightGray
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableViewNotification.addSubview(refreshControl)

        tableViewNotification.addInfiniteScrollingWithHandler { () -> () in

            if self.refreshControl.isRefreshing == false && self.notificationList.count > 0 && self.notificationList.count % 20 == 0 {
                self.fetchProductList(isRefresh: false)

            } else {
                DispatchQueue.main.async {
                    self.tableViewNotification.infiniteScrollingView?.stopAnimating()
                }
            }
        }
    }

    //MARK: -----------Private Method---------
    func refreshTable(sender: AnyObject) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(RBNotificationViewController.fetchProductList), object: false)

        if self.tableViewNotification.infiniteScrollingView != nil {
            self.tableViewNotification.infiniteScrollingView!.stopAnimating()
        }
        self.page = 1
        self.fetchProductList(isRefresh: true)

    }
    func hidePlaceholder(isHidden: Bool) {
        if isHidden {
            // Dont know why this is empty
        } else {
            viewPlaceholder.isHidden = false
        }
    }

    func fetchProductList(isRefresh: Bool) {

        let params = [Constants.APIKey.limit: Constants.APIKey.limitValue, Constants.APIKey.page: String(page)] as [String: Any]
        RBNotificationRecords.fetchNotification(params: params as [String: AnyObject]) { (success, error, data, message) -> (Void) in

            if let window: UIWindow = self.currentWindowInApplication() {
                window.hideAllLoadersForParticularView()
            }
            self.view.hideAllLoadersForParticularView()

            self.stopTableViewAnimation()
            if success {
                self.performAfterNotificationFetchSuccess(isRefresh: isRefresh, data: data)
            } else {
                self.lblPlaceholder.text = message
                self.btnReload.isHidden = false
            }
            self.updatePlaceholderUI()
        }
    }

    func performAfterNotificationFetchSuccess(isRefresh: Bool, data: RBNotificationRecords?) {
        self.page = self.page + 1

        if let count = data?.totalCount {
            self.totalProductCount = count
        }

        if isRefresh {
            self.notificationList.removeAll()
        }

        if let notification: [RBNotificationDetail] = data?.notification {
            self.notificationList.append(contentsOf: notification)
        }

        self.lblPlaceholder.text = self.placeholderText
        self.btnReload.isHidden = true
        self.tableViewNotification.reloadData()

        if let tabController: RBTabBarController = self.tabBarController as? RBTabBarController, let unreadCount: Int = data?.totalUnreadCount {
            tabController.badgeView.badgeCount = unreadCount
            UIApplication.shared.applicationIconBadgeNumber = unreadCount
        }
    }

    func stopTableViewAnimation() {
        if self.tableViewNotification.infiniteScrollingView != nil {
            self.tableViewNotification.infiniteScrollingView!.stopAnimating()
        }
        self.refreshControl.endRefreshing()
    }

    func updatePlaceholderUI() {
        if self.notificationList.count > 0 {
            self.tableViewNotification.isHidden = false
            viewPlaceholder.isHidden = true
        } else {
            self.hidePlaceholder(isHidden: false)
            self.tableViewNotification.isHidden = true
            viewPlaceholder.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func reloadBtnAction(_ sender: Any) {
        self.view.showLoader(mainTitle: "", subTitle: "Fetching\nlatest\nnotifications")
        self.page = 1
        self.fetchProductList(isRefresh: true)
    }

    //MARK: - Window in application -
    private func currentWindowInApplication() -> UIWindow? {
        if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate, let window: UIWindow = appDelegate.window {
            return window
        }
        return nil
    }

}

