//
//  RBCategory+Datasource.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 31/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import ObjectMapper

extension RBCategory {

    class func categoryListFromPlist() -> [RBCategory] {
        var arrayCategory: [RBCategory] = [RBCategory]()

        if let path = Bundle.main.path(forResource: Seller.CategoryPlist.rawValue, ofType: Seller.plist.rawValue), let arr = NSArray(contentsOfFile: path) {

            for categoryItemDict in arr {

                if let category: RBCategory = Mapper<RBCategory>().map(JSON: categoryItemDict as! [String: Any]) {
                    arrayCategory.append(category)
                }
            }
        }

        return arrayCategory
    }
}

