Pod::Spec.new do |p1|
    p1.name             = 'GTMSessionFetcher'
    p1.version          = '1.7.2'
    p1.summary          = 'Google Toolbox for Mac - Session Fetcher'
    p1.homepage         = 'https://github.com/google/gtm-session-fetcher'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/google/gtm-session-fetcher.git'}
    p1.license          = { :type => 'Apache' }

    p1.ios.deployment_target = '15.0'

    p1.subspec 'Core' do |p2|
        p2.vendored_frameworks = 'GTMSessionFetcher.xcframework'
        p2.frameworks = 'Security'
    end
end