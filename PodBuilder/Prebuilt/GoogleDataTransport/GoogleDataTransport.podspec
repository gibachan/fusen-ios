Pod::Spec.new do |p1|
    p1.name             = 'GoogleDataTransport'
    p1.version          = '9.2.0'
    p1.summary          = 'Google iOS SDK data transport.'
    p1.homepage         = 'https://developers.google.com/'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/google/GoogleDataTransport.git'}
    p1.license          = { :type => 'Apache' }

    p1.ios.deployment_target = '15.0'

    p1.vendored_frameworks = 'GoogleDataTransport.xcframework'
    p1.frameworks = 'CoreTelephony', 'SystemConfiguration'
    p1.libraries = 'z'

    p1.dependency 'GoogleUtilities/Environment'
    p1.dependency 'PromisesObjC'
    p1.dependency 'nanopb'
end