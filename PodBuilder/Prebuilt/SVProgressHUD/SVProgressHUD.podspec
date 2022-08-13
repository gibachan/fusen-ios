Pod::Spec.new do |p1|
    p1.name             = 'SVProgressHUD'
    p1.version          = '2.2.5'
    p1.summary          = 'A clean and lightweight progress HUD for your iOS and tvOS app.'
    p1.homepage         = 'https://github.com/SVProgressHUD/SVProgressHUD'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/SVProgressHUD/SVProgressHUD.git'}
    p1.license          = { :type => 'MIT' }

    p1.ios.deployment_target = '15.0'

    p1.vendored_frameworks = 'SVProgressHUD.xcframework'
    p1.frameworks = 'QuartzCore'
end