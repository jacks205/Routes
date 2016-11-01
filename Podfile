# Uncomment this line to define a global platform for your project
platform :ios, '10.0'

target 'Routes' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Routes
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'CocoaLumberjack/Swift'
  pod 'GooglePlaces'
  pod 'GoogleMaps'
  pod 'JGProgressHUD'
  pod 'Firebase/AdMob'
  pod 'Moya-ObjectMapper/RxSwift', :git => 'https://github.com/ivanbruel/Moya-ObjectMapper'
  pod 'Moya', :git => 'https://github.com/Moya/Moya'
  pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift'
  pod 'RxCocoa', '3.0.0-beta.1'
  pod 'Kanna', '~> 2.0.0'
  pod 'RealmSwift'
  pod 'ObjectMapper+Realm', :git => 'https://github.com/Jakenberg/ObjectMapper-Realm.git', :branch => 'master'
  target 'RoutesTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
