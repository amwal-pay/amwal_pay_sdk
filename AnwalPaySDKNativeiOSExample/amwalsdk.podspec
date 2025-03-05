Pod::Spec.new do |s|
  s.name             = 'amwalsdk'
  s.version          = '1.0.0'
  s.summary          = 'Payment SDK for Amwal integration'
  s.description      = <<-DESC
A comprehensive payment SDK that enables Flutter integration for Amwal payment solutions.
                       DESC
  s.homepage         = 'https://www.amwal-pay.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Your Name' => 'amr.elskaan@amwal-pay.com' }
  s.source           = { :git => 'https://github.com/yourusername/AmwalSDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  # Include all Swift files
  s.source_files = 'amwalsdk/**/*.{swift,h}'
  s.public_header_files = 'amwalsdk/**/*.h'
s.vendored_frameworks = 'amwalsdk/Flutter/*.xcframework'

  # Include resources if needed
  # s.resources = 'AmwalSDK/Resources/**/*'

  # Specify dependencies
  # s.dependency 'Flutter', '1.0.0'


  # Preserve Flutter module
  s.preserve_paths = 'amwalsdk/Flutter/**/*'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework Flutter' }

  # Ensure Flutter is available
  s.static_framework = true
end