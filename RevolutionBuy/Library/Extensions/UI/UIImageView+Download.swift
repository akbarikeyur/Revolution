//
//  UIImageView+Download.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 15/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

typealias ImageDownloadCompletion = ((_ image: UIImage?, _ error: Error?, _ url: URL?) -> ())
let spinnerTag = -2011

extension UIImageView {

    func rb_setImageFrom(url: URL, placeholderImage: UIImage? = nil, onCompletion: ImageDownloadCompletion? = nil) {

        // Cancel all previous In-queue download
        self.sd_cancelCurrentImageLoad()

        // 1) get Spinner
        let spinner  = self.getSpinner()
        // 2) Add to imageview
        self.addSubview(spinner)
        // 3) Add contraint if needed
        if spinner.constraints.count == 0 {
            self.addCenterConstraint(to: spinner)
        }

        // 4) Placeholder changes
        if placeholderImage == nil {
            self.image = nil
            self.backgroundColor = Constants.color.themeBlueColor.withAlphaComponent(0.65)
            spinner.color = UIColor.white
        }

        // 5) Start Animating
        spinner.startAnimating()

        // 6) Call image downloading method
        self.sd_setImage(with: url, placeholderImage: placeholderImage, options: [], completed: { (image, error, cache, url) in
            if placeholderImage == nil {
                self.backgroundColor = UIColor.clear
            }
            spinner.stopAnimating()
            spinner.removeFromSuperview()
            onCompletion?(image, error, url)
        })
    }

    private func getSpinner() -> UIActivityIndicatorView {

        if let existingSpinner = self.viewWithTag(spinnerTag) as? UIActivityIndicatorView {
            return existingSpinner
        }

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.tag = spinnerTag
        activityIndicator.color = UIColor.black
        return activityIndicator
    }

    private func addCenterConstraint(to spinner: UIActivityIndicatorView) {

        spinner.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spinner)

        let widthConstraint = NSLayoutConstraint(item: spinner, attribute: .width, relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20)
        spinner.addConstraint(widthConstraint)

        let heightConstraint = NSLayoutConstraint(item: spinner, attribute: .height, relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20)
        spinner.addConstraint(heightConstraint)

        let xConstraint = NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)

        let yConstraint = NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)

        self.addConstraint(xConstraint)
        self.addConstraint(yConstraint)
    }
}
