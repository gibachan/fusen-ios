Pod::Spec.new do |p1|
    p1.name             = 'CropViewController'
    p1.version          = '2.6.1'
    p1.summary          = 'A Swift view controller that enables cropping and rotating of UIImage objects.'
    p1.homepage         = 'https://github.com/TimOliver/TOCropViewController'
    p1.author           = 'PodBuilder'
    p1.source           = { 'git' => 'https://github.com/TimOliver/TOCropViewController.git'}
    p1.license          = { :type => 'MIT' }

    p1.ios.deployment_target = '15.0'

    p1.vendored_frameworks = 'CropViewController.xcframework'
end