Pod::Spec.new do |p1|
    p1.name             = 'Protobuf'
    p1.version          = '3.21.5'
    p1.summary          = 'Protocol Buffers v.3 runtime library for Objective-C.'
    p1.homepage         = 'https://github.com/protocolbuffers/protobuf'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/protocolbuffers/protobuf.git'}
    p1.license          = { :type => 'MIT' }

    p1.ios.deployment_target = '15.0'

    p1.vendored_frameworks = 'Protobuf.xcframework'
end