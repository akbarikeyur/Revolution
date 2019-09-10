//
//  Product+Services.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 12/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import ObjectMapper

typealias WishListFetchCompletion = ((_ success: Bool, _ msg: String, _ result: RBWishListFetchResponse?) -> ())
typealias PurchasedFetchCompletion = ((_ success: Bool, _ msg: String, _ result: RBPurchasedFetchResponse?) -> ())

extension Product {

    // MARK: - Fetch User Purchased Products
    class func fetchPurchasedProducts(offSet: Int, limit: Int, completion: PurchasedFetchCompletion?) {

        //        GET /buyer-wishlist-products?offset=1&limit=5

        var params: [String: String] = [String: String]()
        params.updateValue("\(offSet)", forKey: "offset")
        params.updateValue("\(limit)", forKey: "limit")

        RequestManager.sharedManager().performHTTPActionWithMethod(.GET, urlString: Constants.APIServices.purchasedItemsListURL, params: params as [String: AnyObject]?) { (response) -> Void in

            print(response.success)

            if response.success, let responseDictionary: NSDictionary = response.resultDictionary?.value(forKeyPath: "result") as? NSDictionary, let result: RBPurchasedFetchResponse = Mapper<RBPurchasedFetchResponse>().map(JSON: responseDictionary as! [String: Any]) {
                print(result)
                completion?(true, "", result)
            } else {
                completion?(false, RBGenericMethods.serviceResponseMessage(response: response), nil)
            }
        }
    }

    // MARK: - Fetch User WishList Products
    class func fetchWishListProducts(offSet: Int, limit: Int, completion: WishListFetchCompletion?) {

        //        GET /buyer-wishlist-products?offset=1&limit=5

        var params: [String: String] = [String: String]()
        params.updateValue("\(offSet)", forKey: "offset")
        params.updateValue("\(limit)", forKey: "limit")

        RequestManager.sharedManager().performHTTPActionWithMethod(.GET, urlString: Constants.APIServices.wishlistItemsListURL, params: params as [String: AnyObject]?) { (response) -> Void in

            print(response.success)

            if response.success, let responseDictionary: NSDictionary = response.resultDictionary?.value(forKeyPath: "result") as? NSDictionary, let result: RBWishListFetchResponse = Mapper<RBWishListFetchResponse>().map(JSON: responseDictionary as! [String: Any]) {
                print(result)
                completion?(true, "", result)
            } else {
                completion?(false, RBGenericMethods.serviceResponseMessage(response: response), nil)
            }
        }
    }

    // MARK: - delete WishList Product
    func deleteItemAPI(completion: @escaping((_ deleted: Bool, _ msg: String) -> ())) {

        let urlString: String = Constants.APIServices.deleteProductURL + "/" + "\(self.internalIdentifier!)"

        RequestManager.sharedManager().performHTTPActionWithMethod(.DELETE, urlString: urlString, params: nil) { (response) -> Void in
            completion(response.success, RBGenericMethods.serviceResponseMessage(response: response))
        }
    }
}
