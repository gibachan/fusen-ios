Pod::Spec.new do |p1|
    p1.name             = 'FirebaseStorageInternal'
    p1.version          = '9.4.0'
    p1.summary          = 'Firebase Storage'
    p1.homepage         = 'https://firebase.google.com'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/firebase/firebase-ios-sdk.git'}
    p1.license          = { :type => 'Apache-2.0' }

    p1.ios.deployment_target = '15.0'

    p1.vendored_frameworks = 'FirebaseStorageInternal.xcframework'
    p1.dependency 'FirebaseCore'
    p1.dependency 'GTMSessionFetcher/Core'
end