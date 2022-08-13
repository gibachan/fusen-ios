Pod::Spec.new do |p1|
    p1.name             = 'FirebaseCoreDiagnostics'
    p1.version          = '9.4.0'
    p1.summary          = 'Firebase Core Diagnostics'
    p1.homepage         = 'https://firebase.google.com'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/firebase/firebase-ios-sdk.git'}
    p1.license          = { :type => 'Apache-2.0' }

    p1.ios.deployment_target = '15.0'

    p1.vendored_frameworks = 'FirebaseCoreDiagnostics.xcframework'
    p1.frameworks = 'Foundation'

    p1.dependency 'GoogleDataTransport'
    p1.dependency 'GoogleUtilities/Environment'
    p1.dependency 'GoogleUtilities/Logger'
    p1.dependency 'nanopb'
end