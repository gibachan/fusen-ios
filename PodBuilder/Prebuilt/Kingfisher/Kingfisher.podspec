Pod::Spec.new do |p1|
    p1.name             = 'Kingfisher'
    p1.version          = '7.3.2'
    p1.summary          = 'A lightweight and pure Swift implemented library for downloading and cacheing image from the web.'
    p1.homepage         = 'https://github.com/onevcat/Kingfisher'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/onevcat/Kingfisher.git'}
    p1.license          = { :type => 'MIT' }

    p1.ios.deployment_target = '15.0'

    p1.vendored_frameworks = 'Kingfisher.xcframework'
    p1.frameworks = 'Accelerate', 'CFNetwork'
end