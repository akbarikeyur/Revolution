//
//  LogManager.swift
//
//  Created by Arvind Singh on 02/06/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import XCGLogger

class LogManager: NSObject {

    let log: XCGLogger = {
        // Setup XCGLogger
        let log = XCGLogger.default
            //        log.xcodeColorsEnabled = true // Or set the XcodeColors environment variable in your scheme to YES
            //        log.xcodeColors = [
            //            .Verbose: .lightGrey,
            //            .Debug: .darkGrey,
            //            .Info: .darkGreen,
            //            .Warning: .orange,
            //            .Error: XCGLogger.XcodeColor(fg: UIColor.redColor(), bg: UIColor.whiteColor()), // Optionally use a UIColor
            //            .Severe: XCGLogger.XcodeColor(fg: (255, 255, 255), bg: (255, 0, 0)) // Optionally use RGB values directly,,,,,,,
            //        ]

            return log
    }()

    // MARK: - Singleton Instance
    fileprivate static let _sharedManager = LogManager()

    class func sharedManager() -> LogManager {
        return _sharedManager
    }

    fileprivate override init() {
        super.init()
    }

    // MARK: - Setup methods
    class func setup(_ logLevel: XCGLogger.Level = .debug, showLogLevel: Bool = true, showFunctionName: Bool = true, showThreadName: Bool = false, showFileName: Bool = true, showLineNumber: Bool = true, writeToFile: Bool = false) {

        LogManager.sharedManager().setup(logLevel, showLogLevel: showLogLevel, showFunctionName: showFunctionName, showThreadName: showThreadName, showFileName: showFileName, showLineNumber: showLineNumber, writeToFile: writeToFile)
    }

    func setup(_ logLevel: XCGLogger.Level = .debug, showLogLevel: Bool = true, showFunctionName: Bool = true, showThreadName: Bool = false, showFileName: Bool = true, showLineNumber: Bool = true, writeToFile: Bool = false) {

        #if USE_NSLOG // Set via Build Settings, under Other Swift Flags

            self.log.removeLogDestination(XCGLogger.Constants.baseConsoleLogDestinationIdentifier)
            self.log.addLogDestination(XCGNSLogDestination(owner: self.log, identifier: XCGLogger.Constants.nslogDestinationIdentifier))
            self.log.logAppDetails()

        #else

            var logPath: URL? = nil

            if writeToFile {
                // create a log file name using current date
                let fileName: String = "Log-\(Date().formattedString()).txt"
                logPath = cacheDirectoryURL.appendingPathComponent(fileName)
            }

            self.log.setup(level: logLevel, showFunctionName: showFunctionName, showThreadName: showThreadName, showLevel: showLogLevel, showFileNames: showFileName, showLineNumbers: showLineNumber, writeToFile: logPath)

        #endif
    }

    // MARK: - Write log
    fileprivate func writeLog(_ logLevel: XCGLogger.Level, closure: @autoclosure() -> String?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {

        self.log.logln(logLevel, functionName: functionName, fileName: fileName, lineNumber: lineNumber, closure: closure)

    }
}

// MARK: - Helpers for Logging
extension LogManager {

    class func logDebug(_ closure: @autoclosure() -> String?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(.debug, closure: closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    class func logInfo(_ closure: @autoclosure() -> String?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(.info, closure: closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    class func logWarning(_ closure: @autoclosure() -> String?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(.warning, closure: closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    class func logError(_ closure: @autoclosure() -> String?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(.error, closure: closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    class func logSevere(_ closure: @autoclosure() -> String?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(.severe, closure: closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    class func logEntry(_ functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(.debug, closure: "ENTRY", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    class func logExit(_ functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(.debug, closure: "EXIT", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
}
