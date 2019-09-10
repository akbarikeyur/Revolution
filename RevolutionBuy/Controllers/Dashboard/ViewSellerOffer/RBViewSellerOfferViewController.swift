//
//  RBViewSellerOfferViewController.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 11/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import ICSPullToRefresh
class RBViewSellerOfferViewController: UIViewController {

    //MARK: -----------Outlets-----------------

    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tableViewOffer: UITableView!
    @IBOutlet weak var viewPlaceholder: UIView!
    @IBOutlet weak var imageViewPlaceholder: UIImageView!
    @IBOutlet weak var lblPlaceholder: UILabel!

    //MARK: -----------Variables---------------

    var refreshControl: UIRefreshControl!
    let noProductMessage: String = "There are no offer for this product right now. Try again later."
    var productOfferList: [RBSellerProduct] = []
    var page: Int = 1
    var totalProductCount: Int = 0
    var product: RBProduct!

    //MARK: -----------View Life Cycle--------

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    //MARK: -----------Private Methods---------

    func initialize() {

        lblProductName.text = product.fullTitle()
        viewPlaceholder.backgroundColor = UIColor.clear

        lblPlaceholder.text = noProductMessage
        viewHeader.frame.size.height = 32
        tableViewOffer.register(UINib(nibName: "RBSellerOffersCell", bundle: nil), forCellReuseIdentifier: RBSellerOffersCell.identifier())

        tableViewOffer.estimatedRowHeight = 132
        tableViewOffer.rowHeight = UITableViewAutomaticDimension
        tableViewOffer.separatorStyle = .none

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.tintColor = UIColor.lightGray
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableViewOffer.addSubview(refreshControl)

        self.initiateOfferLoad()
        self.addPaginationTableView()
    }

    func initiateOfferLoad() {
        hidePlaceholder(isHidden: true)
        self.view.showLoader(mainTitle: "", subTitle: Constants.APIKey.loading)
        self.fetchProductList()
    }

    //MARK: -----------Private Method---------

    func refreshTable(sender: AnyObject) {
        self.page = 1
        cancelPreviousRequest()
        if self.tableViewOffer.infiniteScrollingView != nil {
            self.tableViewOffer.infiniteScrollingView!.stopAnimating()
        }
        self.fetchProductList()
    }

    private func hidePlaceholder(isHidden: Bool) {
        if isHidden {
            viewPlaceholder.isHidden = true
        } else {
            viewPlaceholder.isHidden = false
        }
    }

    private func addPaginationTableView() {
        tableViewOffer.addInfiniteScrollingWithHandler { () -> () in

            self.cancelPreviousRequest()
            if self.tableViewOffer.pullToRefreshView != nil {
                self.tableViewOffer.pullToRefreshView?.stopAnimating()
            }

            if self.refreshControl.isRefreshing == false {
                self.fetchProductListWithPaging()
            }
        }
    }

    func cancelPreviousRequest() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(RBViewSellerOfferViewController.fetchProductList), object: nil)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(RBViewSellerOfferViewController.fetchProductListWithPaging), object: nil)
    }

    func fetchProductList() {
        let params = [Constants.APIKey.limit: Constants.APIKey.limitValue, Constants.APIKey.id: String(describing: product.internalIdentifier!), Constants.APIKey.page: "1"] as [String: Any]
        RBSellerOfferRecords.fetchSellerOffers(params: params as [String: AnyObject]) { (success, error, data, message) -> (Void) in

            self.stopTableViewAnimation()
            if success {
                self.productOfferList.removeAll()
                self.updateData(fetchedData: data)
            } else {
                self.lblPlaceholder.text = message
            }
            self.updatePlaceholderUI()
        }
    }

    func fetchProductListWithPaging() {

        let params = [Constants.APIKey.limit: Constants.APIKey.limitValue, Constants.APIKey.id: String(describing: product.internalIdentifier!), Constants.APIKey.page: String(page)] as [String: Any]
        RBSellerOfferRecords.fetchSellerOffers(params: params as [String: AnyObject]) { (success, error, data, message) -> (Void) in

            DispatchQueue.main.async {
                () -> Void in
                self.stopTableViewAnimation()
            }

            if success {
                self.updateData(fetchedData: data)
            } else {
                self.lblPlaceholder.text = message
                RBAlert.showWarningAlert(message: message, completion: nil)
            }
            self.updatePlaceholderUI()
        }
    }

    func stopTableViewAnimation() {

        self.view.hideLoader()
        if self.tableViewOffer.infiniteScrollingView != nil {
            self.tableViewOffer.infiniteScrollingView!.stopAnimating()
        }
        refreshControl.endRefreshing()
    }

    func updateData(fetchedData: RBSellerOfferRecords?) {
        self.page = self.page + 1

        if let productsList = fetchedData?.sellerProduct {
            self.productOfferList.append(contentsOf: productsList)
            self.product.offerCount = self.productOfferList.count
        }
        self.lblPlaceholder.text = self.noProductMessage
        self.tableViewOffer.reloadData()
    }

    func updatePlaceholderUI() {
        if self.productOfferList.count > 0 {
            //            self.tableViewOffer.isHidden = false
            self.hidePlaceholder(isHidden: true)
        } else {
            self.hidePlaceholder(isHidden: false)
            //            self.tableViewOffer.isHidden = true
        }
    }

    func deleteOfferFromDataSource(offer: RBSellerProduct, completion: @escaping((_ removed: Bool) -> ())) {
        if let theIndex: Int = self.productOfferList.index(where: { $0 === offer }) {
            self.productOfferList.remove(at: theIndex)
            self.tableViewOffer.reloadData()
            self.updatePlaceholderUI()
            completion(true)
        } else {
            completion(false)
        }
    }

    //MARK: -----------Actions---------

    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }

}

