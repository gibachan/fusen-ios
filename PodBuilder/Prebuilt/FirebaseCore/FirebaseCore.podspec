Pod::Spec.new do |p1|
    p1.name             = 'FirebaseCore'
    p1.version          = '9.4.0'
    p1.summary          = 'Firebase Core'
    p1.homepage         = 'https://firebase.google.com'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/firebase/firebase-ios-sdk.git'}
    p1.license          = { :type => 'Apache-2.0' }

    p1.ios.deployment_target = '15.0'

    p1.vendored_frameworks = 'FirebaseCore.xcframework'
    p1.frameworks = 'Foundation', 'UIKit'

    p1.dependency 'FirebaseCoreDiagnostics'
    p1.dependency 'FirebaseCoreInternal'
    p1.dependency 'GoogleUtilities/Environment'
    p1.dependency 'GoogleUtilities/Logger'
end