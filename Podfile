# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'fusen' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for fusen
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  pod 'Firebase/Storage'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/Functions'
  pod 'Firebase/AppCheck'
  pod 'SVProgressHUD'
  pod 'SwiftLint'
  pod 'GoogleSignIn'
  pod 'GoogleMLKit/TextRecognitionJapanese'
  pod 'CropViewController'
  pod 'Kingfisher'
  pod 'LicensePlist'

  target 'fusenTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'fusenUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      config.build_settings["DEVELOPMENT_TEAM"] = "MYDHT92MBT"
      if `uname -m`.strip == 'arm64'
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      end
    end
  end
end