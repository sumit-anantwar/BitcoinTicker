# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

# Ignore all warnings from all pods
inhibit_all_warnings!

def core
  pod 'RxSwift', '4.5.0'
  pod 'RxCocoa', '4.5.0'
  pod 'RxOptional', '3.6.2'
  pod 'Moya/RxSwift', '13.0.1'
  
  # Swinject
  pod 'Swinject', '2.6.0'
  pod 'SwinjectStoryboard', '2.2.0'
  
  # Lottie
  pod 'lottie-ios', '3.0.6'
  
  # SwiftWebSocket
  pod 'SwiftWebSocket', :git => 'https://github.com/tidwall/SwiftWebSocket', :branch => 'master'
  
  # Fabric Crashlytics
  pod 'Fabric'
  pod 'Crashlytics'
end

def testing

  pod 'RxBlocking', '4.5.0'
  pod 'RxTest', '4.5.0'

end


target 'BitcoinTicker' do
  
  core

  target 'BitcoinTickerTests' do
    inherit! :search_paths
    
    testing
  end

  target 'BitcoinTickerUITests' do
    inherit! :search_paths
    
    testing
  end

end
