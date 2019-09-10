//
//  Address.swift
//
//  Created by Vivek Yadav on 10/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

extension  RBAddress {

    // MARK: Get list of product
    class func fetchAddressWithType(params: [String: AnyObject], type: AddressType, completion: @escaping(_ success: Bool, _ error: Error?, _ data: RBAddress?, _ message: String) -> (Void)) {

        var endPoint = ""
        if type == AddressType.country {
            endPoint = Constants.APIServices.countryListAPI
        } else if type == AddressType.city {
            endPoint = Constants.APIServices.cityListAPI
        } else {
            endPoint = Constants.APIServices.stateListAPI

        }

        RequestManager.sharedManager().performHTTPActionWithMethod(.GET, urlString: endPoint, params: params as [String: AnyObject]?) { (response) -> Void in

            if response.success, let data: RBAddress = Mapper<RBAddress>().map(JSON: (response.resultDictionary?.object(forKey: "result") as? [String: Any])!) {
                completion(true, nil, data, RBGenericMethods.serviceResponseMessage(response: response))
            } else {
                completion(false, nil, nil, RBGenericMethods.serviceResponseMessage(response: response))
            }
        }
    }
}
