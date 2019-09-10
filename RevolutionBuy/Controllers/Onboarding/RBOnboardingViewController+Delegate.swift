//
//  RBOnboardingViewController+Delegate.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 29/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBOnboardingViewController: UIScrollViewDelegate {

    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = self.scrollViewFade.frame.size.width
        let pageNo = floor((self.scrollViewFade.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        self.customPageControl.changeIndicatorImage(activeButtonTag: Int(pageNo))

        // Page number
        var page = floor((self.scrollViewFade.contentOffset.x - pageWidth) / pageWidth) + 1
        let OldMin: CGFloat = Constants.KSCREEN_WIDTH * page
        let Value: Int = Int(scrollViewFade.contentOffset.x - OldMin)

        let windowWidth = Constants.KSCREEN_WIDTH
        let alpha = CGFloat(Value % Int(Constants.KSCREEN_WIDTH)) / windowWidth

        // Detect page number
        if previousTouchPoint > scrollViewFade.contentOffset.x {
            page = page + 2
        } else {
            page = page + 1
        }

        // Image view of tutorial
        var nextPage: UIView = UIView()
        var previousPage: UIView = UIView()
        var currentPage: UIView = UIView()

        if page + 1 <= 4 {
            nextPage = (scrollViewFade.superview?.viewWithTag(Int(page) + 1))!
        }

        if page - 1 >= 0 {
            previousPage = (scrollViewFade.superview?.viewWithTag(Int(page) - 1))!
        }

        if page >= 0 && page <= 4 {
            currentPage = (scrollViewFade.superview?.viewWithTag(Int(page)))!
        }

        // Fade animation for imageview
        if previousTouchPoint <= scrollViewFade.contentOffset.x {

            self.changeIfPreviousPointIsLessThanScrollViewX(alpha: alpha, currentPage: currentPage, nextPage: nextPage, previousPage: previousPage)

        } else if page != 0 {

            self.changeIfPreviousPointIsGreaterThanScrollViewX(alpha: alpha, currentPage: currentPage, nextPage: nextPage, previousPage: previousPage)
        }

        // Animate
        if didEndAnimate == false && self.customPageControl.currentPage == 0 {
            self.changeAlphaOfImageView()
        }

        self.customPageControl.changeIndicatorImage(activeButtonTag: Int(pageNo))
        self.changeNextButtonText()
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.cancelScrollAnimation()
        previousTouchPoint = scrollView.contentOffset.x
    }

    private func cancelScrollAnimation() {
        didEndAnimate = true
    }

    private func changeIfPreviousPointIsLessThanScrollViewX(alpha: CGFloat, currentPage: AnyObject, nextPage: AnyObject, previousPage: AnyObject) {
        if let current: UIImageView = currentPage as? UIImageView {
            current.alpha = 1 - CGFloat(alpha)
        }

        if let next: UIImageView = nextPage as? UIImageView {
            next.alpha = CGFloat(alpha)
        }

        if let previous: UIImageView = previousPage as? UIImageView {
            previous.alpha = 0
        }
    }

    private func changeIfPreviousPointIsGreaterThanScrollViewX(alpha: CGFloat, currentPage: AnyObject, nextPage: AnyObject, previousPage: AnyObject) {
        if let current: UIImageView = currentPage as? UIImageView {
            current.alpha = CGFloat(alpha)
        }

        if let next: UIImageView = nextPage as? UIImageView {
            next.alpha = 0
        }

        if let previous: UIImageView = previousPage as? UIImageView {
            previous.alpha = 1 - CGFloat(alpha)
        }
    }

    private func changeAlphaOfImageView() {
        for viewOnSubView in self.view.subviews {
            if let imageView: UIImageView = viewOnSubView as? UIImageView {
                if imageView.tag != 1 {
                    imageView.alpha = 0
                } else {
                    imageView.alpha = 1
                }
            }
        }
    }

    private func changeNextButtonText() {
        if self.customPageControl.currentPage == numberOfTutorials - 1 {
            self.nextButton.setTitle(Onboarding.buttonTitle.gotIt.rawValue, for: UIControlState.normal)
        } else {
            self.nextButton.setTitle(Onboarding.buttonTitle.next.rawValue, for: UIControlState.normal)
        }
    }
}
