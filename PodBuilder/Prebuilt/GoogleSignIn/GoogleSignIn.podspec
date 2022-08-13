Pod::Spec.new do |p1|
    p1.name             = 'GoogleSignIn'
    p1.version          = '6.2.2'
    p1.summary          = 'Enables iOS apps to sign in with Google.'
    p1.homepage         = 'https://developers.google.com/identity/sign-in/ios/'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/google/GoogleSignIn-iOS.git'}
    p1.license          = { :type => 'Apache' }

    p1.ios.deployment_target = '15.0'

    p1.vendored_frameworks = 'GoogleSignIn.xcframework'
    p1.frameworks = 'CoreGraphics', 'CoreText', 'Foundation', 'LocalAuthentication', 'Security', 'UIKit'

    p1.dependency 'AppAuth'
    p1.dependency 'GTMAppAuth'
    p1.dependency 'GTMSessionFetcher/Core'
end