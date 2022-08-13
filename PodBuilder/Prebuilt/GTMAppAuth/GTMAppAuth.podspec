Pod::Spec.new do |p1|
    p1.name             = 'GTMAppAuth'
    p1.version          = '1.3.0'
    p1.summary          = 'Authorize GTM Session Fetcher requests with AppAuth via GTMAppAuth'
    p1.homepage         = 'https://github.com/google/GTMAppAuth'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/google/GTMAppAuth.git'}
    p1.license          = { :type => 'Apache' }

    p1.ios.deployment_target = '15.0'

    p1.vendored_frameworks = 'GTMAppAuth.xcframework'
    p1.frameworks = 'Security'

    p1.dependency 'AppAuth/Core'
    p1.dependency 'GTMSessionFetcher/Core'
end