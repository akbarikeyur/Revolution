//
//  RBAddItemStepNumberView.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 30/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBAddItemStepNumberView: ShadowView {

    //MARK: - Variables
    var currentStep: Int = 1
    let stepAnimationDuration: TimeInterval = 0.5
    var numberContainerView: ItemStepNumberView!

    //MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.xibSetup()
    }

    private func xibSetup() {

        numberContainerView = Bundle.main.loadNibNamed("ItemStepNumberView", owner: self, options: nil)?.first as! ItemStepNumberView
        numberContainerView.frame = bounds
        numberContainerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        numberContainerView.backgroundColor = UIColor.white
        numberContainerView.stepView.center = numberContainerView.stepOneLabel.center
        addSubview(numberContainerView)
    }

    //MARK: - Methods
    func incrementStep() {
        if self.currentStep == self.numberContainerView.stepLabels.count {
            return
        }

        let previousSelectedIndex = self.currentStep
        self.currentStep += 1
        let currentSelectedIndex = self.currentStep

        self.animateSelectedChangesFrom(previousIndex: previousSelectedIndex, to: currentSelectedIndex)
    }

    func decrementStep() {
        if self.currentStep == 0 {
            return
        }

        let previousSelectedIndex = self.currentStep
        self.currentStep -= 1
        let currentSelectedIndex = self.currentStep

        self.animateSelectedChangesFrom(previousIndex: previousSelectedIndex, to: currentSelectedIndex)
    }

    private func animateSelectedChangesFrom(previousIndex: Int, to currentIndex: Int) {

        var nowLabel: UILabel?

        for labelItem in self.numberContainerView.stepLabels {
            let tag = labelItem.tag

            if tag < currentIndex {
                labelItem.textColor = Constants.color.themeBlueColor
            } else {
                labelItem.textColor = UIColor.lightGray
            }

            if tag == currentIndex {
                nowLabel = labelItem
            }
        }

        if let currentLabel = nowLabel {
            UIView.animate(withDuration: self.stepAnimationDuration, animations: {
                self.numberContainerView.stepView.center = currentLabel.center
            }, completion: { (completed) in
                currentLabel.textColor = UIColor.white
            })
        }
    }
}
