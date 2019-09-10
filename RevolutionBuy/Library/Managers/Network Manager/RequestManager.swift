//
//  NetworkManager.swift
//
//  Created by Pawan Joshi on 20/02/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import Reachability

public enum HTTPRequestErrorCode: Int {

    case httpConnectionError = 40 // Trouble connecting to Server.
    case httpInvalidRequestError = 50 // Your request had invalid parameters.
    case httpResultError = 60 // API result error (eg: Invalid username and password).
}

class RequestManager: NSObject {

    fileprivate var _urlSession: URLSession?
    fileprivate var _runningURLRequests: NSSet?

    static var networkFetchingCount: Int = 0

    // MARK: - Class Methods

    static func beginNetworkActivity() -> () {
        networkFetchingCount += 1
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    /**
     Call to hide network indicator in Status Bar
     */
    static func endNetworkActivity() -> () {
        if networkFetchingCount > 0 {
            networkFetchingCount -= 1
        }

        if networkFetchingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

    // MARK: - Singleton Instance
    fileprivate static let _sharedManager = RequestManager()

    class func sharedManager() -> RequestManager {
        return _sharedManager
    }

    fileprivate override init() {
        super.init()
        // customize initialization
    }

    // MARK: - Private Methods
    /**
     Craete Urlsession from default configuration.

     - returns: instance of Url Session.
     */
    fileprivate func urlSession() -> URLSession {
        if _urlSession == nil {
            _urlSession = URLSession(configuration: URLSessionConfiguration.default)
        }
        return _urlSession!
    }

    /**
     Setting Authorization HTTP Request Header
     */
    func setAuthorizationHeader() -> Void {
        // uncomment when using authorization header
        // Set the http header field for authorization
        //setValue("Token token=usertoken", forHTTPHeaderField: "Authorization")
    }

    // MARK: - Public Methods
    /**
     Perform request to fetch data

     - parameter request:           request
     - parameter userInfo:          userinfo
     - parameter completionHandler: handler
     */
    func performRequest(_ request: URLRequest, userInfo: NSDictionary? = nil, completionHandler: @escaping(_ response: Response) -> Void) -> () {
        guard isNetworkReachable() else {
            let resError: NSError = errorForNoNetwork()
            let res = Response(error: resError)
            completionHandler(res)
            return // do not proceed if user is not connected to internet
        }

        var mutableRequest: URLRequest  = request

        //   Set required headers
        if RBUserManager.sharedManager().isUserLoggedIn(), let accessToken: String = RBUserManager.sharedManager().activeUser.accessToken {
            mutableRequest.addValue(accessToken, forHTTPHeaderField: "token")
        }

        self.performSessionDataTaskWithRequest(mutableRequest, completionHandler: completionHandler)
    }

    /**
     Perform session data task

     - parameter request:           url request
     - parameter userInfo:          user information
     - parameter completionHandler: completion handler
     */
    fileprivate func performSessionDataTaskWithRequest(_ request: URLRequest, userInfo: NSDictionary? = nil, completionHandler: @escaping(_ response: Response) -> Void) -> () {

        RequestManager.beginNetworkActivity()
        self.addRequestedURL(request.url!)
        let session: URLSession = self.urlSession()

        session.dataTask(with: request, completionHandler: { (data, response, error) in
            RequestManager.endNetworkActivity()
            var responseError: Error? = error
            // handle http response status
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode > 299 {
                responseError = self.errorForStatus(httpResponse.statusCode)
            }
            var apiResponse: Response?
            if let _ = responseError {
                apiResponse = Response(error: responseError)
                self.logError(apiResponse!.responseError!, request: request)

                // Handle if access token is invalid
                if let nsError: NSError = responseError as? NSError, nsError.code == 401, let errorString: String = apiResponse?.responseError?.localizedDescription {
                    DispatchQueue.main.async {
                        RBUserManager.sharedManager().userLogout()
                        RBAlert.showWarningAlert(message: errorString, completion: nil)
                    }
                }

            } else {
                apiResponse = Response(data: data)
                self.logResponse(data!, forRequest: request)
            }
            self.removeRequestedURL(request.url!)
            DispatchQueue.main.async(execute: { () -> Void in
                completionHandler(apiResponse!)
            })
        }).resume()
    }

    /**
     Perform http action for a method

     - parameter method:            HTTP method
     - parameter urlString:         url string
     - parameter params:            parameters
     - parameter completionHandler: completion handler
     */
    func performHTTPActionWithMethod(_ method: HTTPRequestMethod, urlString: String, params: [String: AnyObject]? = nil, completionHandler: @escaping(_ response: Response) -> Void) {
        if method == .GET {
            var components = URLComponents(string: urlString)
            components?.queryItems = params?.queryItems() as [URLQueryItem]?

            if let url = components?.url {
                var request = URLRequest(url: url)
                request.httpMethod = HTTPRequestMethod.GET.rawValue
                self.performRequest(request, completionHandler: completionHandler)
            } else { // do not proceed if the url is nil
                let resError: Error = errorForInvalidURL()
                let res = Response(error: resError)
                completionHandler(res)
            }
        } else {
            let request = URLRequest.requestWithURL(URL(string: urlString)!, method: method, jsonDictionary: params as NSDictionary?)
            self.performRequest(request, completionHandler: completionHandler)
        }
    }

    fileprivate func logError(_ error: Error, request: URLRequest) {
        #if DEBUG
            print("URL: \(request.url?.absoluteString) Error: \(error.localizedDescription)")
        #endif
    }

    fileprivate func logResponse(_ data: Data, forRequest request: URLRequest) {
        #if DEBUG
            print("Data Size: \(data.count) bytes")
            let output: NSString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
            print("URL: \(request.url?.absoluteString) Output: \(output)")
        #endif
    }
}

// MARK: Request handling methods
extension RequestManager {

    /**
     Add a Url to request Manager.

     - parameter url: URL
     */
    fileprivate func addRequestedURL(_ url: URL) {
        objc_sync_enter(self)
        let requests: NSMutableSet = (self.runningURLRequests().mutableCopy()) as! NSMutableSet
        if let urlString: URL = url {
            requests.add(urlString)
            _runningURLRequests = requests
        }
        objc_sync_exit(self)
    }

    /**
     Remove url from Manager.

     - parameter url: URL
     */
    fileprivate func removeRequestedURL(_ url: URL) {
        objc_sync_enter(self)
        let requests: NSMutableSet = (self.runningURLRequests().mutableCopy()) as! NSMutableSet
        if requests.contains(url) == true {
            requests.remove(url)
            _runningURLRequests = requests
        }
        objc_sync_exit(self)
    }

    /**
     get currently running requests

     - returns: return set of running requests
     */
    fileprivate func runningURLRequests() -> NSSet {
        if _runningURLRequests == nil {
            _runningURLRequests = NSSet()
        }
        return _runningURLRequests!
    }

    /**
     Check wheather requesting fro URL.

     - parameter URl: url to check.

     - returns: true if current request.
     */
    fileprivate func isProcessingURL(_ url: URL) -> Bool {
        return self.runningURLRequests().contains(url)
    }

    /**
     Cancel session for a URL.

     - parameter url: URL
     */
    func cancelRequestForURL(_ url: URL) {
        self.urlSession().getTasksWithCompletionHandler({ (dataTasks: [URLSessionDataTask], uploadTasks: [URLSessionUploadTask], downloadTasks: [URLSessionDownloadTask]) -> Void in

            let capacity: NSInteger = dataTasks.count + uploadTasks.count + downloadTasks.count
            let tasks: NSMutableArray = NSMutableArray(capacity: capacity)
            tasks.addObjects(from: dataTasks)
            tasks.addObjects(from: uploadTasks)
            tasks.addObjects(from: downloadTasks)
            let predicate: NSPredicate = NSPredicate(format: "originalRequest.URL = %@", url as CVarArg)
            tasks.filter(using: predicate)

            for task in tasks {
                (task as! URLSessionTask).cancel()
            }
        })
    }

    /**
     Cancel All Running Requests
     */
    func cancelAllRequests() {
        self.urlSession().invalidateAndCancel()
        _urlSession = nil
        _runningURLRequests = nil
    }
}

// MARK: Error handling methods
extension RequestManager {

    /**
     Get Error instances if Nil URL.

     - returns: Error instance.
     */
    fileprivate func errorForInvalidURL() -> NSError {
        let errorDictionary = [NSLocalizedFailureReasonErrorKey: NSLocalizedString("URL Invalid", comment: "URL Invalid"), NSLocalizedDescriptionKey: NSLocalizedString("URL must not be nil", comment: "URL must not be nil")]
        return NSError(domain: NSURLErrorDomain, code: -1, userInfo: errorDictionary)
    }

    /**
     Get Error instances for NoNetwork.

     - returns: Error instance.
     */
    fileprivate func errorForNoNetwork() -> NSError {
        let errorDictionary = [NSLocalizedFailureReasonErrorKey: NSLocalizedString("Network unavailable", comment: "Network unavailable"), NSLocalizedDescriptionKey: NSLocalizedString("Network not available", comment: "Network not available")]
        return NSError(domain: NSURLErrorDomain, code: HTTPRequestErrorCode.httpConnectionError.rawValue, userInfo: errorDictionary)
    }

    /**
     Get Error instances for connectionError.

     - returns: connectionError instance.
     */
    fileprivate func connectionError() -> NSError {
        let errorDictionary = [NSLocalizedFailureReasonErrorKey: NSLocalizedString("Connection Error", comment: "Connection Error"), NSLocalizedDescriptionKey: NSLocalizedString("Network error occurred while performing this task. Please try again later.", comment: "Network error occurred while performing this task. Please try again later.")]
        return NSError(domain: kHTTPRequestDomain, code: HTTPRequestErrorCode.httpConnectionError.rawValue, userInfo: errorDictionary)
    }

    /**
     Create an error for response you probably don't want (400-500 HTTP responses for example).

     - parameter code: Code for error.

     - returns: An NSError.
     */
    fileprivate func errorForStatus(_ code: Int) -> NSError {
        let text = NSLocalizedString(HTTPStatusCode(statusCode: code).statusDescription, comment: "")
        let errorDictionary = [NSLocalizedFailureReasonErrorKey: NSLocalizedString("Error", comment: "Error"), NSLocalizedDescriptionKey: text]
        return NSError(domain: "HTTP", code: code, userInfo: errorDictionary)
    }
}

// MARK: Network reachable methods
extension RequestManager {

    /**
     Check wheather network is reachable.

     - returns: true is reachable otherwise false.
     */
    fileprivate func isNetworkReachable() -> Bool {
        let reach: Reachability = Reachability.forInternetConnection()
        return reach.currentReachabilityStatus() != .NotReachable
    }

    /**
     Check wheather WiFi is reachable.

     - returns: true is reachable otherwise false.
     */
    fileprivate func isReachableViaWiFi() -> Bool {
        let reach: Reachability = Reachability.forInternetConnection()
        return reach.currentReachabilityStatus() != .ReachableViaWiFi
    }
}
