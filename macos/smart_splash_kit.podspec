Pod::Spec.new do |s|
  s.name             = 'smart_splash_kit'
  s.version          = '1.0.0'
  s.summary          = 'A powerful, customizable Flutter splash screen package.'
  s.description      = <<-DESC
Smart Splash Kit provides beautiful splash screens with smart routing, animations,
API loading support, light/dark theme detection, and seamless transitions.
  DESC

  s.homepage         = 'https://pub.dev/packages/smart_splash_kit'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Manoj Patadiya' => 'manoj.patadiya@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'smart_splash_kit/Sources/smart_splash_kit/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.14'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.9'
end
