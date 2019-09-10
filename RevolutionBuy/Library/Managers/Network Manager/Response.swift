//
//  ApiResponse.swift
//
//  Created by Pawan Joshi on 20/02/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

let kHTTPRequestDomain = "com.httprequest"
let kResponseStatus = "success"
let kResponseCode = "statusCode"
let kResponseMessage = "message"

/// ApiResponseInfo used to store URL response.
class Response: NSObject {

    // The data received during the request.
    var responseData: Data?

    // The error received during the request.
    var responseError: Error?

    // The dictionary received after parsing the received data.
    var resultDictionary: NSDictionary?

    /**
     The response status after parsing the received data.

     - returns: true if success code return
     */
    var success: Bool {
        get {
            if let resultDictionary = self.resultDictionary, let status = resultDictionary[kResponseStatus] {
                return (status as AnyObject).boolValue
            }
            return false
        }
    }

    /**
     The response string from the received data.

     - returns: Returns the response as a string
     */
    var text: String? {

        guard let _ = responseData else {
            return nil
        }
        return String(data: responseData!, encoding: String.Encoding.utf8)
    }

    override init() {

        super.init()
        self.responseData = nil
        self.resultDictionary = nil
    }

    init(data: Data?) {

        super.init()

        if isObjectInitialized(data as AnyObject?) {

            self.responseData = data

            do {
                // Try parsing some valid JSON
                self.resultDictionary = try JSONSerialization.jsonObject(with: responseData!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                if !success {
                    responseError = error()
                }
            }
            catch let error as NSError {
                // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                print("A JSON parsing error occurred, here are the details:\n \(error)")
                responseError = error
            }
        }
    }

    init(error: Error?) {
        super.init()
        responseError = error
    }

    // MARK: - Getters Methods

    /**
     The responseCode received after parsing the received data.

     - returns: get response code from api response data.
     */
    func responseCode() -> Int {

        if let resultDictionary = self.resultDictionary, let code = resultDictionary[kResponseCode] as? Int {
            return code
        }

        return -1 // Unknown response code.
    }

    /**
     The message received after parsing the received data.

     - returns: response message from api response data.
     */
    func message() -> String {

        if let resultDictionary = self.resultDictionary, let message = resultDictionary[kResponseMessage] as? String {
            return message
        }

        return (self.success) ? NSLocalizedString("Action performed successfully.", comment: "Action performed successfully.") : NSLocalizedString("An error occurred while performing this request. Please try again later.", comment: "An error occurred while performing this request. Please try again later.")
    }

    /**
     The responseError received after parsing the received data.

     - returns: error if api failed.
     */

    fileprivate func error() -> NSError? {

        let errorDictionary = [NSLocalizedFailureReasonErrorKey: NSLocalizedString("Error", comment: "Error"), NSLocalizedDescriptionKey: self.message()]
        return NSError(domain: kHTTPRequestDomain, code: self.responseCode(), userInfo: errorDictionary)
    }
}
