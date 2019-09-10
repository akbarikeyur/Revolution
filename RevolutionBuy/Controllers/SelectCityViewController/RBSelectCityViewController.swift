//
//  RBSelectCityViewController.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 10/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

typealias AddressCompletionHandler = ((_ areaId: String, _ areaName: String, _ areaCode: String, _ type: AddressType) -> (Void))

enum AddressType: Int {
    case country = 0, state, city
}

class RBSelectCityViewController: UIViewController {

    //MARK: -----------Constants-----------------

    let placeholderImage: String = "searchNoResult"
    let placeholderText: String = "No result found"

    //MARK: -----------Outlets-----------------

    @IBOutlet weak var textFieldSearch: RBCustomTextField!
    @IBOutlet weak var tableViewAddress: UITableView!
    @IBOutlet weak var viewPlaceholder: UIView!
    @IBOutlet weak var imageViewPlaceholder: UIImageView!
    @IBOutlet weak var lblPlaceholder: UILabel!
    @IBOutlet weak var logoSearchImageView: UIImageView!

    //MARK: -----------Variables---------------

    internal var selectionType: AddressType = AddressType.city
    internal var arrayCity: [RBCity] = []
    internal var arrayCountry: [RBCountry] = []
    internal var arrayState: [RBState] = []
    internal var page: Int = 1
    internal var areaIdentifire: String = ""
    internal var addressCompletion: AddressCompletionHandler?

    //MARK: -----------View Life Cycle--------

    override func viewDidLoad() {
        super.viewDidLoad()

        initalizeUI()
        // Do any additional setup after loading the view.
    }

    //MARK: -----------Private Methods---------

    func initalizeUI() {

        viewPlaceholder.backgroundColor = UIColor.clear
        if selectionType == AddressType.city {
            textFieldSearch.placeholder = "City"
            tableViewAddress.addInfiniteScrollingWithHandler { () -> () in

                if self.arrayCity.count > 0 {
                    self.fetchAddress(isPaging: true as AnyObject)
                } else {
                    DispatchQueue.main.async {
                        self.tableViewAddress.infiniteScrollingView?.stopAnimating()
                    }
                }

            }
        } else if selectionType == AddressType.state {
            textFieldSearch.placeholder = "State"
        }

        textFieldSearch.layer.borderColor = UIColor.clear.cgColor
        fetchAddress(isPaging: false as AnyObject)

        self.addSearchLogo(areaSelectionType: self.selectionType)
    }

    func addAddressCompletion(_ areaId: String, _ areaSelectionType: AddressType, completion: @escaping AddressCompletionHandler) {
        self.addressCompletion = completion
        self.areaIdentifire = areaId
        self.selectionType = areaSelectionType
    }

    private func addSearchLogo(areaSelectionType: AddressType) {
        switch areaSelectionType {
        case AddressType.country:
            if let countryImage: UIImage = UIImage.init(named: SearchAreaController.imageTitle.countryIcon.rawValue) {
                self.logoSearchImageView.image = countryImage
            }
        case AddressType.state:
            if let stateImage: UIImage = UIImage.init(named: SearchAreaController.imageTitle.stateIcon.rawValue) {
                self.logoSearchImageView.image = stateImage
            }
        case AddressType.city:
            if let cityImage: UIImage = UIImage.init(named: SearchAreaController.imageTitle.cityIcon.rawValue) {
                self.logoSearchImageView.image = cityImage
            }
        }
    }

    func fetchSearchResult(isPagination: Bool) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(RBSelectCityViewController.fetchAddress), object: isPagination)
        self.perform(#selector(RBSelectCityViewController.fetchAddress), with: isPagination, afterDelay: 1.5)
    }

    func fetchAddress(isPaging: AnyObject) {

        if self.textFieldSearch.text == nil || (self.textFieldSearch.text?.trimmed().characters.count)! == 0 {
            stopPagination()
            return
        }
        let paging: Bool = isPaging as! Bool

        var params = [String: Any]()
        if self.selectionType == AddressType.city {
            params = [Constants.APIKey.keyword: textFieldSearch.text ?? "", Constants.APIKey.stateId: areaIdentifire, Constants.APIKey.page: String(page), Constants.APIKey.limit: Constants.APIKey.limitValue] as [String: Any]
        } else if self.selectionType == AddressType.state {
            params = [Constants.APIKey.keyword: textFieldSearch.text ?? "", Constants.APIKey.countryId: areaIdentifire] as [String: Any]

        } else {
            params = [Constants.APIKey.keyword: textFieldSearch.text ?? "",] as [String: Any]
        }

        RBAddress.fetchAddressWithType(params: params as [String: AnyObject], type: selectionType) { (success, error, data, message) -> (Void) in
            self.view.hideLoader()
            self.stopPagination()
            if success {
                self.page = self.page + 1

                if paging == false {
                    self.arrayCountry.removeAll()
                    self.arrayCity.removeAll()
                    self.arrayState.removeAll()
                }

                self.handleFetchAddressResponse(data: data)
            } else {
                //Toast will be here
            }
            self.updatePlaceholderUI(isSuccess: success, message: message)
        }
    }

    //Handle sucess data of type address
    private func handleFetchAddressResponse(data: RBAddress?) {
        if self.selectionType == AddressType.country, let countryList = data?.country {
            self.arrayCountry.append(contentsOf: countryList)
        } else if self.selectionType == AddressType.state, let stateList = data?.state {
            self.arrayState.append(contentsOf: stateList)
        } else {
            if let cityList = data?.city {
                self.arrayCity.append(contentsOf: cityList)
            }
        }
        self.tableViewAddress.reloadData()
    }

    func updatePlaceholderUI(isSuccess: Bool, message: String) {

        if isSuccess {
            lblPlaceholder.text = placeholderText
        } else {
            lblPlaceholder.text = message
        }

        let rowCount = self.tableViewAddress.numberOfRows(inSection: 0)
        if rowCount > 0 {
            viewPlaceholder.isHidden = true
            tableViewAddress.isHidden = false
        } else {
            viewPlaceholder.isHidden = false
            tableViewAddress.isHidden = true
        }
    }

    func stopPagination() {
        if self.tableViewAddress.infiniteScrollingView != nil {
            self.tableViewAddress.infiniteScrollingView!.stopAnimating()
        }
    }

    //MARK: -----------IBAction Methods---------

    @IBAction func cancelBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    //MARK: -----------Others Methods---------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

