//
//  UIView+Loader.swift
//
//  Created by Pawan Joshi on 18/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

import MBProgressHUD

// MARK: - UIView Extension
extension UIView {

    // - MARK: - Loading Progress View
    func showLoader(mainTitle title: String! = "", subTitle subtitle: String?) {

        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud?.labelText = title
        hud?.detailsLabelText = subtitle
        hud?.isSquare = true
        hud?.mode = .indeterminate
        //hud.color = Colors.themeColor()
    }

    func hideLoader() {
        MBProgressHUD.hide(for: self, animated: true)
    }

    func hideAllLoadersForParticularView() {
        MBProgressHUD.hideAllHUDs(for: self, animated: true)
    }

    func showProgressLoader(subTitle subtitle: String?) -> MBProgressHUD {

        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud?.labelText = ""
        hud?.detailsLabelText = subtitle
        hud?.isSquare = false
        hud?.mode = .determinateHorizontalBar
        return hud!
    }

}
