//
//  RBTempItem+Services.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 10/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import ObjectMapper

typealias CreateItemCompletion = ((_ success: Bool, _ message: String, _ newItem: RBProduct?) -> ())

extension RBTempItem {

    func createItemOnServer(completion: @escaping CreateItemCompletion) {

        // Parameters
        var params: [String: String] = [String: String]()
        // title
        params.updateValue(self.title, forKey: "title")

        // description
        if let desc = self.itemDescription {
            params.updateValue(desc, forKey: "description")
        }

        // identifier
        if let identifier = self.identifier {
            params.updateValue("\(identifier)", forKey: "id")
        }

        let categoryIdArrayString: String = self.categoryIds.joined(separator: ",")
        params.updateValue(categoryIdArrayString, forKey: "category")

        let deletedImageIdsArrayString: String = self.deletedImageIds.joined(separator: ",")
        params.updateValue(deletedImageIdsArrayString, forKey: "deletedImageIds")

        var imageParams: [[String: AnyObject]] = [[String: AnyObject]]()
        for index in 0 ..< self.itemImages.count {
            if let image = self.itemImages[index] {
                let imageData = UIImageJPEGRepresentation(image, 1.0)
                var fileParams = [String: AnyObject]()
                fileParams["key"] = "image\(index + 1)" as AnyObject?
                fileParams["fileName"] = "lol\(index + 1).jpg" as AnyObject?
                fileParams["value"] = imageData as AnyObject?
                fileParams["contentType"] = "image/jpeg" as AnyObject?
                imageParams.append(fileParams)
            }
        }

        var request: URLRequest = URLRequest(url: URL(string: Constants.APIServices.createProductURL)!)

        request.setMultipartFormData(params, fileFields: imageParams)

        RequestManager.sharedManager().performRequest(request, userInfo: nil) { (response) -> Void in

            LogManager.logDebug("response = \(response.resultDictionary)")

            if response.success, let responseDictionary: NSDictionary = response.resultDictionary?.value(forKeyPath: "result.buyerProduct") as? NSDictionary, let productItem: RBProduct = Mapper<RBProduct>().map(JSON: responseDictionary as! [String: Any]) {
                completion(true, "", productItem)
            } else {
                completion(false, RBGenericMethods.serviceResponseMessage(response: response), nil)
            }
        }
    }
}
