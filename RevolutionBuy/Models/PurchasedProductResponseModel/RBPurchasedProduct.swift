//
//  RBPurchasedProduct.swift
//
//  Created by Pankaj Pal on 21/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class RBPurchasedProduct: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kRBPurchasedProductTitleKey: String = "title"
    private let kRBPurchasedProductBuyerProductCategoriesKey: String = "buyerProductCategories"
    private let kRBPurchasedProductInternalIdentifierKey: String = "id"
    private let kRBPurchasedProductSellerProductIdKey: String = "sellerProductId"
    private let kRBPurchasedProductSellerProductsKey: String = "sellerProducts"

    // MARK: Properties
    public var title: String?
    public var buyerProductCategories: [RBBuyerProductCategories]?
    public var internalIdentifier: Int?
    public var sellerProductId: Int?
    public var sellerProducts: [RBSellerProduct]?

    // MARK: ObjectMapper Initalizers
    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    required public init?(map: Map) {
        // MARK: ObjectMapper Initalizers
    }

    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    public func mapping(map: Map) {
        title <- map[kRBPurchasedProductTitleKey]
        buyerProductCategories <- map[kRBPurchasedProductBuyerProductCategoriesKey]
        internalIdentifier <- map[kRBPurchasedProductInternalIdentifierKey]
        sellerProductId <- map[kRBPurchasedProductSellerProductIdKey]
        sellerProducts <- map[kRBPurchasedProductSellerProductsKey]
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = title { dictionary[kRBPurchasedProductTitleKey] = value }
        if let value = buyerProductCategories {
            dictionary[kRBPurchasedProductBuyerProductCategoriesKey] = value.map {
                $0.dictionaryRepresentation()
            }
        }
        if let value = internalIdentifier {
            dictionary[kRBPurchasedProductInternalIdentifierKey] = value
        }
        if let value = sellerProductId {
            dictionary[kRBPurchasedProductSellerProductIdKey] = value
        }
        if let value = sellerProducts {
            dictionary[kRBPurchasedProductSellerProductsKey] = value.map {
                $0.dictionaryRepresentation()
            }
        }
        return dictionary
    }

}

extension RBPurchasedProduct {

    func categories() -> String {
        if let arrCat = buyerProductCategories {
            return RBGenericMethods.fetchCategoriesName(arrCat: arrCat)
        }
        return ""
    }

    func numberOfSellerImages() -> Int {
        let count = self.sellerImagesArray().count
        return count
    }

    func sellerImagesArray() -> [RBSellerProductImages] {

        guard let sellerProduct: RBSellerProduct = self.sellerProductModel(), let imageArray = sellerProduct.sellerProductImages else {
            return [RBSellerProductImages]()
        }

        return imageArray
    }

    func titleString() -> String {
        if let titleStr = self.title, titleStr.length > 0 {
            return titleStr
        }

        return ""
    }

    func sellerProductModel() -> RBSellerProduct? {
        guard let sellerProductArray: [RBSellerProduct] = self.sellerProducts, sellerProductArray.count > 0 else {
            return nil
        }

        return sellerProductArray[0]
    }

    func sellerModel() -> RBUser? {
        if let sellerProductModel: RBSellerProduct = self.sellerProductModel() {
            return sellerProductModel.user
        }

        return nil
    }

    func sellerMobileNumber() -> String {
        if let sellerProductModel: RBSellerProduct = self.sellerProductModel() {
            return sellerProductModel.sellerNumber()
        }
        return ""
    }
}
