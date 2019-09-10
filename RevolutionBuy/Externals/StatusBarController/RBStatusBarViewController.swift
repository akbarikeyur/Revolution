//
//  RBStatusBarViewController.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 15/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBStatusBarViewController: UIViewController {

    //MARK: - Variables
    var statusBarStyle: UIStatusBarStyle = UIStatusBarStyle.lightContent
    var theScrollView: UIScrollView?
    var theTopNavigationView: UIView?
    var theTableHeaderView: UIView?
    var arrayHeaderAnimationButtons: [UIButton] =  [UIButton]()

    var navShadowAdded: Bool = false

    //MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !navShadowAdded {
            self.addShadowUnderNavigationView()
        }
    }

    //MARK: - Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusBarStyle
    }

    //MARK: - Methods
    func changeStatusBarStyleToWhite(isWhite: Bool) {
        if (isWhite) {
            self.statusBarStyle = .lightContent
        } else {
            self.statusBarStyle = .default
        }
        self.setNeedsStatusBarAppearanceUpdate()
    }

    private func alphaForScrollingView() -> CGFloat {

        guard let scrollView = self.theScrollView, let navigationHeaderView = self.theTopNavigationView, let tableHeader = self.theTableHeaderView else {
            return 0.0
        }

        var alpha: CGFloat = 0.0
        let offsetY: CGFloat = scrollView.contentOffset.y
        if offsetY < 0.0 {
            return alpha
        }

        let extraGap: CGFloat = navigationHeaderView.frame.height
        let endOffsetY: CGFloat = tableHeader.frame.size.height - extraGap
        if offsetY >= endOffsetY {
            // After scroll up
            alpha = 1.0
            return alpha
        }

        let startOffsetY: CGFloat = tableHeader.frame.size.height - (navigationHeaderView.frame.height + extraGap)
        if offsetY > startOffsetY &&  offsetY < endOffsetY {
            let spaceLeftHeight: CGFloat = tableHeader.frame.size.height - offsetY - extraGap
            let numerator: CGFloat = max(spaceLeftHeight, 1.0)
            let denomenator: CGFloat = navigationHeaderView.frame.height
            let ratio: CGFloat = numerator / denomenator
            alpha = 1.0 - min(ratio, 1.0)
        }
        return alpha
    }

    func checkScrollOffSetForHeaderAnimation() {
        let alpha: CGFloat = self.alphaForScrollingView()
        self.theTopNavigationView?.alpha = alpha
        let shouldChangeStatusBarToWhite = alpha < 0.6 ? true : false
        self.changeStatusBarStyleToWhite(isWhite: shouldChangeStatusBarToWhite)
        self.setButtonSelected(isSelected: !shouldChangeStatusBarToWhite)
    }

    private func setButtonSelected(isSelected: Bool) {
        // isSelected == grey images with white back
        for btn in self.arrayHeaderAnimationButtons {
            btn.isSelected = isSelected
        }
    }

    private func addShadowUnderNavigationView() {
        if let navView = self.theTopNavigationView {
            self.navShadowAdded = true
            navView.layer.shadowColor = UIColor.black.cgColor
            navView.layer.shadowOffset = CGSize(width: 0, height: -10)
            navView.layer.shadowOpacity = 1
            navView.layer.shadowRadius = 10
            navView.alpha = 0.0
            navView.backgroundColor = UIColor.white
        }
    }
}
