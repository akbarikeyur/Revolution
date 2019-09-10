//
//  RBPurchasedItemDetailVC.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 24/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBPurchasedItemDetailVC: RBStatusBarViewController {

    //MARK: - Outlets
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var pageControl: TAPageControl!
    @IBOutlet weak var collectionViewItemImages: UICollectionView!
    @IBOutlet weak var noImageImageView: UIImageView!
    @IBOutlet weak var topSpaceCollectionView: NSLayoutConstraint!

    @IBOutlet weak var topHeaderView: UIView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet var aryHeaderButtons: [UIButton]!
    @IBOutlet weak var titleLabel: UILabel!

    //MARK: - Variables
    var purchasedItem: RBPurchasedProduct!
    let identifierEmptyCell = "RBEmptyCell"
    let kCellIdentifierItemInfo = "kCellIdentifierItemInfo"
    let kCellIdentifierSellerInfo = "kCellIdentifierSellerInfo"
    let kCellIdentifierSellerMobileNumber = "kCellIdentifierSellerMobileNumber"

    var detailDataSource: [String] = [String]()

    //MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        self.registerTableViewCells()

        // setup datasource
        self.initTableDataSource()
        self.setUpHeader()
        self.setupPageControlPurchasedItemDetails()
        self.setUpElementsForHeaderFadeAnimation()
    }

    //MARK: - Class Methods
    class func controllerInstance(with purchasedItem: RBPurchasedProduct) -> RBPurchasedItemDetailVC {
        let controller: RBPurchasedItemDetailVC = UIStoryboard.purchasedStoryboard().instantiateViewController(withIdentifier: RBPurchasedItemDetailVC.identifier()) as! RBPurchasedItemDetailVC
        controller.purchasedItem = purchasedItem
        return controller
    }

    class func identifier() -> String {
        return "RBPurchasedItemDetailVC"
    }

    //MARK: - Methods
    private func registerTableViewCells() {

        self.detailTableView.estimatedRowHeight = 10
        self.detailTableView.rowHeight = UITableViewAutomaticDimension
        self.detailTableView.separatorStyle = .none

        self.detailTableView.register(UINib(nibName: RBViewSellerOfferTitleTableViewCell.identifier(), bundle: nil), forCellReuseIdentifier: RBViewSellerOfferTitleTableViewCell.identifier())
        self.detailTableView.register(UINib(nibName: "RBItemInterestedBuyerCell", bundle: nil), forCellReuseIdentifier: RBItemInterestedBuyerCell.identifier())
        self.detailTableView.register(UINib(nibName: RBContactNumberTableViewCell.identifier(), bundle: nil), forCellReuseIdentifier: RBContactNumberTableViewCell.identifier())
    }

    func initTableDataSource() {
        self.detailDataSource.removeAll()
        self.detailDataSource.append(kCellIdentifierItemInfo)
        self.detailDataSource.append(identifierEmptyCell)
        if let _ = self.purchasedItem.sellerProductModel() {
            self.detailDataSource.append(kCellIdentifierSellerInfo)
        }
        self.detailDataSource.append(kCellIdentifierSellerMobileNumber)
    }

    func setUpHeader() {
        self.titleLabel.text = self.purchasedItem.titleString()
        let hideNoImagePlaceholder: Bool = self.purchasedItem.numberOfSellerImages() > 0
        self.noImageImageView.isHidden = hideNoImagePlaceholder
        self.collectionViewItemImages.isHidden = !hideNoImagePlaceholder
    }

    private func setUpElementsForHeaderFadeAnimation() {
        self.theScrollView = self.detailTableView
        self.theTableHeaderView = self.tableHeaderView
        self.theTopNavigationView = self.topHeaderView
        self.arrayHeaderAnimationButtons = self.aryHeaderButtons
    }

    func setupPageControlPurchasedItemDetails() {
        self.pageControl.dotSize = CGSize(width: 33.0, height: 30.0)
        self.pageControl.spacingBetweenDots = 5

        var imageCount = 0
        if let countOfImages: Int = self.purchasedItem.sellerProductModel()?.sellerProductImages?.count {
            imageCount = countOfImages
        }
        if imageCount == 1 {
            imageCount = 0
        }
        self.pageControl.numberOfPages = imageCount
        self.pageControl.currentDotImage = UIImage(named: "page_selected.png")
        self.pageControl.dotImage = UIImage(named: "page_unselected.png")
    }

    //MARK: - Clicks
    @IBAction func clickBack(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }

    func clickMobileNumber() {

        let number: String = self.purchasedItem.sellerMobileNumber()
        if number.length == 0 {
            RBAlert.showWarningAlert(message: "Sorry! No contact found.")
            return
        }

        RBGenericMethods.promtToMakeCall(phoneNumber: number)
    }
}
