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
  s.source = { :git => '.', :tag => s.version  }


  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  # Only include your own Swift files, not headers from frameworks
  s.source_files = 'amwalsdk/**/*.swift'
  
  # Don't include public header files from frameworks
  # s.public_header_files = 'amwalsdk/**/*.h'
  
  # List all XCFrameworks explicitly
  s.vendored_frameworks = 'amwalsdk/Flutter/*.xcframework'

  # Preserve Flutter module
  s.preserve_paths = 'amwalsdk/Flutter/**/*'
  
  # These settings help avoid framework conflicts
  s.xcconfig = { 
    'OTHER_LDFLAGS' => '-framework Flutter',
    # Exclude headers from the frameworks to avoid conflicts
    'HEADER_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}/Headers/Public"',
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES'
  }

  # Ensure Flutter is available
  s.static_framework = true
end