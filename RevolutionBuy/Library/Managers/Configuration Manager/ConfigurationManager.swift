//
//  ConfigurationManager.swift
//
//  Created by Arvind Singh on 07/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

final class ConfigurationManager: NSObject {

    /*
     Open your Project Build Settings and search for “Swift Compiler – Custom Flags” … “Other Swift Flags”.
     Add “-DDEVELOPMENT” to the Debug section
     Add “-DQA” to the QA section
     Add “-DSTAGING” to the Staging section
     Add “-DPRODUCTION” to the Release section
     */
    fileprivate enum AppEnvironment: String {
        case Development = "Development"
        case QA = "QA"
        case Staging = "Staging"
        case Production = "Production"
    }

    fileprivate struct AppConfiguration {
        var apiEndPoint: String
        var loggingEnabled: Bool

        var analyticsKey: String
        var trackingEnabled: Bool

        var facebookId: String

        var stripeClientId: String
        var stripePublishKey: String

        var environment: AppEnvironment
    }

    fileprivate var activeConfiguration: AppConfiguration!

    // MARK: - Singleton Instance
    private static let _sharedManager = ConfigurationManager()

    class func sharedManager() -> ConfigurationManager {
        return _sharedManager
    }

    private override init() {
        super.init()

        // Load application selected environment and its configuration
        if let environment = self.currentEnvironment() {

            self.activeConfiguration = self.configuration(environment: environment)

            if self.activeConfiguration == nil {
                assertionFailure(NSLocalizedString("Unable to load application configuration", comment: "Unable to load application configuration"))
            }
        } else {
            assertionFailure(NSLocalizedString("Unable to load application flags", comment: "Unable to load application flags"))
        }
    }

    private func currentEnvironment() -> AppEnvironment? {

        #if QA
            return AppEnvironment.QA
        #elseif STAGING
            return AppEnvironment.Staging
        #elseif PRODUCTION
            return AppEnvironment.Production
        #else // Default configuration DEVELOPMENT
               return AppEnvironment.Production
            //Manisha
         //     return AppEnvironment.Production       return AppEnvironment.Development
        #endif

        /*let environment = Bundle.main.infoDictionary?["ActiveConfiguration"] as? String
         return environment*/
    }

    /**
     Returns application active configuration

     - parameter environment: An application selected environment

     - returns: An application configuration structure based on selected environment
     */
    private func configuration(environment: AppEnvironment) -> AppConfiguration {

        switch environment {
        case .Development:
            return debugConfiguration()
        case .QA:
            return qaConfiguration()
        case .Staging:
            return stagingConfiguration()
        case .Production:
            return productionConfiguration()
        }
    }

    private func debugConfiguration() -> AppConfiguration {
        return AppConfiguration(apiEndPoint: "https://dev.revolutionbuy.com/api",
            loggingEnabled: true,
            analyticsKey: "8be5fea359c05a936cdac053418f4974",
            trackingEnabled: true,
            facebookId: "1051478504985433",
            stripeClientId: "ca_AaUzkY7uzAa8MAx093csNSeceA0q75XL",
            stripePublishKey: "pk_test_zWO1HIyUYzoxq1sxsvwaevuc",
            environment: .Development)
//        return AppConfiguration(apiEndPoint: "http://revolutionbuy.com/dev/public/api",
//                                loggingEnabled: true,
//                                analyticsKey: "8be5fea359c05a936cdac053418f4974",
//                                trackingEnabled: true,
//                                facebookId: "1051478504985433",
//                                stripeClientId: "ca_AaUzkY7uzAa8MAx093csNSeceA0q75XL",
//                                stripePublishKey: "pk_test_zWO1HIyUYzoxq1sxsvwaevuc",
//                                environment: .Development)


//        return AppConfiguration(apiEndPoint: "http://13.210.0.232/api",
//                                loggingEnabled: true,
//                                analyticsKey: "8be5fea359c05a936cdac053418f4974",
//                                trackingEnabled: true,
//                                facebookId: "1051478504985433",
//                                stripeClientId: "ca_AaUzkY7uzAa8MAx093csNSeceA0q75XL",
//                                stripePublishKey: "pk_test_zWO1HIyUYzoxq1sxsvwaevuc",
//                                environment: .Development)

    }

    private func qaConfiguration() -> AppConfiguration {
        return AppConfiguration(apiEndPoint: "https://qa.revolutionbuy.com/api",
            loggingEnabled: true,
            analyticsKey: "b66a224b1475c80b64591a358316adcc",
            trackingEnabled: true,
            facebookId: "1051478504985433",
            stripeClientId: "ca_AaUzkY7uzAa8MAx093csNSeceA0q75XL",
            stripePublishKey: "pk_test_zWO1HIyUYzoxq1sxsvwaevuc",
            environment: .QA)
    }

    private func stagingConfiguration() -> AppConfiguration {
        return AppConfiguration(apiEndPoint: "https://staging.revolutionbuy.com/api",
            loggingEnabled: true,
            analyticsKey: "1ba1c374621aa98d268cb08a8285312d",
            trackingEnabled: true,
            facebookId: "1051478504985433",
            stripeClientId: "ca_AaUzkY7uzAa8MAx093csNSeceA0q75XL",
            stripePublishKey: "pk_test_zWO1HIyUYzoxq1sxsvwaevuc",
            environment: .Staging)
    }

    private func productionConfiguration() -> AppConfiguration {
        return AppConfiguration(apiEndPoint: "https://api.revolutionbuy.com/api",
                                loggingEnabled: false,
                                analyticsKey: "6916d23001e163176d4f0840dc0a9269",
                                trackingEnabled: true,
                                facebookId: "1051478504985433",
                                stripeClientId: "ca_AaUzsU5H7KV373Y2kG5JtWM098hdup8G",
                                stripePublishKey: "pk_live_QVTY4xfW2X5lUCYwPKbsdYHY",
                                environment: .Production)
    }
}

extension ConfigurationManager {

    // MARK: - Public Methods

    func applicationEnvironment() -> String {
        return self.activeConfiguration.environment.rawValue
    }

    func applicationEndPoint() -> String {
        return self.activeConfiguration.apiEndPoint
    }

    func loggingEnabled() -> Bool {
        return self.activeConfiguration.loggingEnabled
    }

    func analyticsKey() -> String {
        return self.activeConfiguration.analyticsKey
    }

    func trackingEnabled() -> Bool {
        return self.activeConfiguration.trackingEnabled
    }

    func facebookAppId() -> String {
        return self.activeConfiguration.facebookId
    }

    func stripeClientId() -> String {
        return self.activeConfiguration.stripeClientId
    }

    func stripePublishableKey() -> String {
        return self.activeConfiguration.stripePublishKey
    }
}
