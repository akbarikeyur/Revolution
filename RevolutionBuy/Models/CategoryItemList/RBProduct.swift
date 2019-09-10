//
//  Product.swift
//
//  Created by Vivek Yadav on 05/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class RBProduct: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kProductProductTypeTextKey: String = "productTypeText"
    private let kProductProductTypeKey: String = "productType"
    private let kProductInternalIdentifierKey: String = "id"
    private let kProductSellerReportsKey: String = "sellerReports"
    private let kProductBuyerProductImagesKey: String = "buyerProductImages"
    private let kProductCreatedAtKey: String = "createdAt"
    private let kProductDescriptionValueKey: String = "description"
    private let kProductUserKey: String = "user"
    private let kProductUserIdKey: String = "userId"
    private let kProductTitleKey: String = "title"
    private let kProductBuyerProductCategoriesKey: String = "buyerProductCategories"
    private let kProductSellerProductsKey: String = "sellerProducts"
    private let kProductPaymentKey: String = "payment"
    private let kProductOfferGetKey: String = "offerGet"

    // MARK: Properties
    public var productTypeText: String?
    public var productType: Int?
    public var internalIdentifier: Int?
    public var sellerReports: Int?
    public var buyerProductImages: [RBBuyerProductImages]?
    public var descriptionValue: String?
    public var user: RBUser?
    public var userId: Int?
    public var title: String?
    public var buyerProductCategories: [RBBuyerProductCategories]?
    public var sellerProducts: Int?
    public var isUnlocked: Bool = false
    public var offerCount: Int?

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
        productTypeText <- map[kProductProductTypeTextKey]
        productType <- map[kProductProductTypeKey]
        internalIdentifier <- map[kProductInternalIdentifierKey]
        sellerReports <- map[kProductSellerReportsKey]
        buyerProductImages <- map[kProductBuyerProductImagesKey]
        descriptionValue <- map[kProductDescriptionValueKey]
        user <- map[kProductUserKey]
        userId <- map[kProductUserIdKey]
        title <- map[kProductTitleKey]
        buyerProductCategories <- map[kProductBuyerProductCategoriesKey]
        sellerProducts <- map[kProductSellerProductsKey]
        isUnlocked <- map[kProductPaymentKey]
        offerCount <- map[kProductOfferGetKey]

        self.sortImages()
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = self.dictionaryRepresentationProduct()
        if let value = user {
            dictionary[kProductUserKey] = value.dictionaryRepresentation()
        }
        if let value = userId {
            dictionary[kProductUserIdKey] = value
        }
        if let value = title {
            dictionary[kProductTitleKey] = value
        }
        if let value = buyerProductCategories {
            dictionary[kProductBuyerProductCategoriesKey] = value
        }
        if let value = sellerProducts {
            dictionary[kProductSellerProductsKey] = value
        }
        if let value = offerCount {
            dictionary[kProductOfferGetKey] = value
        }
        dictionary[kProductPaymentKey] = Int(NSNumber(value: isUnlocked))
        return dictionary
    }

    private func dictionaryRepresentationProduct() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = productTypeText {
            dictionary[kProductProductTypeTextKey] = value
        }
        if let value = productType {
            dictionary[kProductProductTypeKey] = value
        }
        if let value = internalIdentifier {
            dictionary[kProductInternalIdentifierKey] = value
        }
        if let value = sellerReports {
            dictionary[kProductSellerReportsKey] = value
        }
        if let value = buyerProductImages {
            dictionary[kProductBuyerProductImagesKey] = value.map {
                $0.dictionaryRepresentation()
            }
        }
        if let value = descriptionValue {
            dictionary[kProductDescriptionValueKey] = value
        }
        return dictionary
    }

    func isReported() -> Bool {
        var report: Bool = false

        if let reportValue: Int = self.sellerReports, reportValue == 1 {
            report = true
        }
        return report
    }

    func isAlreadyOffered() -> Bool {
        var offer: Bool = false

        if let offerValue: Int = self.sellerProducts, offerValue == 1 {
            offer = true
        }
        return offer
    }

    func description() -> String {
        var desc: String = ""

        if let prodDesc: String = self.descriptionValue {
            desc = prodDesc
        }
        return desc
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

    func fullTitle() -> String {

        if let titleStr: String = self.title {
            return titleStr
        }
        return ""
    }

    func categories() -> String {
        if let arrCategories = buyerProductCategories {
            return RBGenericMethods.fetchCategoriesName(arrCat: arrCategories)
        }
        return ""
    }

    func fullAddress() -> String {
        if let theUser: RBUser = self.user {
            return theUser.formattedAddress(fullAddress: self.isUnlocked)
        }
        return ""
    }

    func hasOffers() -> Bool {
        if let count = self.offerCount, count > 0 {
            return true
        }
        return false
    }

    func sortImages() {

        guard var buyerImages: [RBBuyerProductImages] = self.buyerProductImages, buyerImages.count > 0 else {
            return // No buyer images
        }

        if let index = buyerImages.index(where: { $0.isPrimaryImage == true }), index != 0 {
            let primaryImage = buyerImages[index]
            buyerImages.remove(at: index)
            buyerImages.insert(primaryImage, at: 0)
            self.buyerProductImages = buyerImages
        }
    }
}
