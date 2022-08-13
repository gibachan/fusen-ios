Pod::Spec.new do |p1|
    p1.name             = 'FirebaseAuth'
    p1.version          = '9.4.0'
    p1.summary          = 'Apple platform client for Firebase Authentication'
    p1.homepage         = 'https://firebase.google.com'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/firebase/firebase-ios-sdk.git'}
    p1.license          = { :type => 'Apache-2.0' }

    p1.ios.deployment_target = '15.0'

    p1.vendored_frameworks = 'FirebaseAuth.xcframework'
    p1.frameworks = 'SafariServices', 'Security'

    p1.dependency 'FirebaseCore'
    p1.dependency 'GTMSessionFetcher/Core'
    p1.dependency 'GoogleUtilities/AppDelegateSwizzler'
    p1.dependency 'GoogleUtilities/Environment'
end