Pod::Spec.new do |p1|
    p1.name             = 'FirebaseCrashlytics'
    p1.version          = '9.4.0'
    p1.summary          = 'Best and lightest-weight crash reporting for mobile, desktop and tvOS.'
    p1.homepage         = 'https://firebase.google.com/'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/firebase/firebase-ios-sdk.git'}
    p1.license          = { :type => 'Apache-2.0' }

    p1.ios.deployment_target = '15.0'

    p1.vendored_frameworks = 'FirebaseCrashlytics.xcframework'
    p1.frameworks = 'Security', 'SystemConfiguration'
    p1.libraries = 'c++', 'z'

    p1.dependency 'FirebaseCore'
    p1.dependency 'FirebaseInstallations'
    p1.dependency 'GoogleDataTransport'
    p1.dependency 'GoogleUtilities/Environment'
    p1.dependency 'PromisesObjC'
    p1.dependency 'nanopb'
end