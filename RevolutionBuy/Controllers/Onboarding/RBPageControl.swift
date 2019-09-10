
//
//  RBPageControl.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 29/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

typealias pageCompletionHandler = ((Int, String) -> (Void))

class RBPageControl: UIView {

    //MARK: - Variables -
    var handler: pageCompletionHandler?
    var currentPage: Int = 0

    //MARK: - View life cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
    }

    func addPageIndicators(number items: Int, completionHandler: @escaping pageCompletionHandler) {

        handler = completionHandler

        var pageIndicatorXAxis: CGFloat = 0
        let pageIndicatorYAxix: CGFloat = 0
        let pageIndicatorWidth: CGFloat = self.bounds.size.width / CGFloat(items)
        let pageIndicatorHeight: CGFloat = 20

        for i in 0 ... items - 1 {

            let pageIndicator: UIButton = UIButton.init(type: UIButtonType.custom)
            pageIndicator.backgroundColor = UIColor.clear
            pageIndicator.frame = CGRect(x: pageIndicatorXAxis, y: pageIndicatorYAxix, width: pageIndicatorWidth, height: pageIndicatorHeight)
            pageIndicator.tag = i
            pageIndicator.isUserInteractionEnabled = true
            pageIndicator.addTarget(self, action: #selector(self.onPageIndicatorSelectedAction(sender:)), for: UIControlEvents.touchUpInside)
            self.addSubview(pageIndicator)

            pageIndicatorXAxis = pageIndicatorXAxis + pageIndicatorWidth
        }
        self.changeIndicatorImage(activeButtonTag: 0)
    }

    //MARK: - IBActions -
    func onPageIndicatorSelectedAction(sender: AnyObject) {

        //Get button tag
        let buttonMenu: UIButton = sender as! UIButton

        //Hence user won't be able to select page out of index
        if self.currentPage == buttonMenu.tag {
            return
        }

        //Add current page to new page
        var newPageToShow: Int = self.currentPage

        //Change page number as per requirement
        if buttonMenu.tag < self.currentPage {
            newPageToShow = newPageToShow - 1
        } else if buttonMenu.tag > self.currentPage {
            newPageToShow = newPageToShow + 1
        } else {
            return
        }

        handler?(newPageToShow, "")
    }

    //Change indicator image
    func changeIndicatorImage(activeButtonTag: Int) {
        for (_, item) in self.subviews.enumerated() {
            if let button: UIButton = item as? UIButton {
                if button.tag == activeButtonTag {
                    button.setImage(UIImage.init(named: Onboarding.imageTitle.pageControlBold.rawValue), for: UIControlState.normal)
                    currentPage = activeButtonTag
                } else {
                    button.setImage(UIImage.init(named: Onboarding.imageTitle.pageControlRegular.rawValue), for: UIControlState.normal)
                }
            }
        }
    }

}
