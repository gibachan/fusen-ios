Pod::Spec.new do |p1|
    p1.name             = 'PromisesObjC'
    p1.version          = '2.1.1'
    p1.summary          = 'Synchronization construct for Objective-C'
    p1.homepage         = 'https://github.com/google/promises'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/google/promises.git'}
    p1.license          = { :type => 'Apache' }

    p1.ios.deployment_target = '15.0'

    p1.vendored_frameworks = 'FBLPromises.xcframework'
end