//
//  RBSellerItemDetailsVC.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 05/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBSellerItemDetailsVC: RBStatusBarViewController {

    // MARK: - Constants
    let kRBImageCollectionViewCell = "RBImageCollectionViewCell"
    let kCellIdentifierEmpty = "RBEmptyCell"
    let kCellIdentifierName = "kCellIdentifierName"
    let kCellIdentifierYourOffer = "kCellIdentifierYourOffer"
    let kCellIdentifierStatus = "kCellIdentifierStatus"
    let kCellIdentifierInterestedBuyer = "kCellIdentifierInterestedBuyer"

    // MARK: - Variables
    var offer: RBSellerProduct!
    var parentController: RBSellerCurrentSellingVC?
    var tableDataSource: [String] = [String]()
    var arrImages: [RBSellerProductImages] = [RBSellerProductImages]()

    // MARK: - IBOutlets
    @IBOutlet weak var tblItemDetails: UITableView!
    @IBOutlet weak var collectionItemImages: UICollectionView!
    @IBOutlet weak var pageControl: TAPageControl!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var vwSellNow: UIView!
    @IBOutlet weak var btnMarkComplete: UIButton!

    @IBOutlet weak var topSpaceCollectionView: NSLayoutConstraint!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topHeaderView: UIView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet var aryHeaderButtons: [UIButton]!

    // MARK: - Class method
    class func controllerInstance(with sellerProduct: RBSellerProduct) -> RBSellerItemDetailsVC {
        let sellerItemDetailsVC = UIStoryboard.sellerOfferStoryboard().instantiateViewController(withIdentifier: sellerItemDetailsIdentifier) as! RBSellerItemDetailsVC
        sellerItemDetailsVC.offer = sellerProduct
        return sellerItemDetailsVC
    }

    // MARK: - View Initialization
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        self.registerTableViewCells()

        // setup datasource
        self.initHeaderDataSource()
        self.initTableDataSource()

        // setup UI
        self.setupUI()
        self.setUpElementsForHeaderFadeAnimation()

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setupPageControl()
    }

    // MARK: - IBActions
    @IBAction func goBack(_ sender: Any?) {
        self.navigationController?.dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func deleteItem(_ sender: Any) {
        self.promptDeleteOffer()
    }

    @IBAction func actionMarkComplete(_ sender: Any) {
        RBGenericMethods.showMarkTransactionCompleteProceedPrompt {
            self.callAPItoCompleteTransactionFromSeller()
        }
    }

    //MARK: - Methods
    func initHeaderDataSource() {
        if let imageArray: [RBSellerProductImages] = self.offer.sellerProductImages, imageArray.count > 0 {
            self.arrImages.removeAll()
            self.arrImages.append(contentsOf: imageArray)
        }
    }

    func initTableDataSource() {
        self.tableDataSource.removeAll()
        self.tableDataSource.append(kCellIdentifierName)
        self.tableDataSource.append(kCellIdentifierYourOffer)
        self.tableDataSource.append(kCellIdentifierStatus)
        self.tableDataSource.append(kCellIdentifierEmpty)
        self.tableDataSource.append(kCellIdentifierInterestedBuyer)
    }

    func registerTableViewCells() {
        self.tblItemDetails.register(UINib(nibName: "RBItemNameCell", bundle: nil), forCellReuseIdentifier: RBItemNameCell.identifier())
        self.tblItemDetails.register(UINib(nibName: "RBYourOfferCell", bundle: nil), forCellReuseIdentifier: RBYourOfferCell.identifier())
        tblItemDetails.register(UINib(nibName: "RBSoldStatusCell", bundle: nil), forCellReuseIdentifier: RBSoldStatusCell.identifier())
        tblItemDetails.register(UINib(nibName: "RBItemInterestedBuyerCell", bundle: nil), forCellReuseIdentifier: RBItemInterestedBuyerCell.identifier())
    }

    func setupPageControl() {
        self.pageControl.dotSize = CGSize(width: 33.0, height: 30.0)
        self.pageControl.spacingBetweenDots = 5
        var imageCount = arrImages.count
        if imageCount == 1 {
            imageCount = 0
        }
        self.pageControl.numberOfPages = imageCount
        self.pageControl.currentDotImage = UIImage(named: "page_selected.png")
        self.pageControl.dotImage = UIImage(named: "page_unselected.png")
    }

    func setupUI() {

        self.titleLabel.text = self.offer.productName()

        // Mark Complete Button
        let shouldShowMarkComplete = self.offer.state == SellerProductState.BuyerAcceptedMyOffer
        if shouldShowMarkComplete {
            let frame: CGRect = CGRect.init(x: 0.0, y: 0.0, width: Constants.KSCREEN_WIDTH, height: self.vwSellNow.frame.size.height)
            let blankFooter: UIView = UIView.init(frame: frame)
            blankFooter.backgroundColor = UIColor.white
            self.tblItemDetails.tableFooterView = blankFooter
            self.vwSellNow.isHidden = false
        } else {
            self.tblItemDetails.tableFooterView = nil
            self.vwSellNow.isHidden = true
        }

        // Delete Button
        let shouldNotDelete = (self.offer.state == SellerProductState.BuyerAcceptedMyOffer || self.offer.state == SellerProductState.ItemSoldToBuyer)
        self.btnDelete.isHidden = shouldNotDelete
    }

    private func setUpElementsForHeaderFadeAnimation() {
        self.theScrollView = self.tblItemDetails
        self.theTableHeaderView = self.tableHeaderView
        self.theTopNavigationView = self.topHeaderView
        self.arrayHeaderAnimationButtons = self.aryHeaderButtons
    }

    private func promptDeleteOffer() {
        let msgDelete = "Are you sure you want to delete this offer?"
        let leftBtnAttribute = RBConfirmationButtonAttribute.init(title: "Cancel", borderType: .Filled, clickCompletion: nil)
        let rightBtnAttribute = RBConfirmationButtonAttribute.init(title: "Delete", borderType: ConfirmationButtonType.BorderedOnly) {
            self.callAPIToDeleteOffer()
        }
        RBAlert.showConfirmationAlert(message: msgDelete, leftButtonAttributes: leftBtnAttribute, rightButtonAttributes: rightBtnAttribute)
    }

    private func handleResponseCompleteTransaction(success: Bool, message: String) {
        if success {
            self.trackWhetherUserArrivedViaNotification()
        }
        RBAlert.showSuccessAlert(message: message)
    }

    //MARK: - Track user flow status -
    private func trackWhetherUserArrivedViaNotification() {

        //Mixpanel successful transaction track
        AnalyticsManager.trackMixpanelEvent(eventName: AnalyticsIdentifier.eventName.sucessfullDeal.rawValue)

        var hasUserEnteredViaNotification: Bool = true

        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers, viewControllers.count > 0  {

            for viewController in viewControllers {
                if let _ = viewController as? RBSellerBaseVC {
                    hasUserEnteredViaNotification = false
                    break
                }
            }
        }

        if hasUserEnteredViaNotification == true {
            self.showSellerTrasactionCompletePopUp()
        } else {
            self.redirectUserToSellerCartClassWithSuccessPopUp()
        }
    }

    //MARK: - Redirect back where user flow is normal -
    private func redirectUserToSellerCartClassWithSuccessPopUp() {
        let offerDict: [String: RBSellerProduct] = [Constants.NotificationsObjectIdentifier.kOfferItem.rawValue: self.offer]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationsIdentifier.kNotificationItemSoldBySeller.rawValue), object: nil, userInfo: offerDict)
    }

    //MARK: - Redirect back where user flow is via notification -
    private func showSellerTrasactionCompletePopUp() {
        RBSellerTransactionCompletePopupVC.showControllerForNotification(on: self) {
            self.navigationController?.dismiss(animated: true, completion: nil)
            if self.tabBarController?.selectedIndex == 2 {
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

    //MARK: - API
    func callAPIToDeleteOffer() {

        self.view.showLoader(subTitle: WishListDetailIdentifier.LoaderText.Deleting.rawValue)
        self.offer.deleteOfferFromServer { (deletedFromServer, msg) in
            self.view.hideLoader()

            if deletedFromServer {

                if let theController: RBSellerCurrentSellingVC = self.parentController {
                    theController.deleteOfferFromDatasource(offer: self.offer)
                }

                RBAlert.showSuccessAlert(message: "Offer deleted")
                self.goBack(nil)
            } else if msg.length > 0 {
                RBAlert.showWarningAlert(message: msg)
            }
        }
    }

    private func callAPItoCompleteTransactionFromSeller() {

        self.view.showLoader(subTitle: "Please wait...")
        self.offer.completeTransactionBySeller(offer: self.offer) { (success, message) in
            self.view.hideLoader()
            self.handleResponseCompleteTransaction(success: success, message: message)
        }
    }
}

// MARK: - Extension
extension RBSellerItemDetailsVC {
    // MARK: - Scrollview Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionItemImages, self.arrImages.count > 0 {
            let page = self.collectionItemImages.contentOffset.x / self.collectionItemImages.frame.size.width
            self.pageControl.currentPage = Int(page)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tblItemDetails {
            // Pull to stretch
            let scrollOffsetY: CGFloat = scrollView.contentOffset.y
            if scrollOffsetY < 0.0 {
                let increasedHeight = 1.0 * abs(scrollOffsetY)
                self.topSpaceCollectionView.constant = 0.0 - increasedHeight
                self.collectionItemImages.reloadData()
            }

            // Navigation fade effect
            self.checkScrollOffSetForHeaderAnimation()
        }
    }
}
