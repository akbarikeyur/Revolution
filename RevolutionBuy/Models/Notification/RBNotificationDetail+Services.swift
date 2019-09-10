//
//  RBNotificationDetail+Services.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 15/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import ObjectMapper

extension RBNotificationDetail {

    //MARK: - Fetch OfferSentBySeller Details -
    func fetchNotificationDetails(offerSentBySeller completion: @escaping(_ status: Bool, _ message: String, _ sellerProduct: RBSellerProduct?, _ buyerProduct: RBProduct?) -> Swift.Void) {

        self.requestToPerformServiceResponse { (response) in

            if response.success == true, let resultDictionary: NSDictionary = response.resultDictionary?.value(forKey: "result") as? NSDictionary {

                guard let sellerDictionary: [String: Any] = resultDictionary.object(forKey: "sellerProduct") as? [String: Any] else {
                    completion(false, RBGenericMethods.serviceResponseMessage(response: response), nil, nil)
                    return
                }

                guard let buyerDictionary: [String: Any] = resultDictionary.object(forKey: "buyerProduct") as? [String: Any] else {
                    completion(false, RBGenericMethods.serviceResponseMessage(response: response), nil, nil)
                    return
                }

                if let sellerProductDetails: RBSellerProduct = Mapper<RBSellerProduct>().map(JSON: sellerDictionary), let buyerProductDetails: RBProduct = Mapper<RBProduct>().map(JSON: buyerDictionary) {
                    completion(true, RBGenericMethods.serviceResponseMessage(response: response), sellerProductDetails, buyerProductDetails)
                } else {
                    completion(false, RBGenericMethods.serviceResponseMessage(response: response), nil, nil)
                }

            } else {
                completion(false, RBGenericMethods.serviceResponseMessage(response: response), nil, nil)
            }
        }
    }

    //MARK: - Fetch BuyerUnlockedDetails Details -
    func fetchNotificationDetails(buyerUnlockedDetails completion: @escaping(_ status: Bool, _ message: String, _ buyerProduct: RBProduct?) -> Swift.Void) {

        self.requestToPerformServiceResponse { (response) in

            if response.success == true, let resultDictionary: NSDictionary = response.resultDictionary?.value(forKey: "result") as? NSDictionary {

                guard let buyerDictionary: [String: Any] = resultDictionary.object(forKey: "buyerProduct") as? [String: Any] else {
                    completion(false, RBGenericMethods.serviceResponseMessage(response: response), nil)
                    return
                }

                if let buyerProductDetails: RBProduct = Mapper<RBProduct>().map(JSON: buyerDictionary) {
                    completion(true, RBGenericMethods.serviceResponseMessage(response: response), buyerProductDetails)
                } else {
                    completion(false, RBGenericMethods.serviceResponseMessage(response: response), nil)
                }

            } else {
                completion(false, RBGenericMethods.serviceResponseMessage(response: response), nil)
            }
        }
    }

    //MARK: - Fetch BuyerMarkedTransactionAsComplete Details -
    func fetchNotificationDetails(buyerMarkedTransactionAsComplete completion: @escaping(_ status: Bool, _ message: String, _ sellerProduct: RBSellerProduct?) -> Swift.Void) {

        self.requestToPerformServiceResponse { (response) in

            if response.success == true, let resultDictionary: NSDictionary = response.resultDictionary?.value(forKey: "result") as? NSDictionary {

                guard let sellerDict: [String: Any] = resultDictionary.object(forKey: "sellerProduct") as? [String: Any] else {
                    completion(false, RBGenericMethods.serviceResponseMessage(response: response), nil)
                    return
                }

                if let sellerProductDetailsModel: RBSellerProduct = Mapper<RBSellerProduct>().map(JSON: sellerDict) {
                    completion(true, RBGenericMethods.serviceResponseMessage(response: response), sellerProductDetailsModel)
                } else {
                    completion(false, RBGenericMethods.serviceResponseMessage(response: response), nil)
                }
            } else {
                completion(false, RBGenericMethods.serviceResponseMessage(response: response), nil)
            }
        }
    }

    //MARK: - Fetch ProductSoldByAnotherSeller Details -
    func fetchNotificationDetails(productSoldByAnotherSeller completion: @escaping(_ status: Bool, _ message: String, _ sellerProduct: RBSellerProduct?) -> Swift.Void) {

        self.requestToPerformServiceResponse { (response) in

            if response.success == true, let resultDictionary: NSDictionary = response.resultDictionary?.value(forKey: "result") as? NSDictionary {

                guard let sellerDictionary: [String: Any] = resultDictionary.object(forKey: "sellerProduct") as? [String: Any] else {
                    completion(false, RBGenericMethods.serviceResponseMessage(response: response), nil)
                    return
                }

                if let sellerProductDetails: RBSellerProduct = Mapper<RBSellerProduct>().map(JSON: sellerDictionary) {
                    completion(true, RBGenericMethods.serviceResponseMessage(response: response), sellerProductDetails)
                } else {
                    completion(false, RBGenericMethods.serviceResponseMessage(response: response), nil)
                }
            } else {
                completion(false, RBGenericMethods.serviceResponseMessage(response: response), nil)
            }
        }
    }

    //MARK: - Fetch SellerMarkedTransactionAsComplete Details -
    func fetchNotificationDetails(sellerMarkedTransactionAsComplete completion: @escaping(_ status: Bool, _ message: String, _ purchasedProduct: RBPurchasedProduct?) -> Swift.Void) {

        self.requestToPerformServiceResponse { (response) in

            if response.success == true, let resultDictionary: NSDictionary = response.resultDictionary?.value(forKey: "result") as? NSDictionary {

                guard let purchasedDictionary: [String: Any] = resultDictionary.object(forKey: "purchasedProduct") as? [String: Any] else {
                    completion(false, RBGenericMethods.serviceResponseMessage(response: response), nil)
                    return
                }

                if let purchasedProduct: RBPurchasedProduct = Mapper<RBPurchasedProduct>().map(JSON: purchasedDictionary) {
                    completion(true, RBGenericMethods.serviceResponseMessage(response: response), purchasedProduct)
                } else {
                    completion(false, RBGenericMethods.serviceResponseMessage(response: response), nil)
                }
            } else {
                completion(false, RBGenericMethods.serviceResponseMessage(response: response), nil)
            }
        }
    }

    //MARK: - Private methods -
    private func requestToPerformServiceResponse(completion: @escaping(_ response: Response) -> Void) {

        guard let notificationId: Int = self.internalIdentifier else {
            completion(Response())
            return
        }

        let parameter: [String: AnyObject] = ["notificationId": "\(notificationId)" as AnyObject]

        RequestManager.sharedManager().performHTTPActionWithMethod(.POST, urlString: Constants.APIServices.fetchNotificationDetailAPI, params: parameter) { (response) -> Void in

            LogManager.logDebug("Response = \(response)")

            completion(response)
        }
    }
}
