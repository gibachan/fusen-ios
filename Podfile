# Uncomment the next line to define a global platform for your project
platform :ios, '17.0'

target 'fusen' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
      config.build_settings["DEVELOPMENT_TEAM"] = "MYDHT92MBT"
    end
  end
end