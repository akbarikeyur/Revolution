//
//  RBSearchItemViewController.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 28/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import ICSPullToRefresh
class RBCategoriesItemListViewController: UIViewController {

    //MARK: -----------Outlets-----------------

    @IBOutlet weak var tableViewSearch: UITableView!
    @IBOutlet weak var btnTryAnotherCategory: RBCustomButton!
    @IBOutlet weak var viewPlaceholder: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageViewPlaceholder: UIImageView!
    @IBOutlet weak var lblPlaceholder: UILabel!

    //MARK: -----------Variables---------------

    var refreshControl: UIRefreshControl!
    let noProductMessage: String = "There are no interested buyers for this category right now. Try again later."
    var productList: [RBProduct] = []
    var category: RBCategory?
    var page: Int = 1
    var totalProductCount: Int = 0

    //MARK: -----------View Life Cycle--------

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    //MARK: -----------Private Methods---------

    func initialize() {

        viewPlaceholder.backgroundColor = UIColor.clear

        if category != nil {
            lblTitle.text = category?.title
        }
        lblPlaceholder.text = noProductMessage

        tableViewSearch.register(UINib(nibName: "RBItemTableViewCell", bundle: nil), forCellReuseIdentifier: "RBItemTableViewCell")
        tableViewSearch.contentInset = UIEdgeInsetsMake(8, 0, 8, 0)
        tableViewSearch.estimatedRowHeight = 57
        tableViewSearch.rowHeight = UITableViewAutomaticDimension
        tableViewSearch.separatorStyle = .none

        if let image = category?.imageCategoryNotAvailable {
            imageViewPlaceholder.image = UIImage(named: image)
        }

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.tintColor = UIColor.lightGray
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableViewSearch.addSubview(refreshControl)

        hidePlaceholder(isHidden: true)

        self.view.showLoader(mainTitle: "", subTitle: Constants.APIKey.loading)
        self.fetchProductList(isRefresh: false)

        self.addPaginationTableView()

    }


    //MARK: -----------Private Method---------
    func reloadListOnUserThrowBack() {
        self.view.showLoader(mainTitle: "", subTitle: Constants.APIKey.refreshing)
        self.refreshTable(sender: nil)
    }

    func refreshTable(sender: AnyObject?) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(RBCategoriesItemListViewController.fetchProductList), object: false)

        if self.tableViewSearch.infiniteScrollingView != nil {
            self.tableViewSearch.infiniteScrollingView!.stopAnimating()
        }
        self.page = 1
        self.fetchProductList(isRefresh: true)

    }

    private func hidePlaceholder(isHidden: Bool) {
        if isHidden {
            viewPlaceholder.isHidden = true
            btnTryAnotherCategory.isHidden = true
        } else {
            viewPlaceholder.isHidden = false
            btnTryAnotherCategory.isHidden = false
        }
    }

    private func addPaginationTableView() {
        tableViewSearch.addInfiniteScrollingWithHandler { () -> () in

            if self.tableViewSearch.pullToRefreshView != nil {
                self.tableViewSearch.pullToRefreshView?.stopAnimating()
            }
            if self.refreshControl.isRefreshing == false {
                self.fetchProductList(isRefresh: false)
            }
        }
    }

    func fetchProductList(isRefresh: Bool) {

        let params = [Constants.APIKey.limit: Constants.APIKey.limitValue, Constants.APIKey.catId: category?.catId ?? 1, Constants.APIKey.page: page] as [String: Any]
        RBCategoryItemRecords.searchProduct(params: params as [String: AnyObject]) { (success, error, data, message) -> (Void) in

            self.view.hideLoader()
            DispatchQueue.main.async {
                () -> Void in
                self.stopTableViewAnimation()
            }

            if success {
                self.page = self.page + 1

                if let count = data?.totalCount {
                    self.totalProductCount = count
                }

                if isRefresh {
                    self.productList.removeAll()
                }

                if let productsList = data?.product {
                    self.productList.append(contentsOf: productsList)
                }

                self.lblPlaceholder.text = self.noProductMessage
                self.tableViewSearch.reloadData()
            } else {
                self.lblPlaceholder.text = message
            }
            self.updatePlaceholderUI()
        }
    }

    func stopTableViewAnimation() {
        if self.tableViewSearch.infiniteScrollingView != nil {
            self.tableViewSearch.infiniteScrollingView!.stopAnimating()
        }
        refreshControl.endRefreshing()
    }

    func updatePlaceholderUI() {
        if self.productList.count > 0 {
            self.tableViewSearch.isHidden = false
            self.hidePlaceholder(isHidden: true)
        } else {
            self.hidePlaceholder(isHidden: false)
            self.tableViewSearch.isHidden = true
        }
    }

    //MARK: -----------Actions---------

    @IBAction func backBtnAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)

    }

    @IBAction func tryAnotherCategoryBtnAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func categoriesCartAction(_ sender: Any) {
        RBGenericMethods.askGuestUserToSignUp {
            self.pushToCartScreen()
        }
    }
}

