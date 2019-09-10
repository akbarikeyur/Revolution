//
//  RBItemDetailsViewController.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 29/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBViewSellerOfferDetailViewController: RBStatusBarViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Constants

    let inAppProductIdentifier: String = "com.appster.revolutionBuy.unlockContactDetail"
    var inAppProductUnlockDetail: SKProduct?

    let kRBImageCollectionViewCell = "RBImageCollectionViewCell"
    let kRBReportItemCellIdentifier = "RBReportItemCellIdentifier"

    // MARK: - Variables

    let identifierEmptyCell = "RBEmptyCell"
    let kCellIdentifierEmpty = "kCellIdentifierEmpty"
    let kCellIdentifierName = "kCellIdentifierName"
    let kCellIdentifierDesc = "kCellIdentifierDesc"
    let kCellIdentifierSellerInfo = "kCellIdentifierSellerInfo"
    let kCellIdentifierSellerContact = "kCellIdentifierSellerContact"

    var tableDataSource: [String] = [String]()

    var product: RBSellerProduct!
    var wishlistProduct: RBProduct!
    var offerListController: RBViewSellerOfferViewController?
    var arrImages: [RBSellerProductImages] = [RBSellerProductImages]()

    var isShowingWhatsThis: Bool = false

    // MARK: - IBOutlets

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tblItemDetails: UITableView!
    @IBOutlet weak var collectionItemImages: UICollectionView!
    @IBOutlet weak var pageControl: TAPageControl!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var vwSellNow: UIView!
    @IBOutlet weak var btnSellNow: UIButton!

    @IBOutlet weak var topHeaderView: UIView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet var aryHeaderButtons: [UIButton]!

    // MARK: - IBActions
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func reportItemAction(_ sender: Any) {
        // pushToReportItem(productDetail: product)
    }

    @IBAction func goToCart(_ sender: Any) {
        RBGenericMethods.askGuestUserToSignUp {
            self.pushToCartScreen()
        }
    }

    @IBAction func actionSellNow(_ sender: Any) {

        self.view.showLoader(subTitle: "Checking\nStatus...")
        self.wishlistProduct.checkUnlockStatus(sellerProductId: "\(self.product.internalIdentifier!)") { (isUnlocked, error) in
            self.view.hideLoader()
            if isUnlocked {
          //    if true { //Developer Added for Testing
                self.wishlistProduct.isUnlocked = true
                RBAlert.showSuccessAlert(message: "Item unlocked because payment was already done.")
                self.performAfterPaymentUIChanges()
            } else {
                if let theError = error {
                    self.processCheckUnlockError(error: theError)
                } else {
                    self.proceedFetchAndShowInAppProduct()
                }
            }
        }
    }

    private func processCheckUnlockError(error: Error) {
        // 204 statusCode already defined at backend
        let statusCodeOfferDeleted = 204
        let reportedCode = (error as NSError).code
        if statusCodeOfferDeleted == reportedCode {
            if let controllers = self.navigationController?.viewControllers, controllers.count >= 2, let offerListController = controllers[controllers.count - 2] as? RBViewSellerOfferViewController {
                offerListController.initiateOfferLoad()
                _ = self.navigationController?.popToViewController(offerListController, animated: true)
            } else {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }

        RBAlert.showWarningAlert(message: error.localizedDescription)
    }

    // MARK: - View Initialization
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.clickToSuccessResponse),name: NSNotification.Name(rawValue: "paypal_success"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.clickToCancelResponse),name: NSNotification.Name(rawValue: "paypal_cancel"), object: nil)

        // UI
        setupUI()
        self.setUpElementsForHeaderFadeAnimation()
        registerTableViewCells()
        self.initTableDataSource()
        self.resetUpLockedViewAttributes()

        // In App product Load
        self.inAppProductUnlockDetail = RMStore.default().product(forIdentifier: self.inAppProductIdentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tblItemDetails.reloadData()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setupPageControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupUI() {

        if let imageArray: [RBSellerProductImages] = product?.sellerProductImages, imageArray.count > 0 {
            self.arrImages.removeAll()
            arrImages.append(contentsOf: imageArray)
        }

        lblHeader.text = self.wishlistProduct.fullTitle()

        btnSellNow.layer.cornerRadius = 4.0
        btnSellNow.layer.masksToBounds = true
        //self.addShadowUnderNavBar()
        self.applyGradientToSellNowBackgroundSellerOffer()

        self.collectionItemImages.reloadData()
        self.tblItemDetails.reloadData()

        if arrImages.count <= 1 {
            pageControl.isHidden = true
        }
    }

    private func setUpElementsForHeaderFadeAnimation() {
        self.theScrollView = self.tblItemDetails
        self.theTableHeaderView = self.tableHeaderView
        self.theTopNavigationView = self.topHeaderView
        self.arrayHeaderAnimationButtons = self.aryHeaderButtons
    }

    func resetUpLockedViewAttributes() {
        if self.wishlistProduct.isUnlocked {
            self.tblItemDetails.tableFooterView = nil
            self.vwSellNow.isHidden = true
        } else {
            self.vwSellNow.isHidden = false
            let frame: CGRect = CGRect.init(x: 0.0, y: 0.0, width: Constants.KSCREEN_WIDTH, height: self.vwSellNow.frame.size.height)
            let blankFooter: UIView = UIView.init(frame: frame)
            blankFooter.backgroundColor = UIColor.white
            self.tblItemDetails.tableFooterView = blankFooter
        }
    }

    func registerTableViewCells() {
        tblItemDetails.register(UINib(nibName: RBViewSellerOfferTitleTableViewCell.identifier(), bundle: nil), forCellReuseIdentifier: RBViewSellerOfferTitleTableViewCell.identifier())
        tblItemDetails.register(UINib(nibName: "RBItemInterestedBuyerCell", bundle: nil), forCellReuseIdentifier: RBItemInterestedBuyerCell.identifier())
        tblItemDetails.register(UINib(nibName: "RBItemDescriptionCell", bundle: nil), forCellReuseIdentifier: RBItemDescriptionCell.identifier())
        tblItemDetails.register(UINib(nibName: RBMarkTransactionCompleteTableViewCell.identifier(), bundle: nil), forCellReuseIdentifier: RBMarkTransactionCompleteTableViewCell.identifier())
    }

    func setupPageControl() {
        self.pageControl.dotSize = CGSize(width: 33.0, height: 30.0)
        self.pageControl.spacingBetweenDots = 5
        var imageCountSellerOffer = arrImages.count
        if imageCountSellerOffer == 1 {
            imageCountSellerOffer = 0
        }
        self.pageControl.numberOfPages = imageCountSellerOffer
        self.pageControl.currentDotImage = UIImage(named: "page_selected.png")
        self.pageControl.dotImage = UIImage(named: "page_unselected.png")
    }

    func applyGradientToSellNowBackgroundSellerOffer() {
        let gradientSellerOffer: CAGradientLayer = CAGradientLayer()
        let startColorSellerOffer = UIColor(white: 1.0, alpha: 1.0)
        let endColorSellerOffer = UIColor(white: 1.0, alpha: 0.0)
        gradientSellerOffer.colors = [endColorSellerOffer.cgColor, startColorSellerOffer.cgColor]
        gradientSellerOffer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientSellerOffer.endPoint = CGPoint(x: 1.0, y: 0.3)
        gradientSellerOffer.frame = CGRect(x: 0.0, y: 0.0, width: self.vwSellNow.frame.size.width, height: self.vwSellNow.frame.size.height)
        self.vwSellNow.layer.insertSublayer(gradientSellerOffer, at: 0)
    }

    // MARK: - Methods
    private func proceedFetchAndShowInAppProduct() {
        if let storeProduct: SKProduct = self.inAppProductUnlockDetail {
            self.showPurchaseConfirmationPopup(for: storeProduct)
        } else {
            self.fetchStoreProduct(onCompletion: { (product) in
                self.inAppProductUnlockDetail = product
                self.showPurchaseConfirmationPopup(for: product)
            })
        }
    }

    func showPurchaseConfirmationPopup(for storeProduct: SKProduct) {
        let amount: String = RMStore.localizedPrice(of: storeProduct)
        let msg: String = "Unlock the contact details of all sellers for this item for \(amount)?\nPlease note that the requested \(amount) unlocking feature is primarily in place for the purpose of detering fraudulent users"
        let confirmAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: "Yes, Pay Now") {
            self.initiateProductPurchase(of: storeProduct)
        }
        let declineAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: "Cancel", borderType: ConfirmationButtonType.BorderedOnly)
        RBAlert.showConfirmationAlert(message: msg, leftButtonAttributes: declineAction, rightButtonAttributes: confirmAction)
    }

    func initTableDataSource() {
        self.tableDataSource.removeAll()
        self.tableDataSource.append(kCellIdentifierName)

        // Description
        self.tableDataSource.append(self.kCellIdentifierEmpty)
        self.tableDataSource.append(self.kCellIdentifierDesc)

        // Seller Info
        self.tableDataSource.append(self.kCellIdentifierEmpty)
        self.tableDataSource.append(self.kCellIdentifierSellerInfo)

        // Seller Contact
        if self.wishlistProduct.isUnlocked {
            self.tableDataSource.append(self.kCellIdentifierSellerContact)
        }
    }

    // MARK: - API
    func callAPIToUnlockSellerContactDetails(transactionResponse: RBInAppPurchaseResponse) {
        self.view.showLoader(subTitle: "Processing...")
        RBAlert.showSuccessAlert(message: "Congrats! Purchase is successful. We are processing the details. Kindly do not close the screen.")
        self.wishlistProduct.unlockNumber(transactionResponse: transactionResponse, offer: self.product) { (success, message) in
            self.view.hideLoader()
            if success {
                self.performAfterPaymentUIChanges()
            }
            RBAlert.showSuccessAlert(message: message)
        }
    }

    // MARK: - Make online payment -
//    func callAPItoMakeOnlinePaymentByStripeToken(token: String) {
//        //Show loader
//        self.view.showLoader(subTitle: "Completing\nTransaction")
//
//        self.wishlistProduct.completeOnlineTransactionByBuyer(stripeToken: token, offerProduct: self.product) { (status, message, error) in
//            self.view.hideLoader()
//            self.handleResponseCompleteTransaction(success: status, message: message, error: error)
//        }
//    }
    
    func callAPItoMakeOnlinePaymentByPayPal() {
        //Show loader
        self.view.showLoader(subTitle: "Please wait...")
        
        self.wishlistProduct.completeOnlinePayPalTransactionByBuyer(offerProduct: self.product) { (url, status, message, error) in
            self.view.hideLoader()
            
            if url != "" {
                UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: { (isOpen) in
                    
                })
//                let vc = UIStoryboard.sellerStoryboard().instantiateViewController(withIdentifier: "ProductPaymentCV") as! ProductPaymentCV
//                vc.redirectUrl = url
//
//                self.present(vc, animated: false, completion: {
//                  //  self.handleResponseCompleteTransaction(success: status, message: message, error: error)
//                })
            }
            
        }
    }
    
    func clickToSuccessResponse()  {
        callAPIToCompleteTransactionFromBuyer()
    }
    
    func clickToCancelResponse()  {
        
    }
    

    func callAPIToCompleteTransactionFromBuyer() {
        self.view.showLoader(subTitle: "Please wait...")
        self.wishlistProduct.completeTransactionByBuyer(offer: self.product) { (success, message, error) in
            self.view.hideLoader()
            self.handleResponseCompleteTransaction(success: success, message: message, error: error)
        }
    }

    // MARK: - API Response
    private func handleResponseCompleteTransaction(success: Bool, message: String, error: Error?) {
        RBAlert.showSuccessAlert(message: message)
        if success {
            self.trackWhetherUserArrivedToBuyerViaNotification()
        } else if let theError = error {
            self.processCompleteTransactionError(error: theError)
        }
    }

    //MARK: - Track user flow status -
    func trackWhetherUserArrivedToBuyerViaNotification() {

        var hasUserArrivedViaNotification: Bool = true

        if let buyerViewControllers: [UIViewController] = self.navigationController?.viewControllers, buyerViewControllers.count > 0 {

            for viewController in buyerViewControllers {
                if let _ = viewController as? RBBuyerBaseVC {
                    hasUserArrivedViaNotification = false
                    break
                }
            }
        }

        if hasUserArrivedViaNotification == true {
            self.showBuyerTrasactionCompletePopUp()
        } else {
            self.performTransactionCompleteChanges()
        }
    }

    //MARK: - Redirect where buyer flow is via notification -
    private func showBuyerTrasactionCompletePopUp() {
        RBBuyerTransactionCompletePopupVC.showControllerForNotification(on: self) {
            self.navigationController?.dismiss(animated: true, completion: nil)
            if self.tabBarController?.selectedIndex == 2 {
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
            let wishListItemDict: [String: RBProduct] = [Constants.NotificationsObjectIdentifier.kWishlistItem.rawValue: self.wishlistProduct]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationsIdentifier.kNotificationItemSoldByBuyerPushNotified.rawValue), object: nil, userInfo: wishListItemDict)
        }
    }

    //MARK: - Redirect where buyer flow is normal -
    private func performTransactionCompleteChanges() {

        // 1) remove this product from wishlist datasource
        // 2) refresh purchased list datasource and UI
        // 3) Show Item Purchased popup
        let wishListItemDict: [String: RBProduct] = [Constants.NotificationsObjectIdentifier.kWishlistItem.rawValue: self.wishlistProduct]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationsIdentifier.kNotificationItemPurchasedByBuyer.rawValue), object: nil, userInfo: wishListItemDict)
    }

    private func processCompleteTransactionError(error: Error) {
        // 204 statusCode already defined at backend
        let statusCodeOfferDeleted = 204
        let reportedCode = (error as NSError).code
        if statusCodeOfferDeleted == reportedCode, let parentVC = self.offerListController {
            parentVC.deleteOfferFromDataSource(offer: self.product, completion: { (deleted) in
                if deleted {
                    _ = self.navigationController?.popToViewController(parentVC, animated: true)
                } else {
                    _ = self.navigationController?.popToRootViewController(animated: true)
                }
            })
        } else {
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }

    private func performAfterPaymentUIChanges() {
        self.wishlistProduct.isUnlocked = true

        self.initTableDataSource()
        self.tblItemDetails.reloadData()
        self.resetUpLockedViewAttributes()
        if let index = self.tableDataSource.index(of: kCellIdentifierSellerContact), index != NSNotFound {
            let lastIndexpath: IndexPath = IndexPath(row: index, section: 0)
            self.tblItemDetails.scrollToRow(at: lastIndexpath, at: .bottom, animated: true)
        }
    }
}

extension RBViewSellerOfferDetailViewController {

    // MARK: - Scrollview Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tblItemDetails {

            let scrollOffsetSellerOffer: CGFloat = scrollView.contentOffset.y

            if scrollOffsetSellerOffer < 0 {
                self.collectionItemImages.frame = CGRect(x: scrollOffsetSellerOffer, y: scrollOffsetSellerOffer, width: self.tableHeaderView.frame.size.width - (scrollOffsetSellerOffer * 2), height: self.tableHeaderView.frame.size.height - scrollOffsetSellerOffer)
            } else {
                self.collectionItemImages.frame = CGRect(x: 0, y: 0, width: self.tableHeaderView.frame.size.width, height: self.tableHeaderView.frame.size.height)
            }

            //Images content offset
            self.collectionItemImages.contentOffset = CGPoint(x: self.pageControl.currentPage * Int(self.collectionItemImages.frame.size.width), y: 0)

            self.collectionItemImages.reloadData()

            //NavigationHeader alpha update
            self.checkScrollOffSetForHeaderAnimation()
        }
    }

    //ScrollView did end decelerating
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionItemImages {
            let page = self.collectionItemImages.contentOffset.x / self.collectionItemImages.frame.size.width
            self.pageControl.currentPage = Int(page)
        }
    }
}
