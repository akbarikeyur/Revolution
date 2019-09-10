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

extension RBProduct {

    // MARK: - Fetch User Purchased Products
    class func fetchPurchasedProducts(offSet: Int, limit: Int, completion: PurchasedFetchCompletion?) {

        //        GET /buyer-wishlist-products?offset=1&limit=5

        var params: [String: String] = [String: String]()
        params.updateValue("\(offSet)", forKey: "offset")
        params.updateValue("\(limit)", forKey: "limit")

        RequestManager.sharedManager().performHTTPActionWithMethod(.GET, urlString: Constants.APIServices.purchasedItemsListURL, params: params as [String: AnyObject]?) { (response) -> Void in

            if response.success, let responseDictionary: NSDictionary = response.resultDictionary?.value(forKeyPath: "result") as? NSDictionary, let result: RBPurchasedFetchResponse = Mapper<RBPurchasedFetchResponse>().map(JSON: responseDictionary as! [String: Any]) {
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

            if response.success, let responseDictionary: NSDictionary = response.resultDictionary?.value(forKeyPath: "result") as? NSDictionary, let result: RBWishListFetchResponse = Mapper<RBWishListFetchResponse>().map(JSON: responseDictionary as! [String: Any]) {
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

    // MARK: - Unlock WishList Product
    func unlockNumber(transactionResponse: RBInAppPurchaseResponse, offer: RBSellerProduct, completion: @escaping((_ success: Bool, _ msg: String) -> ())) {

        guard let sellerId: Int = offer.user?.internalIdentifier else {
            completion(false, "Seller not found")
            return
        }

        guard let buyerProductId: Int = self.internalIdentifier else {
            completion(false, "Buyer not found")
            return
        }

        var params: [String: String] = [String: String]()
        params.updateValue("\(buyerProductId)", forKey: "buyerProductId")
        params.updateValue("\(sellerId)", forKey: "sellerId")
        params.updateValue(transactionResponse.transactionId, forKey: "transactionId")
        params.updateValue(transactionResponse.transactionReceiptString, forKey: "base64Receipt")

        RequestManager.sharedManager().performHTTPActionWithMethod(.POST, urlString: Constants.APIServices.unlockPhoneUrl, params: params as [String: AnyObject]?) { (response) -> Void in
            completion(response.success, RBGenericMethods.serviceResponseMessage(response: response))
        }
    }

    // MARK: - Mark Complete Buyer
    func completeTransactionByBuyer(offer: RBSellerProduct, completion: @escaping((_ success: Bool, _ msg: String, _ error: Error?) -> ())) {

        guard let sellerId: Int = offer.user?.internalIdentifier else {
            completion(false, "Seller not found", nil)
            return
        }

        guard let sellerProductId: Int = offer.internalIdentifier else {
            completion(false, "Seller Offer not found", nil)
            return
        }

        guard let buyerProductId: Int = self.internalIdentifier else {
            completion(false, "Buyer Product not found", nil)
            return
        }

        var params: [String: String] = [String: String]()
        params.updateValue("\(buyerProductId)", forKey: "buyerProductId")
        params.updateValue("\(sellerId)", forKey: "sellerId")
        params.updateValue("\(sellerProductId)", forKey: "sellerProductId")

        RequestManager.sharedManager().performHTTPActionWithMethod(.POST, urlString: Constants.APIServices.markTransactionCompleteBuyerUrl, params: params as [String: AnyObject]?) { (response) -> Void in
            if let newPurchasedCount: Int = response.resultDictionary?.value(forKeyPath: "result.purchasedCount") as? Int {
                RBUserManager.sharedManager().activeUser.purchaseCount = newPurchasedCount
            }
            completion(response.success, RBGenericMethods.serviceResponseMessage(response: response), response.responseError)
        }
    }

    func convertCurrency(selectedCurrency: String, finalPrice : String) -> String {
//        let finalPrice: String = "100"
        
        if selectedCurrency == "AUD" {
            return finalPrice
        }
        
        let convertAmountURL = "https://finance.google.com/finance/converter?a=" + "\(finalPrice)" + "&from=" + "\(selectedCurrency)" + "&to=AUD"
        
//        let url = URL(string: "https://finance.google.com/finance/converter?a=1&from=USD&to=AUD")
        let url = URL(string: convertAmountURL)
        _  = try! String(contentsOf: url!, encoding: .ascii)
        
        _ = (try! String(contentsOf: url!, encoding: .ascii)).range(of: "<span class=bld>")?.lowerBound
        _ = (try! String(contentsOf: url!, encoding: .ascii)).range(of: "AUD</span>")?.lowerBound
        
        let subStringStart = (try! String(contentsOf: url!, encoding: .ascii)).substring(from: ((try! String(contentsOf: url!, encoding: .ascii)).range(of: "<span class=bld>")?.lowerBound)!)
        
        var subStringEnd = subStringStart.substring(to: (subStringStart.range(of: "AUD</span>")?.lowerBound)!)
        subStringEnd = subStringEnd.replace("<span class=bld>", replacementString: "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        return subStringEnd 
    }
    
    // MARK: - Make Online Payment
    func completeOnlineTransactionByBuyer(stripeToken: String, offerProduct: RBSellerProduct, completion: @escaping((_ success: Bool, _ msg: String, _ error: Error?) -> ())) {

        guard let sellerId: Int = offerProduct.user?.internalIdentifier else {
            completion(false, "Seller not found", nil)
            return
        }

        guard let sellerProductId: Int = offerProduct.internalIdentifier else {
            completion(false, "Seller Offer not found", nil)
            return
        }

        guard let buyerProductId: Int = self.internalIdentifier else {
            completion(false, "Buyer not found", nil)
            return
        }

        guard let finalPrice: String = offerProduct.priceProductIncreasedByTenPercent() else {
            completion(false, "Unable to get final price", nil)
            return
        }

        
        
        var params: [String: AnyObject] = [String: AnyObject]()
        params.updateValue("\(stripeToken)" as AnyObject, forKey: "buyerStripeToken")
        params.updateValue(buyerProductId as AnyObject, forKey: "buyerProductId")
        params.updateValue(sellerId as AnyObject, forKey: "sellerId")
        params.updateValue(sellerProductId as AnyObject, forKey: "sellerProductId")

//        params.updateValue( self.convertCurrency(selectedCurrency: (offerProduct.descriptionValue?.components(separatedBy: "&&")[0])!, finalPrice: String(describing: offerProduct.price ?? 0)) as AnyObject, forKey: "destinationAmount")
        
        params.updateValue(Int((Float(self.convertCurrency(selectedCurrency: (offerProduct.descriptionValue?.components(separatedBy: "&&")[0])!, finalPrice: String(describing: offerProduct.price ?? 0))) ?? 0) * 100) as AnyObject, forKey: "destinationAmount")

//        let destinationAmount = (String(format: "%f", (params["destinationAmount"] as! String).toFloat() ?? 0.0).toDouble() ?? 0.0)
//        params.updateValue(destinationAmount as AnyObject, forKey: "destinationAmount")
//        params.updateValue("\(finalPrice)", forKey: "amount") // Strip payment converted amount - Developer added comment
        
        
        if (offerProduct.descriptionValue?.components(separatedBy: "&&").count ?? 0) > 0 {
            
//            params.updateValue(self.convertCurrency(selectedCurrency: (offerProduct.descriptionValue?.components(separatedBy: "&&")[0])!, finalPrice: finalPrice) as AnyObject, forKey: "amount") // Strip payment converted amount - Developer added comment
            params.updateValue(Int((Float(self.convertCurrency(selectedCurrency: (offerProduct.descriptionValue?.components(separatedBy: "&&")[0])!, finalPrice: finalPrice)) ?? 0) * 100) as AnyObject, forKey: "amount") // Strip payment converted amount - Developer added comment

//            let amount = Int((String(format: "%f", (params["amount"] as! String).toFloat() ?? 0.0).toDouble() ?? 0.0))
//            params.updateValue(String(format: "%.2f", (params["amount"] as! String).toFloat() ?? 0.0).toUInt() as AnyObject, forKey: "amount")
//            params.updateValue(amount as AnyObject, forKey: "amount")
        } else {
//            params.updateValue(self.convertCurrency(selectedCurrency: "AUD", finalPrice: finalPrice), forKey: "amount") // Strip payment converted amount - Developer added comment
            params.updateValue(finalPrice as AnyObject, forKey: "amount") // Strip payment converted amount - Developer added comment
        }

        
        RequestManager.sharedManager().performHTTPActionWithMethod(.POST, urlString: Constants.APIServices.stripePaymentOnlineAPI, params: params as [String: AnyObject]?) { (response) -> Void in
            if let newPurchasedCount: Int = response.resultDictionary?.value(forKeyPath: "result.purchasedCount") as? Int {
                RBUserManager.sharedManager().activeUser.purchaseCount = newPurchasedCount
            }
            completion(response.success, RBGenericMethods.serviceResponseMessage(response: response), response.responseError)
        }
    }
    
    
    
    
    func completeOnlinePayPalTransactionByBuyer(offerProduct: RBSellerProduct, completion: @escaping((_ url : String, _ success: Bool, _ msg: String, _ error: Error?) -> ())) {
        
        guard let sellerId: Int = offerProduct.user?.internalIdentifier else {
            completion("",false, "Seller not found", nil)
            return
        }
        
        guard let sellerProductId: Int = offerProduct.internalIdentifier else {
            completion("",false, "Seller Offer not found", nil)
            return
        }
        
        guard let buyerProductId: Int = self.internalIdentifier else {
            completion("",false, "Buyer not found", nil)
            return
        }
        
        guard let buyerId: Int = offerProduct.buyerProduct?.userId else {
            completion("",false, "Buyer not found", nil)
            return
        }
        
        guard let finalPrice: String = offerProduct.priceProductIncreasedByTenPercent() else {
            completion("",false, "Unable to get final price", nil)
            return
        }
        
        var params: [String: AnyObject] = [String: AnyObject]()
        
        params.updateValue(finalPrice as AnyObject, forKey: "price")
        
        params.updateValue(sellerId as AnyObject, forKey: "sellerId")
        params.updateValue(sellerProductId as AnyObject, forKey: "sellerProductId")
        
        params.updateValue(buyerProductId as AnyObject, forKey: "buyerProductId")
        params.updateValue(buyerId as AnyObject, forKey: "buyerId")
        
        
        RequestManager.sharedManager().performHTTPActionWithMethod(.POST, urlString: "http://api.revolutionbuy.com/api/product-payment", params: params as [String: AnyObject]?) { (response) -> Void in
            if let url : String = response.resultDictionary?.value(forKeyPath: "url") as? String {
                print(url)
                completion(url , true, RBGenericMethods.serviceResponseMessage(response: response), nil)
            }
            else {
                completion("", response.success, RBGenericMethods.serviceResponseMessage(response: response), response.responseError)
            }
            
        }
    }


    
    
    // MARK: - Fetch Product Details
    class func fetchProductsDetail(productId: String, completion: @escaping((_ product: RBProduct?, _ msg: String) -> Swift.Void)) {

        var params: [String: String] = [String: String]()
        params.updateValue(productId, forKey: "buyerProductId")

        RequestManager.sharedManager().performHTTPActionWithMethod(.GET, urlString: Constants.APIServices.productDetailURL, params: params as [String: AnyObject]?) { (response) -> Void in

            if response.success, let productDictionary: NSDictionary = response.resultDictionary?.value(forKeyPath: "result.product") as? NSDictionary, let item: RBProduct = Mapper<RBProduct>().map(JSON: productDictionary as! [String: Any]) {
                completion(item, "")
            } else {
                completion(nil, RBGenericMethods.serviceResponseMessage(response: response))
            }
        }
    }

    // MARK: - Check payment status
    func checkUnlockStatus(sellerProductId: String, completion: @escaping((_ success: Bool, _ error: Error?) -> Swift.Void)) {

        let params: [String: String] = ["buyerProductId": "\(self.internalIdentifier!)", "sellerProductId": sellerProductId]

        RequestManager.sharedManager().performHTTPActionWithMethod(.GET, urlString: Constants.APIServices.checkPaymentStatusByBuyer, params: params as [String: AnyObject]?) { (response) -> Void in

            if response.success, let numUnlockStatus: Int = response.resultDictionary?.value(forKeyPath: "result.unlockPayment") as? Int {
                let isUnlocked = Bool(numUnlockStatus as NSNumber)
                self.isUnlocked = isUnlocked
                completion(isUnlocked, nil)
            } else {
                completion(false, response.responseError)
            }
        }
    }
}
