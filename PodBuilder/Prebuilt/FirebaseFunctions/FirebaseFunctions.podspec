Pod::Spec.new do |p1|
    p1.name             = 'FirebaseFunctions'
    p1.version          = '9.4.0'
    p1.summary          = 'Cloud Functions for Firebase'
    p1.homepage         = 'https://developers.google.com/'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/Firebase/firebase-ios-sdk.git'}
    p1.license          = { :type => 'Apache-2.0' }

    p1.ios.deployment_target = '15.0'

    p1.vendored_frameworks = 'FirebaseFunctions.xcframework'
    p1.dependency 'FirebaseAppCheckInterop'
    p1.dependency 'FirebaseAuthInterop'
    p1.dependency 'FirebaseCore'
    p1.dependency 'FirebaseCoreExtension'
    p1.dependency 'FirebaseMessagingInterop'
    p1.dependency 'FirebaseSharedSwift'
    p1.dependency 'GTMSessionFetcher/Core'
end