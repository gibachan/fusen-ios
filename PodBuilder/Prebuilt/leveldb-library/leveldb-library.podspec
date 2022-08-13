Pod::Spec.new do |p1|
    p1.name             = 'leveldb-library'
    p1.version          = '1.22.1'
    p1.summary          = 'A fast key-value storage library'
    p1.homepage         = 'https://github.com/google/leveldb'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/google/leveldb.git'}
    p1.license          = { :type => 'MIT' }

    p1.ios.deployment_target = '15.0'

    p1.vendored_frameworks = 'leveldb.xcframework'
    p1.libraries = 'c++'
end