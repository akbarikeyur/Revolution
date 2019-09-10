//
//  SellerProduct.swift
//
//  Created by Vivek Yadav on 13/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

/*
 1) Offer sent (buyer has not accepted any offer yet)
 2) Item removed by buyer
 3) Buyer accepted other seller’s offer
 4) Buyer accepted my offer (Awaiting my response)
 5) I sold the item (mark transaction complete my seller).
 */

public enum SellerProductState: Int {
    case OfferSent = 1
    case ItemRemovedByBuyer = 2
    case BuyerAcceptedOtherOffer
    case BuyerAcceptedMyOffer
    case ItemSoldToBuyer
}

public class RBSellerProduct: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kSellerProductUserKey: String = "user"
    private let kSellerProductProductTypeKey: String = "productType"
    private let kSellerProductCreatedAtKey: String = "createdAt"
    private let kSellerProductSellerProductImagesKey: String = "sellerProductImages"
    private let kSellerProductDescriptionValueKey: String = "description"
    private let kSellerProductUserIdKey: String = "userId"
    private let kSellerProductBuyerProductKey: String = "buyerProduct"
    private let kSellerProductSellerProductTypeTextKey: String = "sellerProductTypeText"
    private let kSellerProductPriceKey: String = "price"
    private let kSellerProductInternalIdentifierKey: String = "id"
    private let kSellerProductBuyerProductIdKey: String = "buyerProductId"
    private let kSellerProductUpdatedAtKey: String = "updatedAt"
    private let kSellerProductStateKey: String = "state"

    // MARK: Properties
    public var user: RBUser?
    public var productType: Int?
    public var sellerProductImages: [RBSellerProductImages]?
    public var descriptionValue: String?
    public var userId: Int?
    public var buyerProduct: RBBuyerProduct?
    public var sellerProductTypeText: String?
    public var price: Double?
    public var internalIdentifier: Int?
    public var buyerProductId: Int?
    public var state: SellerProductState = SellerProductState.OfferSent

    // MARK: ObjectMapper Initalizers
    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    required public init?(map: Map) {
        //Mapping keys
    }

    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    public func mapping(map: Map) {
        user <- map[kSellerProductUserKey]
        productType <- map[kSellerProductProductTypeKey]
        sellerProductImages <- map[kSellerProductSellerProductImagesKey]
        descriptionValue <- map[kSellerProductDescriptionValueKey]
        userId <- map[kSellerProductUserIdKey]
        buyerProduct <- map[kSellerProductBuyerProductKey]
        sellerProductTypeText <- map[kSellerProductSellerProductTypeTextKey]
        price <- map[kSellerProductPriceKey]
        internalIdentifier <- map[kSellerProductInternalIdentifierKey]
        buyerProductId <- map[kSellerProductBuyerProductIdKey]
        state <- map[kSellerProductStateKey]
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = self.dictionaryRepresentationSellerProduct()
        if let value = buyerProduct { dictionary[kSellerProductBuyerProductKey] = value.dictionaryRepresentation() }
        if let value = sellerProductTypeText {
            dictionary[kSellerProductSellerProductTypeTextKey] = value
        }
        if let value = price {
            dictionary[kSellerProductPriceKey] = value
        }
        if let value = internalIdentifier {
            dictionary[kSellerProductInternalIdentifierKey] = value
        }
        if let value = buyerProductId {
            dictionary[kSellerProductBuyerProductIdKey] = value
        }
        dictionary[kSellerProductStateKey] = state
        return dictionary
    }

    private func dictionaryRepresentationSellerProduct() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = user {
            dictionary[kSellerProductUserKey] = value.dictionaryRepresentation()
        }
        if let value = productType {
            dictionary[kSellerProductProductTypeKey] = value
        }
        if let value = sellerProductImages { dictionary[kSellerProductSellerProductImagesKey] = value.map {
            $0.dictionaryRepresentation()
        }
        }
        if let value = descriptionValue {
            dictionary[kSellerProductDescriptionValueKey] = value
        }
        if let value = userId {
            dictionary[kSellerProductUserIdKey] = value
        }
        return dictionary
    }

    func cityNameSeller() -> String {
        var city: String = ""

        if let user = self.user {
            city = user.cityName()
        }
        return city
    }

    func sellerName() -> String {
        var name: String = ""

        if let user = self.user {
            name = user.userNameTrimmingLastWord()
        }
        return name
    }

    func priceProduct() -> String {
        var priceItemString: String = ""
        if let priceitem = self.price {
            let finalPrice: String = String(format: "%.2f", priceitem)
            priceItemString = finalPrice
        }
        return priceItemString
    }

    func productName() -> String {
        var name: String = ""

        if let title = self.buyerProduct?.title {
            name = title
        }
        return name
    }

    func description() -> String {
        var desc: String = "None" // Developer Commented
//        var desc: String = "AUD"

        if let prodDesc: String = self.descriptionValue {
            desc = prodDesc
        }
        return desc
    }

    func fullAddress(isUnlocked: Bool) -> String {
        if let user = self.user {
            if isUnlocked {
                return user.address()
            } else {
                return user.cityName()
            }
        }
        return ""
    }

    func sellingCount() -> String {
        var sellCount: String = "0"

        if let count: String = self.user?.itemsSoldCount() {
            sellCount = count
        }
        return sellCount
    }

    func buyingCount() -> String {
        var buyCount: String = "0"

        if let count: String = self.user?.itemsPurchasedCount() {
            buyCount = count
        }
        return buyCount
    }

    func sellerNumber() -> String {
        var num: String = ""
        if let user = self.user {
            num = user.mobileNumber()
        }
        return num
    }

    func priceProductIncreasedByTenPercent() -> String? {
        if let productPrice: Double = self.price {
            let tenPercent: Double = productPrice * (10.0 / 100.0)
            let totalPrice: Double = productPrice + tenPercent
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            formatter.roundingMode = .down
            if let finalPrice: String = formatter.string(from: NSNumber.init(value: totalPrice)) {
                return finalPrice
            }
        }
        return nil
    }

    func categories() -> String {
        if let buyProduct = self.buyerProduct {
            return buyProduct.categories()
        }
        return ""
    }

    func stateString() -> String {
        let statusArray: [String] = ["",
            "Awaiting buyer’s response",
            "Item removed by buyer",
            "Item sold to another seller",
            "Awaiting your response. Tap the button below.",
            "You sold this item"]
        return statusArray[self.state.rawValue]
    }
}
