//
//  SellerProduct+Service.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 08/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import ObjectMapper

typealias SellerProductFetchCompletion = ((_ success: Bool, _ msg: String, _ result: RBSellerProductFetchResponse?) -> ())

extension RBSellerProduct {

    // MARK: - Fetch Seller Product List
    class func fetchSellerProducts(offSet: Int, limit: Int, type: SellerItemType, completion: SellerProductFetchCompletion?) {

        var params: [String: String] = [String: String]()
        params.updateValue("\(offSet)", forKey: "offset")
        params.updateValue("\(limit)", forKey: "limit")
        params.updateValue("\(type.rawValue)", forKey: "type")

        RequestManager.sharedManager().performHTTPActionWithMethod(.GET, urlString: Constants.APIServices.sellerProductsItemsListURL, params: params as [String: AnyObject]?) { (response) -> Void in

            if response.success, let responseDictionary: NSDictionary = response.resultDictionary?.value(forKeyPath: "result") as? NSDictionary, let result: RBSellerProductFetchResponse = Mapper<RBSellerProductFetchResponse>().map(JSON: responseDictionary as! [String: Any]) {
                completion?(true, "", result)
            } else {
                completion?(false, RBGenericMethods.serviceResponseMessage(response: response), nil)
            }
        }
    }

    // MARK: - delete Seller Product
    func deleteOfferFromServer(completion: @escaping((_ deleted: Bool, _ msg: String) -> ())) {

        let urlString: String = Constants.APIServices.sellerProductDeleteURL + "/" + "\(self.internalIdentifier!)"

        RequestManager.sharedManager().performHTTPActionWithMethod(.DELETE, urlString: urlString, params: nil) { (response) -> Void in
            completion(response.success, RBGenericMethods.serviceResponseMessage(response: response))
        }
    }

    // MARK: - Mark Complete By Seller
    func completeTransactionBySeller(offer: RBSellerProduct, completion: @escaping((_ success: Bool, _ msg: String) -> ())) {

        guard let sellerProductId: Int = offer.internalIdentifier else {
            completion(false, "Seller Offer not found")
            return
        }

        guard let buyerId: Int = offer.buyerProduct?.user?.internalIdentifier else {
            completion(false, "Buyer not found")
            return
        }

        guard let buyerProductId: Int = offer.buyerProduct?.internalIdentifier else {
            completion(false, "Buyer Product not found")
            return
        }

        var title = "ITEM"
        if let theTitle = offer.buyerProduct?.title {
            title = theTitle
        }

        var params: [String: String] = [String: String]()
        params.updateValue("\(buyerProductId)", forKey: "buyerProductId")
        params.updateValue("\(sellerProductId)", forKey: "sellerProductId")
        params.updateValue("\(buyerId)", forKey: "buyerId")
        params.updateValue(title, forKey: "title")

        RequestManager.sharedManager().performHTTPActionWithMethod(.POST, urlString: Constants.APIServices.markTransactionCompleteSellerUrl, params: params as [String: AnyObject]?) { (response) -> Void in
            if let newSellCount: Int = response.resultDictionary?.value(forKeyPath: "result.soldCount") as? Int {
                RBUserManager.sharedManager().activeUser.soldCount = newSellCount
            }
            completion(response.success, RBGenericMethods.serviceResponseMessage(response: response))
        }
    }
}
