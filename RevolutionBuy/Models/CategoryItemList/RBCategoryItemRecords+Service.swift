//
//  CategoryItemList.swift
//
//  Created by Vivek Yadav on 03/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

extension RBCategoryItemRecords {

    // MARK: Get list of product
    class func searchProduct(params: [String: AnyObject], completion: @escaping(_ success: Bool, _ error: Error?, _ data: RBCategoryItemRecords?, _ message: String) -> (Void)) {

        RequestManager.sharedManager().performHTTPActionWithMethod(.POST, urlString: Constants.APIServices.productSearchAPI, params: params as [String: AnyObject]?) { (response) -> Void in

            if response.success, let serchData: RBCategoryItemRecords = Mapper<RBCategoryItemRecords>().map(JSON: (response.resultDictionary?.object(forKey: "result") as? [String: Any])!) {
                completion(true, nil, serchData, RBGenericMethods.serviceResponseMessage(response: response))
            } else {
                completion(false, nil, nil, RBGenericMethods.serviceResponseMessage(response: response))
            }
        }
    }

    // MARK: Product Report
    class func reportProduct(params: [String: AnyObject], completion: @escaping(_ success: Bool, _ error: Error?, _ message: String) -> (Void)) {

        RequestManager.sharedManager().performHTTPActionWithMethod(.POST, urlString: Constants.APIServices.productReportBySellerAPI, params: params as [String: AnyObject]?) { (response) -> Void in
            if response.success {
                completion(true, nil, RBGenericMethods.serviceResponseMessage(response: response))
            } else {

                completion(false, response.responseError, RBGenericMethods.serviceResponseMessage(response: response))

            }

        }
    }

    // MARK: Send offer by seller
    class  func sendOfferByseller(_ profileImage: [UIImage], params: [String: String], completion: @escaping(_ success: Bool, _ error: Error?, _ message: String) -> (Void)) {

        var imageArray: [[String: AnyObject]] = []
        var fileParams = [String: AnyObject]()

        for i in 0 ..< profileImage.count {
            fileParams["key"] = "image\(i + 1)" as AnyObject?
            fileParams["fileName"] = "imageProduct.jpg" as AnyObject?
            fileParams["value"] = UIImageJPEGRepresentation(profileImage[i], 0.2) as AnyObject?
            fileParams["contentType"] = "image/jpeg" as AnyObject?
            imageArray.append(fileParams)

        }

        var request: URLRequest = URLRequest(url: URL(string: Constants.APIServices.sendOfferBySellerAPI)!)
        request.setMultipartFormData(params, fileFields: imageArray)
        RequestManager.sharedManager().performRequest(request, userInfo: nil) { (response) -> Void in
            if response.success {
                completion(true, nil, RBGenericMethods.serviceResponseMessage(response: response))
            } else {
                completion(false, response.responseError, RBGenericMethods.serviceResponseMessage(response: response))
            }
        }
    }
}
