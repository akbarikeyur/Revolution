//
//  RBOnboardingViewController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 28/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBOnboardingViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var scrollViewFade: UIScrollView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backOnboardingButton: UIButton!
    @IBOutlet weak var pageControlView: UIView!

    //MARK: - Variables -
    var arrayFadeTutorialImages = [Onboarding.imageTitle.first.rawValue,
        Onboarding.imageTitle.second.rawValue,
        Onboarding.imageTitle.third.rawValue,
        Onboarding.imageTitle.fourth.rawValue]

    var arrayFadeTutorialTitle = [Onboarding.title.first.rawValue,
        Onboarding.title.second.rawValue,
        Onboarding.title.third.rawValue,
        Onboarding.title.fourth.rawValue]

    var arrayFadeTutorialSubtitle = [Onboarding.subtitle.first.rawValue,
        Onboarding.subtitle.second.rawValue,
        Onboarding.subtitle.third.rawValue,
        Onboarding.subtitle.fourth.rawValue]

    var didEndAnimate: Bool = false
    var previousTouchPoint: CGFloat = 0.0
    var onBoardingViaSettings: Bool = false
    var customPageControl: RBPageControl = RBPageControl()
    internal let numberOfTutorials: Int = 4

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeFadeTutorialClass()
    }

    //MARK: - Initialize fade tutorial class -
    private func initializeFadeTutorialClass() {

        //Add indicators
        self.addCustomPageControl()

        //Arrange views
        for i in 0 ... numberOfTutorials - 1 {

            let imageName: String = arrayFadeTutorialImages[i]

            //Add imageview
            if i == 0 {
                self.addToScrollView(imageView: imageName, index: i, alpha: 1)
            } else {
                self.addToScrollView(imageView: imageName, index: i, alpha: 0)
            }

            //Add title
            self.addToScrollView(titleLabel: i)

            //Add subtitle
            self.addToScrollView(subTitleLabel: i)
        }

        self.addToScrollView(imageView: arrayFadeTutorialImages[3], index: 3, alpha: 0)
        self.scrollViewFade.contentSize = CGSize(width: Constants.KSCREEN_WIDTH * 4, height: Constants.KSCREEN_HEIGHT)

        self.view.sendSubview(toBack: self.scrollViewFade)
        self.view.bringSubview(toFront: self.pageControlView)

        if self.onBoardingViaSettings == true {
            self.backOnboardingButton.isHidden = false
            self.skipButton.isHidden = true
            self.nextButton.isHidden = true
            self.pageControlView.isHidden = true
        } else {
            self.backOnboardingButton.isHidden = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Show hidden button in case user came via settings.
        if self.onBoardingViaSettings == true {
            self.skipButton.isHidden = false
            self.nextButton.isHidden = false
            self.pageControlView.isHidden = false
        }
    }

    //MARK: - Add custom page control -
    private func addCustomPageControl() {

        //Set frame
        customPageControl.frame = CGRect(x: 0, y: 0, width: self.pageControlView.bounds.size.width, height: self.pageControlView.bounds.size.height)

        //Add indicators
        customPageControl.addPageIndicators(number: numberOfTutorials) { (index, value) -> (Void) in

            let pageNumber: Int = index
            self.scrollViewFade.setContentOffset(CGPoint(x: Constants.KSCREEN_WIDTH * CGFloat(pageNumber), y: 0), animated: true)
        }
        self.pageControlView.addSubview(customPageControl)
    }

    //MARK: - Private methods to intialize tutorials -
    private func addToScrollView(imageView name: String, index: Int, alpha: CGFloat) {
        let imageViewFade: UIImageView = UIImageView.init(frame: self.rectOfView(imageView: index))
        imageViewFade.contentMode = UIViewContentMode.center
        imageViewFade.image = UIImage.init(named: name)
        imageViewFade.clipsToBounds = true
        imageViewFade.alpha = alpha
        imageViewFade.isUserInteractionEnabled = false
        imageViewFade.tag = index + 1
        self.view.addSubview(imageViewFade)
    }

    //Add title to scrollView
    private func addToScrollView(titleLabel index: Int) {
        let titleLabel: UILabel = UILabel.init(frame: self.rectOfView(titleLabel: index))
        titleLabel.text = self.arrayFadeTutorialTitle[index]
        titleLabel.font = UIFont.avenirNextMediun(19.0)
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = Constants.color.onboardingTitleColor
        titleLabel.numberOfLines = 0
        self.scrollViewFade.addSubview(titleLabel)
    }

    //Add subtititle to scrollView
    private func addToScrollView(subTitleLabel index: Int) {
        let subTitleLabel: UILabel = UILabel.init(frame: self.rectOfView(subTitleLabel: index))
        subTitleLabel.text = self.arrayFadeTutorialSubtitle[index]
        subTitleLabel.font = UIFont.avenirNextRegular(15.0)

        //Change subtitle height
        if let subTitleLabelText: String = subTitleLabel.text {
            var subtitleFrame: CGRect = subTitleLabel.frame
            subtitleFrame.size.height = self.getLabelTitleHeight(messageString: subTitleLabelText, font: subTitleLabel.font)
            subTitleLabel.frame = subtitleFrame
        }

        subTitleLabel.textAlignment = NSTextAlignment.center
        subTitleLabel.textColor = Constants.color.onboardingTitleColor
        subTitleLabel.numberOfLines = 4
        self.scrollViewFade.addSubview(subTitleLabel)
    }

    //Get label height
    private func getLabelTitleHeight(messageString: String, font: UIFont) -> CGFloat {
        let labelMaxWidth: CGFloat = Constants.KSCREEN_WIDTH - (2.0 * 20.0)
        let fontUsed: UIFont = font

        let constraintRect = CGSize(width: labelMaxWidth, height: CGFloat.greatestFiniteMagnitude)

        let boundingBox = messageString.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: fontUsed], context: nil)

        return ceil(boundingBox.height)
    }

    //Rect of imageview
    private func rectOfView(imageView index: Int) -> CGRect {
        var rectOfView: CGRect = CGRect.zero
        if let sizeOfImage: CGSize = self.sizeOfView(imageView: index) {

            let topMultiplier: CGFloat = ((Constants.KSCREEN_HEIGHT / 2) - (33.5 * Constants.KSCREEN_HEIGHT_RATIO)) - sizeOfImage.height
            let leftMutiplier: CGFloat = (Constants.KSCREEN_WIDTH / 2 - sizeOfImage.width / 2)
            rectOfView = CGRect(x: leftMutiplier, y: topMultiplier, width: sizeOfImage.width, height: sizeOfImage.height)
        }
        return rectOfView
    }

    //Rect of title
    private func rectOfView(titleLabel index: Int) -> CGRect {
        //        let topMutiplier: CGFloat = ((Constants.KSCREEN_HEIGHT/2) + (14.5 * Constants.KSCREEN_HEIGHT_RATIO))
        let topMutiplier: CGFloat = ((Constants.KSCREEN_HEIGHT / 2) + (1 * Constants.KSCREEN_HEIGHT_RATIO))
        let leftMultiplier: CGFloat = Constants.KSCREEN_WIDTH * CGFloat(index)
        let rectOfView: CGRect = CGRect(x: leftMultiplier, y: topMutiplier, width: Constants.KSCREEN_WIDTH, height: 50)
        return rectOfView
    }

    //Rect of subtitle
    private func rectOfView(subTitleLabel index: Int) -> CGRect {
        let topMutiplier: CGFloat = ((Constants.KSCREEN_HEIGHT / 2) + (56.5 * Constants.KSCREEN_HEIGHT_RATIO))
        //        let topMutiplier: CGFloat = ((Constants.KSCREEN_HEIGHT/2) + (15.5 * Constants.KSCREEN_HEIGHT_RATIO))
        let leftMultiplier: CGFloat = (Constants.KSCREEN_WIDTH * CGFloat(index)) + 20
        let rectOfView: CGRect = CGRect(x: leftMultiplier, y: topMutiplier, width: Constants.KSCREEN_WIDTH - 40, height: 100)
        return rectOfView
    }

    //Size of view
    private func sizeOfView(imageView index: Int) -> CGSize? {
        if let image: UIImage = UIImage.init(named: self.arrayFadeTutorialImages[index]) {
            return image.size
        }
        return nil
    }

    //MARK: - IBActions -
    @IBAction func skipTutorialAction(sender: AnyObject) {
        self.pushToAnotherClass()
    }

    @IBAction func nextTutorialAction(sender: AnyObject) {
        if self.nextButton.titleLabel?.text == Onboarding.buttonTitle.gotIt.rawValue {
            self.pushToAnotherClass()
        } else if self.customPageControl.currentPage < self.numberOfTutorials - 1 {
            self.scrollViewFade.setContentOffset(CGPoint(x: Constants.KSCREEN_WIDTH * CGFloat(self.customPageControl.currentPage + 1), y: 0), animated: true)
        }
    }

    @IBAction func backOnboardingAction(sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    private func pushToAnotherClass() {
        if self.onBoardingViaSettings == true {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            pushToSignUpMenu()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
