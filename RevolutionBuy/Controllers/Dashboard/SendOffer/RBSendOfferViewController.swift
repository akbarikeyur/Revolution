//
//  RBSendOfferViewController.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 30/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBSendOfferViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Constants

    let kRBSendOfferCellIdentifier = "RBSendOfferCellIdentifier"

    // MARK: - Variables

    var arrImages: [AnyObject?] = [nil, nil, nil]
    var currentIndex = -1
    var product: RBProduct?
    var selectedCurrency : String?
    
    // MARK: - IBOutlets

    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var vwNavBar: UIView!
    @IBOutlet weak var tblSendOffer: UITableView!
    @IBOutlet var vwImages: [UIView]!
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var btnSendOffer: UIButton!
    @IBOutlet var btnImages: [UIButton]!
    @IBOutlet var btnCross: [UIButton]!
    

    // MARK: - View Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()

        for btn in btnImages {
            btn.isExclusiveTouch = true
        }

        for btn in btnCross {
            btn.isExclusiveTouch = true
        }

        UIApplication.shared.statusBarStyle = .default
        
        self.btnSendOffer.isExclusiveTouch = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupUI() {
        vwHeader.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * (257.0 / 667.0))
        viewFooter.frame.size.height = UIScreen.main.bounds.size.height * (102 / 667.0)

        for button in btnImages {
            button.imageView?.contentMode = .scaleAspectFill
        }
        //  addShadowUnderNavBar()
        setupBorders()
        updateImageViews()
    }

    func setupBorders() {
        for view in vwImages {
            view.layer.borderColor = UIColor(red: 224.0 / 255.0, green: 224.0 / 255.0, blue: 224.0 / 255.0, alpha: 1.0).cgColor
            view.layer.borderWidth = 0.8
            view.layer.cornerRadius = 4.0
            view.layer.masksToBounds = true
        }
        btnSendOffer.layer.cornerRadius = 4.0
        btnSendOffer.layer.masksToBounds = true
    }

    func sendOffer() {

        if let productId = product?.internalIdentifier {
            let images = arrImages.filter { $0 != nil }
            if images.count == 0 {
                RBAlert.showWarningAlert(message: Alert.imageOfProductRequired.rawValue, completion: nil)
                return
            }

            if selectedCurrency == nil {
                RBAlert.showWarningAlert(message: Alert.selectCurrency.rawValue, completion: nil)
                return
            }
            
            if let cell = self.tblSendOffer.cellForRow(at: IndexPath(row: 0, section: 0)) as? RBSendOfferCell {

                self.modifyCell(cell: cell)
                
                guard let priceText = cell.txtfPrice.text, priceText.length > 0 else {
                    RBAlert.showWarningAlert(message: "Please enter price")
                    return
                }
                
                let decimalPrice = ((priceText as NSString).doubleValue)
                if decimalPrice <= 0.0 {
                    RBAlert.showWarningAlert(message: "Please enter a valid price")
                    return
                }
                
                //Show loader
                self.view.showLoader(mainTitle: "", subTitle: Constants.APIKey.loading)

                //Create parameter
//                let params = [Constants.APIKey.buyerProductId : String(productId), Constants.APIKey.price: "\(decimalPrice)",Constants.APIKey.description: cell.txtvwItemDescription.text] as [String : Any] // developer commented

                let cell = self.tblSendOffer.cellForRow(at: IndexPath(row: 0, section: 0)) as! RBSendOfferCell
                
                let params = [Constants.APIKey.buyerProductId : String(productId), Constants.APIKey.price: "\(decimalPrice)",Constants.APIKey.description: "\(cell.txtfPrice.currency)" + "&&" + cell.txtvwItemDescription.text] as [String : Any]
                
                RBCategoryItemRecords.sendOfferByseller(images as! [UIImage], params: params as! [String : String] ) { (success, error,message) -> (Void) in
                    
                    //Hide loader
                    self.view.hideLoader()

                    self.handleSendOfferResponse(success: success, error: error, message: message)
                }
            }
        }
    }

    private func handleSendOfferResponse(success: Bool, error: Error?, message: String) {
        if success == true {
            self.pushToItemConfirmationController()
        } else {
            RBWarningAlertView.showAlert(message: message, onCompletion: nil)
            if let theError = error {
                self.processSendOfferError(error: theError)
            }
        }
    }

    private func processSendOfferError(error: Error) {
        /*
         statusCode :
         203 = You can not send an offer to self.
         208 = Offer Already Sent
         204 = Offer Deleted
         */

        let statusCodeOfferDeleted = 204
        let statusCodeOfferAlreadySent = 208
        let statusCodeCantSendOfferToSelf = 203
        let reportedCode = (error as NSError).code
        if statusCodeOfferAlreadySent == reportedCode {
            self.product?.sellerProducts = 1
            if let controllers = self.navigationController?.viewControllers, controllers.count >= 2, let itemDetailController = controllers[controllers.count - 2] as? RBItemDetailsViewController {
                itemDetailController.setSendOfferButtonText()
                _ = self.navigationController?.popToViewController(itemDetailController, animated: true)
            } else {
                _ = self.navigationController?.popViewController(animated: true)
            }
        } else if reportedCode == statusCodeCantSendOfferToSelf || reportedCode == statusCodeOfferDeleted {
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }

    private func modifyCell(cell: RBSendOfferCell) {

        if cell.txtfPrice.text == "" || cell.txtfPrice.text?.characters.count == 0 {
            cell.txtfPrice.textFieldType = TextFieldType.warning
            RBWarningAlertView.showAlert(message: Alert.priceRequired.rawValue, onCompletion: nil)
            return }

        if cell.txtfPrice.text == "0" {
            cell.txtfPrice.textFieldType = TextFieldType.warning
            RBWarningAlertView.showAlert(message: Alert.validPriceRequired.rawValue, onCompletion: nil)
            return }

        if cell.txtvwItemDescription.text.characters.count >= 255 {
            RBWarningAlertView.showAlert(message: Alert.descriptionLengthValidation.rawValue, onCompletion: nil)
            return }
    }

    // MARK: - IBActions

    @IBAction func selectCurrency(_ sender: Any) {
        
        let controller: RBCurrencySelectorViewController = storyboard?.instantiateViewController(withIdentifier: currencySelectorViewControllerIdentifier) as! RBCurrencySelectorViewController
     
        controller.setCompletionHandler { (result, error) in
            
            let cell = self.tblSendOffer.cellForRow(at: IndexPath(row: 0, section: 0)) as! RBSendOfferCell
            
            self.selectedCurrency = (result?["currency"] as? String) ?? ""
            cell.txtfPrice.currency = self.selectedCurrency ?? ""
            cell.btnSelectCurrency.setTitle("  Selected Currency: \((self.selectedCurrency ?? ""))", for: .normal)
            cell.btnSelectCurrency.setTitleColor(Constants.color.themeDarkBlueColor, for: .normal)
            
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func selectPhoto(_ sender: Any) {

        DispatchQueue.main.async {
            self.view.endEditing(true)
        }

        currentIndex = (sender as! UIButton).tag - 100
        RBCustomImagePickerView.showCustomImagePickerView { (selectionType) in

            switch selectionType {
            case RBCustomImagePickerView.SelectedSourceType.camera:
                self.captureImageFromDevice(camera: true, useFrontCam: false)
            case RBCustomImagePickerView.SelectedSourceType.photoLibrary:
                self.captureImageFromDevice(camera: false, useFrontCam: false)
            case RBCustomImagePickerView.SelectedSourceType.cancel:
                break
            }

        }
    }

    @IBAction func removePhoto(_ sender: Any) {

        let msgNoPrimaryImage = AddImageIdentifier.RemoveImageAlert.Title.rawValue
        let leftBtnAttribute = RBConfirmationButtonAttribute.init(title: AddImageIdentifier.RemoveImageAlert.CancelTitle.rawValue)
        let rightBtnAttribute = RBConfirmationButtonAttribute.init(title: AddImageIdentifier.RemoveImageAlert.YesTitle.rawValue, borderType: ConfirmationButtonType.BorderedOnly) {
            let index = (sender as! UIButton).tag - 100
            self.arrImages[index] = nil
            self.updateImageViews()
        }
        RBAlert.showConfirmationAlert(message: msgNoPrimaryImage, leftButtonAttributes: leftBtnAttribute, rightButtonAttributes: rightBtnAttribute)
    }

    @IBAction func sendOfferBtnAction(_ sender: Any) {

        sendOffer()
    }

    @IBAction func goBack(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Other Methods

    func updateImageViews() {
        for i in 0 ..< arrImages.count {
            let image = arrImages[i]
            if image == nil {
                // No image is there
                if let btnCross = self.getCrossAtIndex(index: i) {
                    btnCross.isHidden = true
                }
                if let btnImage = self.getImageSelectButtonAtIndex(index: i) {
                    btnImage.setImage(UIImage(named: "add_photo.png"), for: .normal)
                }
            } else {
                // Image is there
                if let btnCross = self.getCrossAtIndex(index: i) {
                    btnCross.isHidden = false
                }
                if let btnImage = self.getImageSelectButtonAtIndex(index: i) {
                    btnImage.setImage(image as! UIImage?, for: .normal)
                }
            }
        }
    }

    func getCrossAtIndex(index: Int) -> UIButton? {
        for button in self.btnCross {
            if button.tag == 100 + index {
                return button
            }
        }
        return nil
    }

    func getImageSelectButtonAtIndex(index: Int) -> UIButton? {
        for button in self.btnImages {
            if button.tag == 100 + index {
                return button
            }
        }
        return nil
    }
}

