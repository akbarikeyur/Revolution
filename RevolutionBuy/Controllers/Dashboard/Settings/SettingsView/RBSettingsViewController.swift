//
//  RBSettingsViewController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 06/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBSettingsViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var settingsTableView: UITableView!

    //MARK: - Variables -
    var headerArray: [String] = ["Profile", "About"]
    var profileCellArray: [String] = ["Your Profile", "Change Mobile Number", "Change Password", "PayPal Account"]
    var aboutCellArray: [String] = ["Terms of Use", "Privacy Policy", "View Onboarding", "Contact Admin"]

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: - IBActions -
    @IBAction func logoutAction(_ sender: AnyObject) {

        if RBUserManager.sharedManager().isUserGuestUser() == true {
            RBGenericMethods.askGuestUserToSignUp(completion: {
                LogManager.logDebug("User has been signed up")
            })
        } else {

            let confirmAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: "Logout", borderType: ConfirmationButtonType.BorderedOnly) {
                self.callLogoutAPI()
            }

            let declineAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: "Cancel")

            RBAlert.showConfirmationAlert(message: "Are you sure you want to logout?", leftButtonAttributes: declineAction, rightButtonAttributes: confirmAction)

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension RBSettingsViewController: UITableViewDataSource, UITableViewDelegate {

    //MARK: - Table View Delegate -
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows: Int = 0

        switch section {
        case 0, 2:
            numberOfRows = 1
        case 1:
            numberOfRows = 4
            if let user: RBUser = RBUserManager.sharedManager().activeUser, user.isFacebookUser() {
                numberOfRows = 3
            }
        case 3:
            numberOfRows = 4
        default:
            numberOfRows = 0
        }

        return numberOfRows
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0, 2:
            let headerTitleCell: RBSettingsTableViewCell = self.fillDataToTableViewHeader(tableView, cellForRowAt: indexPath)
            return headerTitleCell

        case 1:
            let profileTitleCell: RBSettingsTableViewCell = self.fillDataToProfileCell(tableView, cellForRowAt: indexPath)
            return profileTitleCell

        case 3:
            let aboutTitleCell: RBSettingsTableViewCell = self.fillDataToAboutCell(tableView, cellForRowAt: indexPath)
            return aboutTitleCell

        default:
            return UITableViewCell()
        }
    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.section {
        case 1:
            self.profileSectionAction(indexPath: indexPath.row)
        case 3:
            self.aboutSectionAction(indexPath: indexPath.row)
        default:
            break
        }

    }

    //MARK: - Private methods for table view -
    private func fillDataToTableViewHeader(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> RBSettingsTableViewCell {
        let headerTitleCell: RBSettingsTableViewCell = self.headerCell(tableView, indexPath: indexPath)

        if indexPath.section == 0 {
            headerTitleCell.cellTitleLabel.text = self.headerArray[0]
        } else {
            headerTitleCell.cellTitleLabel.text = self.headerArray[1]
        }

        return headerTitleCell
    }

    private func fillDataToProfileCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> RBSettingsTableViewCell {
        let settingsTitleCell: RBSettingsTableViewCell = self.settingsCell(tableView, indexPath: indexPath)
        settingsTitleCell.cellTitleLabel.text = self.profileCellArray[indexPath.row]

        if let user: RBUser = RBUserManager.sharedManager().activeUser, user.isFacebookUser(), indexPath.row == 2 {
            settingsTitleCell.leadingViewContraint.constant = 0
            settingsTitleCell.cellTitleLabel.text = self.profileCellArray[3]
        } else if let user: RBUser = RBUserManager.sharedManager().activeUser, !user.isFacebookUser(), indexPath.row == 3 {
            settingsTitleCell.leadingViewContraint.constant = 0
        } else {
            settingsTitleCell.leadingViewContraint.constant = 16
        }

        return settingsTitleCell
    }

    private func fillDataToAboutCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> RBSettingsTableViewCell {
        let settingsTitleCell: RBSettingsTableViewCell = self.settingsCell(tableView, indexPath: indexPath)
        settingsTitleCell.cellTitleLabel.text = self.aboutCellArray[indexPath.row]

        if indexPath.row == 3 {
            settingsTitleCell.leadingViewContraint.constant = 0
        } else {
            settingsTitleCell.leadingViewContraint.constant = 16
        }

        return settingsTitleCell
    }

    //Push to appropriate controller on selecting within profile section
    private func profileSectionAction(indexPath row: Int) {

        let isGuestUser: Bool = RBUserManager.sharedManager().isUserGuestUser()

        RBGenericMethods.askGuestUserToSignUp {

            if isGuestUser == true {
                self.settingsTableView.reloadData()
            }

            switch row {
            case 0:
                self.pushToViewProfileController()
            case 1:
                self.pushToMobileNumberController(addProfileModel: nil, viaSettings: true)
            default:
                self.navigateToChangePasswordAndStripeScreen(isGuestUser, row: row)
            }
        }
    }

    private func navigateToChangePasswordAndStripeScreen(_ isGuestUser: Bool, row: Int) {
        if let user: RBUser = RBUserManager.sharedManager().activeUser, user.isFacebookUser() {
            self.navigateWhenUserIsFacebookUser(isGuestUser, row: row)
        } else {
            self.navigateWhenUserIsEmailUser(row: row)
        }
    }

    private func navigateWhenUserIsFacebookUser(_ isGuestUser: Bool, row: Int) {
        if (isGuestUser == false && row == 2) || (isGuestUser == true && row == 3) {
            self.pushTosellerAccountSettingsController()
        }
        if isGuestUser == true && row == 2 {
            RBAlert.showWarningAlert(message: "Social user has no action for change password")
        }
    }

    private func navigateWhenUserIsEmailUser(row: Int) {
        if row == 2 {
            self.pushToChangePasswordController()
        } else {
            self.pushTosellerAccountSettingsController()
        }
    }

    //Push to appropriate controller on selecting within about section
    private func aboutSectionAction(indexPath row: Int) {
        switch row {
        case 0:
            self.pushToTermsController(type: TermsIdentifier.TermsType.Terms, viaSettings: true)
        case 1:
            self.pushToTermsController(type: TermsIdentifier.TermsType.Privacy, viaSettings: true)
        case 2:
            self.pushToOnboardingController(viaSettings: true)
        default:
            self.pushToContactAdminControllerController()
        }
    }

    //Create settings cell
    private func settingsCell(_ tableView: UITableView, indexPath: IndexPath) -> RBSettingsTableViewCell {
        let settingsTitle: String = "cellSettingsIdentifier"
        let settingsTitleCell: RBSettingsTableViewCell = tableView.dequeueReusableCell(withIdentifier: settingsTitle, for: indexPath) as! RBSettingsTableViewCell
        return settingsTitleCell
    }

    //Create header cell
    private func headerCell(_ tableView: UITableView, indexPath: IndexPath) -> RBSettingsTableViewCell {
        let headerTitle: String = "cellSettingsHeader"
        let headerTitleCell: RBSettingsTableViewCell = tableView.dequeueReusableCell(withIdentifier: headerTitle, for: indexPath) as! RBSettingsTableViewCell
        return headerTitleCell
    }

}

extension RBSettingsViewController {
    //MARK: - Logout API -
    fileprivate func callLogoutAPI() {

        //Show loader
        self.view.showLoader(mainTitle: "", subTitle: "Signing\nout")

        //Call API
        RBUserManager.sharedManager().logoutAPI { (status, error, message) -> (Void) in

            //Hide loader
            self.view.hideLoader()

            if status == true {
                RBUserManager.sharedManager().userLogout()
            } else {
                RBAlert.showWarningAlert(message: message, completion: nil)
            }

        }
    }

}
