//
//  RBSelectCityViewController.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 10/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

extension RBSelectCityViewController: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectionType == AddressType.country { return arrayCountry.count }
        if self.selectionType == AddressType.state { return arrayState.count } else { return arrayCity.count }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: RBCityTableViewCell.identifier(), for: indexPath) as! RBCityTableViewCell
        if self.selectionType == AddressType.country { cell.configueWithCountry(country: arrayCountry[indexPath.row])
        } else if self.selectionType == AddressType.state { cell.configueWithState(state: arrayState[indexPath.row])
        } else { cell.configueWithCity(city: arrayCity[indexPath.row]) }
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch self.selectionType {
        case AddressType.country:
            self.addressCompletionWithCountry(indexPath: indexPath)
        case AddressType.state:
            self.addressCompletionWithState(indexPath: indexPath)
        case AddressType.city:
            self.addressCompletionWithCity(indexPath: indexPath)
        }

        self.dismiss(animated: true, completion: nil)

    }

    private func addressCompletionWithCountry(indexPath: IndexPath) {

        if indexPath.row < arrayCountry.count {

            let country: RBCountry = arrayCountry[indexPath.row]

            self.addressCompletion?(country.countryId(), country.countryName(), country.countryCodeName(), selectionType)
        }
    }

    private func addressCompletionWithState(indexPath: IndexPath) {

        if indexPath.row <= arrayState.count {

            let state: RBState = arrayState[indexPath.row]

            self.addressCompletion?(state.stateId(), state.stateName(), "", selectionType)
        }
    }

    private func addressCompletionWithCity(indexPath: IndexPath) {

        if indexPath.row <= arrayCity.count {

            let city: RBCity = arrayCity[indexPath.row]

            self.addressCompletion?(city.cityId(), city.cityName(), "", selectionType)
        }
    }
}
