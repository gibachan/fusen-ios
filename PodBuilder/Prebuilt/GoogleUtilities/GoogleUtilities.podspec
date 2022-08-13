Pod::Spec.new do |p1|
    p1.name             = 'GoogleUtilities'
    p1.version          = '7.7.0'
    p1.summary          = 'Google Utilities for Apple platform SDKs'
    p1.homepage         = 'https://github.com/google/GoogleUtilities'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/google/GoogleUtilities.git'}
    p1.license          = { :type => 'Apache' }

    p1.ios.deployment_target = '15.0'

    p1.subspec 'AppDelegateSwizzler' do |p2|
        p2.vendored_frameworks = 'GoogleUtilities.xcframework'
        p2.dependency 'GoogleUtilities/Environment'
        p2.dependency 'GoogleUtilities/Logger'
        p2.dependency 'GoogleUtilities/Network'
    end

    p1.subspec 'Environment' do |p2|
        p2.vendored_frameworks = 'GoogleUtilities.xcframework'
        p2.frameworks = 'Security'

        p2.dependency 'PromisesObjC'
    end

    p1.subspec 'Logger' do |p2|
        p2.vendored_frameworks = 'GoogleUtilities.xcframework'
        p2.dependency 'GoogleUtilities/Environment'
    end

    p1.subspec 'MethodSwizzler' do |p2|
        p2.vendored_frameworks = 'GoogleUtilities.xcframework'
        p2.dependency 'GoogleUtilities/Logger'
    end

    p1.subspec 'NSData+zlib' do |p2|
        p2.vendored_frameworks = 'GoogleUtilities.xcframework'
        p2.libraries = 'z'
    end

    p1.subspec 'Network' do |p2|
        p2.vendored_frameworks = 'GoogleUtilities.xcframework'
        p2.frameworks = 'Security'

        p2.dependency 'GoogleUtilities/Logger'
        p2.dependency 'GoogleUtilities/NSData+zlib'
        p2.dependency 'GoogleUtilities/Reachability'
    end

    p1.subspec 'Reachability' do |p2|
        p2.vendored_frameworks = 'GoogleUtilities.xcframework'
        p2.frameworks = 'SystemConfiguration'

        p2.dependency 'GoogleUtilities/Logger'
    end

    p1.subspec 'UserDefaults' do |p2|
        p2.vendored_frameworks = 'GoogleUtilities.xcframework'
        p2.dependency 'GoogleUtilities/Logger'
    end
end