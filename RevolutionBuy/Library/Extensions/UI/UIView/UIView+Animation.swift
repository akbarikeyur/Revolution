//
//  UIView+Animation.swift
//
//  Created by Arvind Singh on 16/06/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

// MARK: - UIView Extension
extension UIView {

    /**
     Do animation

     - parameter nextView:           View to present
     - parameter duration:           Duration of the animation
     - parameter type:               The name of the transition. Current legal transition types include `fade', `moveIn', `push' and `reveal'. Defaults to `fade'.
     - parameter timingFunctionName: The currently supported names are `linear', `easeIn', `easeOut' and `easeInEaseOut' and `default' (the curve used by implicit animations created by Core Animation).
     - parameter subtype:            An optional subtype for the transition. E.g. used to specify the transition direction for motion-based transitions, in which case the legal values are `fromLeft', `fromRight', `fromTop' and `fromBottom'.
     - parameter fillMode:           The legal values are `backwards', `forwards', `both' and `removed'. Defaults to `removed'.
     - parameter animationKey:       Animation key name
     */
    func doAnimation(_ view: UIView, duration: Float, type: String, timingFunctionName: String, subtype: String?, fillMode: String, animationKey: String) {
        let animation: CATransition = CATransition()
        animation.duration = CFTimeInterval(duration)
        animation.type = type
        animation.timingFunction = CAMediaTimingFunction(name: timingFunctionName)
        animation.subtype = subtype
        animation.fillMode = fillMode
        view.layer.add(animation, forKey: animationKey)
    }

    /**
     Do animation

     - parameter view:          View to present
     - parameter animationTime: Duration of the animation
     - parameter curve:         curve (default = UIViewAnimationCurveEaseInOut)
     - parameter transition:    animation transition
     */
    func doAnimation(_ view: UIView!, animationTime: Float!, curve: UIViewAnimationCurve, transition: UIViewAnimationTransition) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(curve)
        UIView.setAnimationDuration(TimeInterval(animationTime))
        UIView.setAnimationTransition(transition, for: view, cache: false)
        UIView.commitAnimations()
    }

    func animationRotateAndScaleEffects(_ view: UIView!, animationTime: Float!) {
        UIView.animate(withDuration: TimeInterval(animationTime), animations: {
            view.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            let animation: CABasicAnimation = CABasicAnimation(keyPath: "transform")

            animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(M_PI), 1, 0, 0))
            animation.duration = CFTimeInterval(animationTime)
        }, completion: { completion in
            UIView.animate(withDuration: TimeInterval(animationTime), animations: {
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {

        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
