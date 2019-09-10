//
//  RBItemDetailsViewController.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 29/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBItemDetailsViewController: RBStatusBarViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Constants

    let kRBImageCollectionViewCell = "RBImageCollectionViewCell"
    let kRBReportItemCellIdentifier = "RBReportItemCellIdentifier"

    // MARK: - Variables

    var product: RBProduct?
    var arrImages: [RBBuyerProductImages] = []

    // MARK: - IBOutlets

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tblItemDetails: UITableView!
    @IBOutlet weak var vwNavBar: UIView!
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var collectionItemImages: UICollectionView!
    @IBOutlet weak var pageControl: TAPageControl!
    @IBOutlet weak var vwSellNow: UIView!
    @IBOutlet weak var btnSellNow: UIButton!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnCart: UIButton!

    // MARK: - IBActions -
    @IBAction func goBack(_ sender: Any) {
        //Pop to previous controller
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func reportItemAction(_ sender: Any) {
        RBGenericMethods.askGuestUserToSignUp {
            self.checkSelfUserLoggendAndProceed {
                self.pushToReportItem(productDetail: self.product)
            }
        }
    }

    @IBAction func goToCart(_ sender: Any) {
        RBGenericMethods.askGuestUserToSignUp {
            self.pushToCartScreen()
        }
    }

    @IBAction func actionSellNow(_ sender: Any) {
        RBGenericMethods.askGuestUserToSignUp {
            self.checkSelfUserLoggendAndProceed {
                self.navigateSellerToAddAccount()
            }
        }
    }

    private func navigateSellerToAddAccount() {

        guard let userModel: RBUser = RBUserManager.sharedManager().activeUser else {
            return
        }

        if userModel.hasSellerConnectedAccount() {
            self.pushToSendOfferController(productDetail: self.product)
        } else {
            self.pushToAddSellerAccountFromSellNowController { success in
                if success == false {
                    RBAlert.showWarningAlert(message: "Add your PayPal acccount to receive online payment. You can add it in settings.")
                }
                self.pushToSendOfferController(productDetail: self.product)
            }
        }
    }

    private func throwCurrentUserBack() {
        RBAlert.showWarningAlert(message: "Sorry! You cannot perform this on your own item.")
        if let controllers = self.navigationController?.viewControllers, controllers.count >= 2, let itemListController = controllers[controllers.count - 2] as? RBCategoriesItemListViewController {
            itemListController.reloadListOnUserThrowBack()
            _ = self.navigationController?.popToViewController(itemListController, animated: true)
        } else {
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }

    // MARK: - View Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        registerTableViewCells()
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

        self.setSendOfferButtonText()

        lblHeader.text = product?.fullTitle()
        btnSellNow.layer.cornerRadius = 4.0
        btnSellNow.layer.masksToBounds = true
        self.addShadowUnderNavBarItemDetails()
        self.applyGradientToSellNowBackgroundItemDetails()

        self.collectionItemImages.reloadData()
        self.tblItemDetails.reloadData()

        if arrImages.count == 0 {
            pageControl.isHidden = true
        }
    }

    func setSendOfferButtonText() {
        if let isOffered = product?.isAlreadyOffered(), isOffered == true {
            btnSellNow.setTitle("Offer Has Been Sent", for: UIControlState.normal)
            btnSellNow.isUserInteractionEnabled = false
            btnSellNow.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
        }
    }

    //Regster table view cells
    func registerTableViewCells() {
        tblItemDetails.register(UINib(nibName: "RBItemNameCell", bundle: nil), forCellReuseIdentifier: RBItemNameCell.identifier())
        tblItemDetails.register(UINib(nibName: "RBItemInterestedBuyerCell", bundle: nil), forCellReuseIdentifier: RBItemInterestedBuyerCell.identifier())
        tblItemDetails.register(UINib(nibName: "RBItemDescriptionCell", bundle: nil), forCellReuseIdentifier: RBItemDescriptionCell.identifier())
    }

    //Add shadow to navigation view
    func addShadowUnderNavBarItemDetails() {
        vwNavBar.layer.shadowColor = UIColor.black.cgColor
        vwNavBar.layer.shadowOffset = CGSize(width: 0, height: -10)
        vwNavBar.layer.shadowOpacity = 1
        vwNavBar.layer.shadowRadius = 10
        vwNavBar.layer.shadowPath = UIBezierPath(rect: vwNavBar.bounds).cgPath
    }

    //Add page control
    func setupPageControl() {
        self.pageControl.dotSize = CGSize(width: 33.0, height: 30.0)
        self.pageControl.spacingBetweenDots = 5
        var imageCountItemDetails = arrImages.count
        if imageCountItemDetails == 1 {
            imageCountItemDetails = 0
        }
        self.pageControl.numberOfPages = imageCountItemDetails
        self.pageControl.currentDotImage = UIImage(named: "page_selected.png")
        self.pageControl.dotImage = UIImage(named: "page_unselected.png")
    }

    //Apply gradient to cell now
    func applyGradientToSellNowBackgroundItemDetails() {
        let gradientItemDetails: CAGradientLayer = CAGradientLayer()
        let startColorItemDetails = UIColor(white: 1.0, alpha: 1.0)
        let endColorItemDetails = UIColor(white: 1.0, alpha: 0.0)
        gradientItemDetails.colors = [endColorItemDetails.cgColor, startColorItemDetails.cgColor]
        gradientItemDetails.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientItemDetails.endPoint = CGPoint(x: 1.0, y: 0.3)
        gradientItemDetails.frame = CGRect(x: 0.0, y: 0.0, width: self.vwSellNow.frame.size.width, height: self.vwSellNow.frame.size.height)
        self.vwSellNow.layer.insertSublayer(gradientItemDetails, at: 0)
    }


    // MARK: - Other Methods
    func navBarShowingItemDetails() {
        UIView.transition(with: self.btnBack, duration: 1.0, options: .transitionCrossDissolve, animations: {
            self.btnBack.setImage(UIImage(named: "back.png"), for: .normal)
        }, completion: nil)

        UIView.transition(with: self.btnCart, duration: 1.0, options: .transitionCrossDissolve, animations: {
            self.btnCart.setImage(UIImage(named: "cart.png"), for: .normal)
        }, completion: nil)
        self.changeStatusBarStyleToWhite(isWhite: false)
    }

    func checkSelfUserLoggendAndProceed(completion: (() -> ())) {
        if let itemPostUser = self.product?.user, RBUserManager.sharedManager().compareCurrentUser(with: itemPostUser) {
            self.throwCurrentUserBack()
        } else {
            completion()
        }
    }

    func navBarHidingItemDetails() {
        UIView.transition(with: self.btnBack, duration: 1.0, options: .transitionCrossDissolve, animations: {
            self.btnBack.setImage(UIImage(named: "back_white.png"), for: .normal)
        }, completion: nil)

        UIView.transition(with: self.btnCart, duration: 1.0, options: .transitionCrossDissolve, animations: {
            self.btnCart.setImage(UIImage(named: "cart_white.png"), for: .normal)
        }, completion: nil)
        self.changeStatusBarStyleToWhite(isWhite: true)
    }
}

extension RBItemDetailsViewController {

    // MARK: - Scrollview Delegate
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView == self.tblItemDetails {

            let scrollOffsetItemDetails: CGFloat = scrollView.contentOffset.y

            //Check offset
            if scrollOffsetItemDetails < 0 {
                self.collectionItemImages.frame = CGRect(x: scrollOffsetItemDetails, y: scrollOffsetItemDetails, width: self.vwHeader.frame.size.width - (scrollOffsetItemDetails * 2), height: self.vwHeader.frame.size.height - scrollOffsetItemDetails)
            } else {
                self.collectionItemImages.frame = CGRect(x: 0, y: 0, width: self.vwHeader.frame.size.width, height: self.vwHeader.frame.size.height)
            }

            self.collectionItemImages.contentOffset = CGPoint(x: self.pageControl.currentPage * Int(self.collectionItemImages.frame.size.width), y: 0)
            self.collectionItemImages.reloadData()

            //Navigation header alpha update
            let offsetItemDetails: CGFloat = scrollView.contentOffset.y
            let startPositionItemDetails = self.vwHeader.frame.size.height - 100

            if offsetItemDetails > startPositionItemDetails {
                let alpha: CGFloat = min(CGFloat(1), CGFloat(1) - (CGFloat(startPositionItemDetails) + (vwNavBar.frame.height) - offsetItemDetails) / (vwNavBar.frame.height))
                vwNavBar.alpha = CGFloat(alpha)

                if let cell = self.tblItemDetails.cellForRow(at: IndexPath(row: 0, section: 0)) as? RBItemNameCell {
                    cell.lblItemName.alpha = 1.0 - alpha
                }

                if alpha > 0.6 {
                    self.navBarShowingItemDetails()
                } else {
                    self.navBarHidingItemDetails()
                }

            } else {
                vwNavBar.alpha = 0.0

                if let cell = self.tblItemDetails.cellForRow(at: IndexPath(row: 0, section: 0)) as? RBItemNameCell {
                    cell.lblItemName.alpha = 1.0
                }

                self.navBarHidingItemDetails()
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionItemImages {
            let page = self.collectionItemImages.contentOffset.x / self.collectionItemImages.frame.size.width
            self.pageControl.currentPage = Int(page)
        }
    }
}
