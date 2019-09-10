//
//  RBTempItem.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 10/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBTempItem: NSObject {

    var categoryIds: [String] = [String]()
    var deletedImageIds: [String] = [String]()
    var title: String! = ""
    var itemDescription: String?
    var itemImages: [UIImage?] = [UIImage?]()

    var identifier: Int?
    var productImages: [RBBuyerProductImages]?

    func isExisting() -> Bool {
        return self.identifier != nil
    }
}
