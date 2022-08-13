Pod::Spec.new do |p1|
    p1.name             = 'AppAuth'
    p1.version          = '1.5.0'
    p1.summary          = 'AppAuth for iOS and macOS is a client SDK for communicating with OAuth 2.0 and OpenID Connect providers.'
    p1.homepage         = 'https://openid.github.io/AppAuth-iOS'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/openid/AppAuth-iOS.git'}
    p1.license          = { :type => 'MIT' }

    p1.ios.deployment_target = '15.0'

    p1.default_subspecs = 'Core', 'ExternalUserAgent'

    p1.subspec 'Core' do |p2|
        p2.vendored_frameworks = 'AppAuth.xcframework'
    end

    p1.subspec 'ExternalUserAgent' do |p2|
        p2.vendored_frameworks = 'AppAuth.xcframework'
        p2.frameworks = 'SafariServices'

        p2.dependency 'AppAuth/Core'
    end
end