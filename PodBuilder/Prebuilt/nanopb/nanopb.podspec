Pod::Spec.new do |p1|
    p1.name             = 'nanopb'
    p1.version          = '2.30909.0'
    p1.summary          = 'Protocol buffers with small code size.'
    p1.homepage         = 'https://github.com/nanopb/nanopb'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/nanopb/nanopb.git'}
    p1.license          = { :type => 'zlib' }

    p1.ios.deployment_target = '15.0'

    p1.default_subspecs = 'decode', 'encode'

    p1.subspec 'decode' do |p2|
        p2.vendored_frameworks = 'nanopb.xcframework'
    end

    p1.subspec 'encode' do |p2|
        p2.vendored_frameworks = 'nanopb.xcframework'
    end
end