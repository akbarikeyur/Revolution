//
//  RBTabBarController.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 27/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBTabBarController: UITabBarController, UITabBarControllerDelegate {

    //MARK: - IBOutlets -

    //MARK: - Variables -
    var earlierSelectedIndex: Int = -1
    var badgeView: RBCustomBadgeView = RBCustomBadgeView()

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradient()
        self.delegate = self

        self.addBadgeLabelToTabBar()
    }

    //MARK: - Private method -
    private func addGradient() {
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.tabBar.layer.shadowRadius = 3
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOpacity = 0.2
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }

    private func addBadgeLabelToTabBar() {

        if let tabBarItems: [UITabBarItem] = self.tabBar.items, tabBarItems.count > 3 {

            let tabBarWidth: CGFloat = Constants.KSCREEN_WIDTH / CGFloat(tabBarItems.count)
            let tabBarXAxis: CGFloat = (tabBarWidth * 2) + tabBarWidth / 2
            let badgeBackViewRect: CGRect = CGRect(x: tabBarXAxis, y: 6.0, width: 15.0, height: 15.0)

            self.badgeView = RBCustomBadgeView.init(frame: badgeBackViewRect)
            self.tabBar.addSubview(self.badgeView)

            self.badgeView.badgeCount = UIApplication.shared.applicationIconBadgeNumber
        }
    }

    //MARK: - Tabbar controller delegate -
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        earlierSelectedIndex = tabBarController.selectedIndex
        return true
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

        if tabBarController.selectedIndex == 2 && RBUserManager.sharedManager().isUserGuestUser() == true {
            let selectedIndex: Int = tabBarController.selectedIndex
            tabBarController.selectedIndex = earlierSelectedIndex
            RBGenericMethods.askGuestUserToSignUp(completion: {
                tabBarController.selectedIndex = selectedIndex
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
