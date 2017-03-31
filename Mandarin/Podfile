# Pods for Bezpaketov# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'BezPaketov' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  source 'https://github.com/CocoaPods/Specs.git'
  platform :ios, '10.0'
  use_frameworks!

  pod 'RealmSwift'
  pod 'Alamofire', '~> 4.0.0'
  pod 'SnapKit'
  pod 'SwiftyJSON'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'Google/SignIn'
  pod 'VK-ios-sdk'
  pod 'SDWebImage'
  pod 'AlamofireNetworkActivityIndicator'

  post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end

end
