Pod::Spec.new do |s|
  s.name             = 'amwalsdk'
  s.version          = '1.0.18'
  s.summary          = 'Payment SDK for Amwal integration'
  s.description      = <<-DESC
A comprehensive payment SDK that enables Flutter integration for Amwal payment solutions.
                       DESC
  s.homepage         = 'https://github.com/amwal-pay/AnwalPaySDKNativeiOSExample'
  
  # Change license to avoid file reference
  s.license          = { :type => 'MIT', :text => 'Copyright (c) 2024 Amwal Pay. All rights reserved.' }
  
  s.author           = { 'Amwal Pay' => 'amr.elskaan@amwal-pay.com' }
  
  s.source           = { 
    :http => 'https://github.com/amwal-pay/AnwalPaySDKNativeiOSExample/releases/download/1.0.1/AmwalSDK.xcframework.zip',
    :type => 'zip'
  }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
  
  # Make sure the path to the framework is correct after extraction
  s.vendored_frameworks = 'AmwalSDK.xcframework'
  
  # Add frameworks that the SDK depends on
  s.frameworks = 'UIKit', 'Foundation'
  
  # This is important for handling the static framework properly
  s.static_framework = true
  
  # Explicitly exclude any architecture issues
  s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
    'VALID_ARCHS' => 'arm64 x86_64',
    'ENABLE_BITCODE' => 'NO'
  }
  
  s.user_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
    'VALID_ARCHS' => 'arm64 x86_64',
    'ENABLE_BITCODE' => 'NO'
  }
end