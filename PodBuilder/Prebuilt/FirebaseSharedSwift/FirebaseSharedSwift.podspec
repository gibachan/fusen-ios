Pod::Spec.new do |p1|
    p1.name             = 'FirebaseSharedSwift'
    p1.version          = '9.4.0'
    p1.summary          = 'Shared Swift Extensions for Firebase'
    p1.homepage         = 'https://developers.google.com/'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/Firebase/firebase-ios-sdk.git'}
    p1.license          = { :type => 'Apache-2.0' }

    p1.ios.deployment_target = '15.0'

    p1.vendored_frameworks = 'FirebaseSharedSwift.xcframework'
end