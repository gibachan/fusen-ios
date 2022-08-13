Pod::Spec.new do |p1|
    p1.name             = 'FirebaseFirestore'
    p1.version          = '9.4.0'
    p1.summary          = 'Google Cloud Firestore'
    p1.homepage         = 'https://developers.google.com/'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/firebase/firebase-ios-sdk.git'}
    p1.license          = { :type => 'Apache-2.0' }

    p1.ios.deployment_target = '15.0'

    p1.vendored_frameworks = 'FirebaseFirestore.xcframework'
    p1.frameworks = 'SystemConfiguration', 'UIKit'
    p1.libraries = 'c++'

    p1.dependency 'FirebaseCore'
    p1.dependency 'abseil/algorithm'
    p1.dependency 'abseil/base'
    p1.dependency 'abseil/container/flat_hash_map'
    p1.dependency 'abseil/memory'
    p1.dependency 'abseil/meta'
    p1.dependency 'abseil/strings/strings'
    p1.dependency 'abseil/time'
    p1.dependency 'abseil/types'
    p1.dependency 'gRPC-C++'
    p1.dependency 'leveldb-library'
    p1.dependency 'nanopb'
end