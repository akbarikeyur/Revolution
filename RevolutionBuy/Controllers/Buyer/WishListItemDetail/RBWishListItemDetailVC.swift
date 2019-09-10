//
//  RBWishListItemDetailVC.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 13/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import SDWebImage

class RBWishListItemDetailVC: RBStatusBarViewController {

    //MARK: - Outlets
    @IBOutlet weak var itemDetailTableView: UITableView!
    @IBOutlet weak var pageControl: TAPageControl!
    @IBOutlet weak var collectionViewItemImages: UICollectionView!
    @IBOutlet weak var noImageImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var topSpaceCollectionView: NSLayoutConstraint!

    @IBOutlet weak var topHeaderView: UIView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet var aryHeaderButtons: [UIButton]!
    @IBOutlet weak var titleLabel: UILabel!

    //MARK: - Variables
    var item: RBProduct!
    var itemIndex: Int = 0
    let navFinalColor = UIColor.white
    let identifierEmptyCell = "RBEmptyCell"
    let kCellIdentifierName = "kCellIdentifierName"
    let kCellIdentifierEmpty = "kCellIdentifierEmpty"
    let kCellIdentifierDesc = "kCellIdentifierDesc"

    var tableDataSource: [String] = [String]()

    var wishListController: RBBuyerWishListVC?

    //MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        self.registerTableViewCells()

        // setup datasource
        self.initTableDataSource()
        self.setUpHeader()
        self.setUpElementsForHeaderFadeAnimation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.setUpEditButton()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setupPageControl()
    }

    //MARK: - Class Methods
    class func controllerInstance(with product: RBProduct, index: Int) -> RBWishListItemDetailVC {
        let controller: RBWishListItemDetailVC = UIStoryboard.buyerStoryboard().instantiateViewController(withIdentifier: RBWishListItemDetailVC.identifier()) as! RBWishListItemDetailVC
        controller.item = product
        controller.itemIndex = index
        return controller
    }

    class func identifier() -> String {
        return "RBWishListItemDetailVC"
    }

    //MARK: - Methods
    private func registerTableViewCells() {

        self.itemDetailTableView.estimatedRowHeight = 10
        self.itemDetailTableView.rowHeight = UITableViewAutomaticDimension
        self.itemDetailTableView.separatorStyle = .none

        self.itemDetailTableView.register(UINib(nibName: "RBItemNameCell", bundle: nil), forCellReuseIdentifier: RBItemNameCell.identifier())
        self.itemDetailTableView.register(UINib(nibName: "RBItemDescriptionCell", bundle: nil), forCellReuseIdentifier: RBItemDescriptionCell.identifier())

        let nib = UINib(nibName: RBViewSellerOfferFooterView.identifier(), bundle: nil)
        self.itemDetailTableView.register(nib, forHeaderFooterViewReuseIdentifier: RBViewSellerOfferFooterView.identifier())
    }

    func initTableDataSource() {
        self.tableDataSource.removeAll()
        self.tableDataSource.append(kCellIdentifierName)
        if self.item.description().length > 0 {
            self.tableDataSource.append(self.kCellIdentifierEmpty)
            self.tableDataSource.append(self.kCellIdentifierDesc)
        }
    }

    func setUpHeader() {
        self.titleLabel.text = self.item.fullTitle()
        let hideNoImagePlaceholder: Bool = self.item.numberOfBuyerImages() > 0
        self.noImageImageView.isHidden = hideNoImagePlaceholder
        self.collectionViewItemImages.isHidden = !hideNoImagePlaceholder
        self.setUpEditButton()
    }

    private func setUpElementsForHeaderFadeAnimation() {
        self.theScrollView = self.itemDetailTableView
        self.theTableHeaderView = self.tableHeaderView
        self.theTopNavigationView = self.topHeaderView
        self.arrayHeaderAnimationButtons = self.aryHeaderButtons
    }

    private func setUpEditButton() {
        self.editButton.alpha = (self.item.hasOffers() ? 0.4 : 1.0)
    }

    func setupPageControl() {
        if let pageControl = self.pageControl {
            pageControl.dotSize = CGSize(width: 33.0, height: 30.0)
            pageControl.spacingBetweenDots = 5
            pageControl.currentPage = 0
            var imageCount = self.item.numberOfBuyerImages()
            if imageCount == 1 {
                imageCount = 0
            }
            pageControl.numberOfPages = imageCount
            pageControl.currentDotImage = UIImage(named: "page_selected.png")
            pageControl.dotImage = UIImage(named: "page_unselected.png")
        }
    }

    private func apiCallDeleteWishListItem() {
        self.view.showLoader(subTitle: WishListDetailIdentifier.LoaderText.Deleting.rawValue)
        self.item.deleteItemAPI { (deletedFromServer, msg) in
            self.view.hideLoader()
            if deletedFromServer {

                let backBlock = {
                    self.clickBack(nil)
                    RBAlert.showSuccessAlert(message: "Item deleted")
                }

                if let theController: RBBuyerWishListVC = self.wishListController {
                    theController.deleteItem(item: self.item, completion: { (deleted) in
                        backBlock()
                    })
                } else {
                    backBlock()
                }
            } else if msg.length > 0 {
                RBAlert.showWarningAlert(message: msg)
            }
        }
    }

    //MARK: - Present screens
    private func proceedToSharePreparation() {
        guard let itemID: Int = self.item.internalIdentifier else {
            RBAlert.showWarningAlert(message: "Item not found")
            return
        }

        if self.item.numberOfBuyerImages() > 0, let theUrlString = self.item.buyerProductImages?.first?.imageName, let theUrl: URL = URL.init(string: theUrlString) {

            let loader = self.view.showProgressLoader(subTitle: "Loading\nimage...")
            let manager: SDWebImageManager = SDWebImageManager.shared()
            manager.downloadImage(with: theUrl, options: SDWebImageOptions(rawValue: 0), progress: { (receivedSize, expectedSize) in
                let progress = Double(receivedSize) / Double(expectedSize)
                loader.progress = Float(progress)
            }, completed: { (image, error, cacheType, finished, imageURL) in
                self.view.hideLoader()
                self.presentShareSheet(itemID: itemID, image: image)
            })
        } else {
            self.presentShareSheet(itemID: itemID, image: nil)
        }
    }

    private func presentShareSheet(itemID: Int, image: UIImage?) {

        // attributes to share
        let title = "Hey! Checkout this item on RevolutionBuy app.\n\n" + self.item.fullTitle().uppercased() + "\n\n" + self.item.description() + "\n\n"
        let url = RBGenericMethods.deeplinkURL(with: itemID)
        var itemsToShare: [Any] = [title, url]
        if let theImage = image {
            itemsToShare.append(theImage)
        }

        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo, UIActivityType.airDrop]
        self.present(activityViewController, animated: true, completion: nil)
    }

    private func presentEditItemScren() {

        var idArray: [String] = [String]()
        if let categories = self.item.buyerProductCategories, categories.count > 0 {
            for category in categories {
                if let theId = category.categoryId {
                    idArray.append("\(theId)")
                }
            }
        }

        let addItemController = RBAddItemBaseVC.instanceController()
        addItemController.addEditDelegate = self
        addItemController.tempItem.identifier = self.item.internalIdentifier
        addItemController.tempItem.title = self.item.fullTitle()
        addItemController.tempItem.itemDescription = self.item.description()
        addItemController.tempItem.categoryIds = idArray
        addItemController.tempItem.productImages = self.item.buyerProductImages

        self.present(addItemController, animated: true, completion: nil)
    }

    //MARK: - Clicks
    @IBAction func clickNavigateToSellerOffers() {
        self.pushToViewSellerOfferController(productDetail: self.item)
    }

    @IBAction func clickDelete(_ sender: UIButton) {

        let msgDelete = "Are you sure you want to delete this item?"
        let leftBtnAttribute = RBConfirmationButtonAttribute.init(title: "Cancel", borderType: .Filled, clickCompletion: nil)
        let rightBtnAttribute = RBConfirmationButtonAttribute.init(title: "Delete", borderType: ConfirmationButtonType.BorderedOnly) {
            self.apiCallDeleteWishListItem()
        }
        RBAlert.showConfirmationAlert(message: msgDelete, leftButtonAttributes: leftBtnAttribute, rightButtonAttributes: rightBtnAttribute)
    }

    @IBAction func clickBack(_ sender: UIButton?) {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickEdit(_ sender: Any) {

        // Check to avoid editing if item has Offers
        if self.item.hasOffers() {
            RBAlert.showWarningAlert(message: "You cannot edit this because it has offers.")
            return
        }

        self.presentEditItemScren()
    }

    @IBAction func clickShare(_ sender: UIButton) {
        self.proceedToSharePreparation()
    }
}
