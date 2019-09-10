//
//  UIStoryboard+Additions.swift
//
//  Created by Pawan Joshi on 31/03/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIStoryboard Extension
extension UIStoryboard {

    /**
     Convenience Initializers to initialize storyboard.

     - parameter storyboard: String of storyboard name
     - parameter bundle:     NSBundle object

     - returns: A Storyboard object
     */
    convenience init(storyboard: String, bundle: Bundle? = nil) {
        self.init(name: storyboard, bundle: bundle)
    }

    /**
     Initiate view controller with view controller name.

     - returns: A UIView controller object
     */
    func instantiateViewController<T: UIViewController>() -> T {
        var fullName: String = NSStringFromClass(T.self)
        if let range = fullName.range(of: ".", options: .backwards) {
            fullName = fullName.substring(from: range.upperBound)
        }

        guard let viewController = self.instantiateViewController(withIdentifier: fullName) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(fullName) ")
        }

        return viewController
    }

    class func dashboardStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Dashboard", bundle: nil)
    }
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    class func sellerStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Seller", bundle: nil)
    }

    class func itemDetailsStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "ItemDetails", bundle: nil)
    }

    class func buyerStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Buyer", bundle: nil)
    }

    class func sellerOfferStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "SellerOffer", bundle: nil)
    }

    class func addItemStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "AddItem", bundle: nil)
    }

    class func purchasedStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Purchased", bundle: nil)
    }

    class func stripeStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Stripe", bundle: nil)
    }

    class func settingsStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Settings", bundle: nil)
    }
}
