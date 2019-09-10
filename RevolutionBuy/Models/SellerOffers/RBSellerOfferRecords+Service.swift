//
//  SellerOfferList.swift
//
//  Created by Vivek Yadav on 12/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

extension RBSellerOfferRecords {

    // MARK: Get list of product
    class func fetchSellerOffers(params: [String: AnyObject], completion: @escaping(_ success: Bool, _ error: Error?, _ data: RBSellerOfferRecords?, _ message: String) -> (Void)) {

        RequestManager.sharedManager().performHTTPActionWithMethod(.GET, urlString: Constants.APIServices.viewSellersOfferAPI, params: params as [String: AnyObject]?) { (response) -> Void in

            if response.success, let data: RBSellerOfferRecords = Mapper<RBSellerOfferRecords>().map(JSON: (response.resultDictionary?.object(forKey: "result") as? [String: Any])!) {
                completion(true, nil, data, RBGenericMethods.serviceResponseMessage(response: response))
            } else {
                completion(false, nil, nil, RBGenericMethods.serviceResponseMessage(response: response))
            }
        }
    }
}
