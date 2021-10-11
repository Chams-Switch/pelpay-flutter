#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint pelpay_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'pelpay_flutter'
  s.version          = '1.0.0'
  s.summary          = 'The flutter plugin for Pelpay payment SDK.'
  s.description      = <<-DESC
  The flutter plugin for Pelpay payment SDK.
                       DESC
  s.homepage         = 'https://pelpay.africa'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'David Ehigiator' => 'david3ti@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Pelpay', '~> 1.0.2'
  s.platform = :ios, '9.0'
  s.ios.deployment_target = '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
