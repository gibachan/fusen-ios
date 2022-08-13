Pod::Spec.new do |p1|
    p1.name             = 'GoogleToolboxForMac'
    p1.version          = '2.3.2'
    p1.summary          = 'Google utilities for iOS and OSX development.'
    p1.homepage         = 'https://github.com/google/google-toolbox-for-mac'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/google/google-toolbox-for-mac.git'}
    p1.license          = { :type => 'Apache' }

    p1.ios.deployment_target = '15.0'

    p1.subspec 'DebugUtils' do |p2|
        p2.vendored_frameworks = 'GoogleToolboxForMac.xcframework'
        p2.dependency 'GoogleToolboxForMac/Defines'
    end

    p1.subspec 'Defines' do |p2|
        p2.vendored_frameworks = 'GoogleToolboxForMac.xcframework'
    end

    p1.subspec 'Logger' do |p2|
        p2.vendored_frameworks = 'GoogleToolboxForMac.xcframework'
        p2.dependency 'GoogleToolboxForMac/Defines'
    end

    p1.subspec 'NSData+zlib' do |p2|
        p2.vendored_frameworks = 'GoogleToolboxForMac.xcframework'
        p2.libraries = 'z'

        p2.dependency 'GoogleToolboxForMac/Defines'
    end

    p1.subspec 'NSDictionary+URLArguments' do |p2|
        p2.vendored_frameworks = 'GoogleToolboxForMac.xcframework'
        p2.dependency 'GoogleToolboxForMac/DebugUtils'
        p2.dependency 'GoogleToolboxForMac/Defines'
        p2.dependency 'GoogleToolboxForMac/NSString+URLArguments'
    end

    p1.subspec 'NSString+URLArguments' do |p2|
        p2.vendored_frameworks = 'GoogleToolboxForMac.xcframework'
    end
end