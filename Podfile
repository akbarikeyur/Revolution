# Uncomment this line to define a global platform for your project
platform :ios, '10.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'RevolutionBuy' do

# Network Check
pod 'Reachability', '~> 3.2'

#
# Social Integration
#
# Facebook
pod 'FBSDKCoreKit', '4.10'
pod 'FBSDKLoginKit', '4.10'

#
# Analytics
#
pod 'Mixpanel'
pod 'Fabric'
pod 'Crashlytics'
#
# Utils
#
pod 'MBProgressHUD', '~> 0.9.2'
pod 'IQKeyboardManagerSwift', '~> 4.0.13'
pod 'SDWebImage',' 3.8.2'
pod 'XCGLogger', '~> 4.0.0'
pod 'ObjectMapper', '~> 3.3'
pod 'ICSPullToRefresh', '~> 0.6'
pod 'Stripe'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

end
