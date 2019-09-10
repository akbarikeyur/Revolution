//
//  RBSearchItemViewController.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 28/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBSearchItemViewController: UIViewController {

    //MARK: -----------Outlets-----------------

    @IBOutlet weak var tableViewSearch: UITableView!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var viewPlaceholder: UIView!
    @IBOutlet weak var imageViewPlaceholder: UIImageView!
    @IBOutlet weak var lblPlaceholder: UILabel!

    //MARK: -----------Variables---------------

    let primaryPlaceholderImage: String = "searchPlaceholder"
    let noResultPlaceholderImage: String = "searchNoResult"
    let primaryPlaceholderText: String = "Search for items you want to sell"
    let noResultPlaceholderText: String = "Sorry, there are no interested buyers for that right now. Try again later."
    var productList: [RBProduct] = []
    var page: Int = 1

    //MARK: -----------View Life Cycle--------

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    //MARK: -----------Private Methods---------

    func initialize() {

        tableViewSearch.register(UINib(nibName: "RBItemTableViewCell", bundle: nil), forCellReuseIdentifier: "RBItemTableViewCell")
        tableViewSearch.contentInset = UIEdgeInsetsMake(8, 0, 8, 0)
        tableViewSearch.estimatedRowHeight = 57
        tableViewSearch.rowHeight = UITableViewAutomaticDimension
        tableViewSearch.separatorStyle = .none
        tableViewSearch.reloadData()

        viewPlaceholder.backgroundColor = UIColor.clear
        hidePlaceholder(isHidden: false, isSuccess: false)

        tableViewSearch.addInfiniteScrollingWithHandler { () -> () in
            self.fetchSearchResult()
        }
    }

    func hidePlaceholder(isHidden: Bool, isSuccess: Bool) {

        if isSuccess {
            imageViewPlaceholder.image = UIImage(named: noResultPlaceholderImage)
            lblPlaceholder.text = noResultPlaceholderText
        } else {
            imageViewPlaceholder.image = UIImage(named: primaryPlaceholderImage)
            lblPlaceholder.text = primaryPlaceholderText }

        if isHidden { viewPlaceholder.isHidden = true } else { viewPlaceholder.isHidden = false }
    }

    //MARK: -----------Private Method---------

    func fetchSearchResult() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(RBSearchItemViewController.fetchResult), object: nil)
        self.perform(#selector(RBSearchItemViewController.fetchResult), with: nil, afterDelay: 1.5)
    }

    func fetchResult() {

        if self.textFieldSearch.text == nil || (self.textFieldSearch.text?.trimmed().characters.count)! == 0 {
            stopPagination()
            return
        }

        let params = [Constants.APIKey.limit: Constants.APIKey.limitValue, Constants.APIKey.keyword: textFieldSearch.text ?? "", Constants.APIKey.page: page] as [String: Any]
        LogManager.logDebug("\(params)")
        RBCategoryItemRecords.searchProduct(params: params as [String: AnyObject]) { (success, error, data, message) -> (Void) in

            DispatchQueue.main.async {
                () -> Void in
                self.stopPagination()
            }

            if success {

                if self.page == 1 {
                    self.productList.removeAll()
                }
                self.page = self.page + 1

                if let productsList = data?.product {
                    self.productList.append(contentsOf: productsList)
                }
                self.tableViewSearch.reloadData()
            } else {
                RBAlert.showWarningAlert(message: message, completion: nil)
            }

            if self.productList.count > 0 {
                self.hidePlaceholder(isHidden: true, isSuccess: success)
            } else {
                self.hidePlaceholder(isHidden: false, isSuccess: success)
            }
        }

    }

    func stopPagination() {
        if self.tableViewSearch.infiniteScrollingView != nil {
            self.tableViewSearch.infiniteScrollingView!.stopAnimating()
        }
    }

    //MARK: -----------Actions---------

    @IBAction func cancelBtnAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

}

