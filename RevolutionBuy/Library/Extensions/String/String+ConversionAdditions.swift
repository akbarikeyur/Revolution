//
//  String+Additions.swift
//
//  Created by Pawan Joshi on 30/03/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

// MARK: - String Extension
extension String {

    /**
     Convert html string into  normal string
     */
    var html2AttributedString: NSAttributedString? {
        guard
            let data = data(using: String.Encoding.utf8)
            else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8], documentAttributes: nil)
        } catch let error as NSError {
            LogManager.logDebug("\(error.localizedDescription)")
            return nil
        }
    }

    var html2String: String {
        return html2AttributedString?.string ?? ""
    }

}
