Pod::Spec.new do |s|
  s.name             = 'smart_splash_kit'
  s.version          = '1.0.0'
  s.summary          = 'A powerful, customizable Flutter splash screen package with smart routing, animations, API loading, and theme support.'
  s.description      = <<-DESC
Smart Splash Kit is a Flutter plugin that provides beautiful splash screens with
smart navigation routing, customizable animations, API loading support, light/dark
theme detection, and seamless native-to-Flutter transitions.
  DESC

  s.homepage         = 'https://pub.dev/packages/smart_splash_kit'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Manoj Patadiya' => 'manoj.patadiya@gmail.com' }
  s.source           = { :path => '.' }

  s.source_files     = 'smart_splash_kit/Sources/smart_splash_kit/**/*.{h,m,swift}'
  s.resource_bundles = {
    'smart_splash_kit' => ['Assets/**/*', 'Resources/**/*']
  }

  s.dependency 'Flutter'
  s.platform = :ios, '13.1'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }

  s.swift_version = '5.9'
end
