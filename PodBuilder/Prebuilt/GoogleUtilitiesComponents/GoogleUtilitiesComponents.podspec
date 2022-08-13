Pod::Spec.new do |p1|
    p1.name             = 'GoogleUtilitiesComponents'
    p1.version          = '1.1.0'
    p1.summary          = 'Google Utilities Component Container for Apple platforms.'
    p1.homepage         = 'https://developers.google.com/'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/firebase/firebase-ios-sdk.git'}
    p1.license          = { :type => 'Apache' }

    p1.ios.deployment_target = '15.0'

    p1.vendored_frameworks = 'GoogleUtilitiesComponents.xcframework'
    p1.resources = 'GoogleUtilitiesComponents.xcframework/ios-arm64/GoogleUtilitiesComponents.framework/*.{nib,bundle,xcasset,strings,png,jpg,tif,tiff,otf,ttf,ttc,plist,json,caf,wav,p12,momd}'
    p1.exclude_files = 'GoogleUtilitiesComponents.xcframework/ios-arm64/GoogleUtilitiesComponents.framework/Info.plist'

    p1.dependency 'GoogleUtilities/Logger'
end