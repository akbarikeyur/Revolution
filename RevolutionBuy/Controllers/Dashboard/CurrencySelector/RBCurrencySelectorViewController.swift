//
//  RBCurrencySelectorViewController.swift
//  RevolutionBuy
//
//  Created by Rahul Chona  on 05/09/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

// MARK: - Constants

let kRBCurrencySelectorCellIdentifier = "Cell"
typealias SelectCurrencyCompletionHandler = ([String: AnyObject]?, NSError?) -> Void

class RBCurrencySelectorViewController: UIViewController {

    
    // MARK: - IBOUTLETS
    
    @IBOutlet weak var vmNavBar: ShadowView!
    @IBOutlet weak var tableView: UITableView!

    
    // MARK: - Variables
    
//    var listOfCountriesAndCurrencies : [String:String]?
    var listOfCountriesAndCurrencies : [String]?
    var sortedCountriesList : [String]?
    var filtedCountriesList : [String]?
    var selectCurrencyCompletionHandler: SelectCurrencyCompletionHandler?
    
    
    // MARK: - VIEWCONTROLLER LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addShadowUnderNavBarItemDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK:- ACTIONS
    
    @IBAction func goBack(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: SETUP UI
    //Add shadow to navigation view
    func addShadowUnderNavBarItemDetails() {
        self.vmNavBar.layer.shadowColor = UIColor.black.cgColor
        vmNavBar.layer.shadowOffset = CGSize(width: 0, height: -10)
        vmNavBar.layer.shadowOpacity = 1
        vmNavBar.layer.shadowRadius = 10
        vmNavBar.layer.shadowPath = UIBezierPath(rect: vmNavBar.bounds).cgPath
    }
}

extension RBCurrencySelectorViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableView Delegate and Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if filtedCountriesList?.count ?? 0 > 0 {
        if filtedCountriesList != nil {
            return filtedCountriesList?.count ?? 0
        } else {
//            return getListOfCountriesAndCurrencies()?.keys.count ?? 0
            return getListOfCountriesAndCurrencies()?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RBCurrencySelectorTableViewCell = tableView.dequeueReusableCell(withIdentifier: kRBCurrencySelectorCellIdentifier) as! RBCurrencySelectorTableViewCell

        if filtedCountriesList?.count ?? 0 > 0 {

//            let currency = listOfCountriesAndCurrencies?[(filtedCountriesList?[indexPath.row]) ?? ""]
            cell.txtfCountry.text = ((filtedCountriesList?[indexPath.row]) ?? "") // Country
//            cell.txtfCurrency?.text = (currency ?? "") // Currency

        } else {

//            let currency = listOfCountriesAndCurrencies?[(sortedCountriesList?[indexPath.row]) ?? ""]
            cell.txtfCountry.text = ((sortedCountriesList?[indexPath.row]) ?? "") // Country
//            cell.txtfCurrency?.text = (currency ?? "") // Currency

        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filtedCountriesList?.count ?? 0 > 0 {
//            let currency = listOfCountriesAndCurrencies?[(filtedCountriesList?[indexPath.row]) ?? ""]
            var currency = filtedCountriesList?[indexPath.row] ?? ""
            
//            currency = currency.substring(from: currency.characters.index(of: "(")!)
//            currency = currency.replace("(", replacementString: "")
//            currency = currency.substring(to: currency.characters.index(of: ")")!)
            currency = currency.components(separatedBy: " ")[0]
            self.selectCurrencyCompletionHandler!(["currency": (currency as AnyObject? )!], nil)
            
        } else {
//            let currency = listOfCountriesAndCurrencies?[(sortedCountriesList?[indexPath.row]) ?? ""]
            var currency = sortedCountriesList?[indexPath.row] ?? ""
//            currency = currency.substring(from: currency.characters.index(of: "(")!)
//            currency = currency.replace("(", replacementString: "")
//            currency = currency.substring(to: currency.characters.index(of: ")")!)
            currency = currency.components(separatedBy: " ")[0]
            self.selectCurrencyCompletionHandler!(["currency": (currency as AnyObject? )!], nil)
            
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
}

// MARK:- COUNTRIES AND CURRIES EXTRACTOR
extension RBCurrencySelectorViewController {
    
//    func getListOfCountriesAndCurrencies() -> [String:String]? {
//        
//        let localeIds = Locale.availableIdentifiers
//        var countryCurrency = [String: String]()
//    
//        for localeId in localeIds {
//            let locale = Locale(identifier: localeId)
//            
//            if let country = locale.regionCode, country.characters.count == 2 {
//                let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: country])
//                let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(country)"
//                
//                if let currency = locale.currencySymbol {
//                    countryCurrency[name] = currency
//                }
//                
//            }
//        }
//        listOfCountriesAndCurrencies = countryCurrency
//        sortedCountriesList = countryCurrency.keys.sorted()
//        return listOfCountriesAndCurrencies
//    }

    func getListOfCountriesAndCurrencies() -> [String]? {
        
        var currencies = Locale.availableIdentifiers
        
        if let path = Bundle.main.path(forResource: "Currencies", ofType: "plist") {
            
            //List of currencies
            if let currenciesArray = NSArray(contentsOfFile: path) as? [String] {
                currencies = currenciesArray
            }
            
        }
        
//        var countryCurrency = [String: String]()
//        
//        for localeId in localeIds {
//            let locale = Locale(identifier: localeId)
//            
//            if let country = locale.regionCode, country.characters.count == 2 {
//                let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: country])
//                let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(country)"
//                
//                if let currency = locale.currencySymbol {
//                    countryCurrency[name] = currency
//                }
//                
//            }
//        }
        listOfCountriesAndCurrencies = currencies
        sortedCountriesList = currencies.sorted()
        return listOfCountriesAndCurrencies
    }

    

    func setCompletionHandler(completion: @escaping SelectCurrencyCompletionHandler) {
        self.selectCurrencyCompletionHandler = completion
    }

}

// MARK:- SEARCH BAR DELEGATE METHODS
extension RBCurrencySelectorViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard searchBar.text != "" else {

            self.view.endEditing(true)
            
            filtedCountriesList = nil
            self.tableView.reloadData()

            return
        }
        
        var filteredCountries = [String]()
        
//        for (key, _) in listOfCountriesAndCurrencies! {
//            if (key ).contains(searchBar.text ?? "") {
//                filteredCountries.append(key)
//            }
//        }
        
        for key in listOfCountriesAndCurrencies! {
            if key.lowercased().contains(searchBar.text?.lowercased() ?? "") {
                filteredCountries.append(key)
            }
        }

        
        filtedCountriesList = filteredCountries.sorted()
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        filtedCountriesList = nil
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        
        var filteredCountries = [String]()
        
//        for (key, _) in listOfCountriesAndCurrencies! {
//            if (key ).contains(searchBar.text ?? "") {
//                filteredCountries.append(key)
//            }
//        }
        
        for key in listOfCountriesAndCurrencies! {
            if key.lowercased().contains(searchBar.text?.lowercased() ?? "") {
                filteredCountries.append(key)
            }
        }

        
        filtedCountriesList = filteredCountries.sorted()
        self.tableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}


