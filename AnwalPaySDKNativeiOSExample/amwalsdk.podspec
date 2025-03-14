Pod::Spec.new do |s|
  s.name             = 'amwalsdk'
  s.version          = '1.0.48'
  s.summary          = 'Payment SDK for Amwal integration'
  s.description      = <<-DESC
A comprehensive payment SDK that enables Flutter integration for Amwal payment solutions.
                       DESC
  s.homepage         = 'https://github.com/amwal-pay/AnwalPaySDKNativeiOSExample'
  
  # Change license to avoid file reference
  s.license          = { :type => 'MIT', :text => 'Copyright (c) 2024 Amwal Pay. All rights reserved.' }
  
  s.author           = { 'Amwal Pay' => 'amr.elskaan@amwal-pay.com' }
  
  s.source           = { 
    :path => '/Users/amrsaied/Documents/Flutter/Amwal/mobile/amwal_pay_sdk_amwal/AnwalPaySDKNativeiOSExample/amwalsdk/amwalsdk.xcframework'
  }


  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
  
  # Make sure the path to the framework is correct after extraction
  s.vendored_frameworks = 'amwalsdk.xcframework'
  
  # Preserve paths for all content within the framework
  s.preserve_paths = 'amwalsdk.xcframework/**/*'
  
  # Add frameworks that the SDK depends on
  s.frameworks = 'UIKit', 'Foundation'
  
  # This is important for handling the static framework properly
  s.static_framework = true
  
  # Ensure embedded frameworks are included
  s.xcconfig = { 
    'LD_RUNPATH_SEARCH_PATHS' => '@executable_path/Frameworks @loader_path/Frameworks' 
  }
  
  # Specify resource bundles to include
  s.resource_bundles = { 
    'amwalsdk' => ['amwalsdk.xcframework/**/*.{swift,h,modulemap}']
  }
  
  # Explicitly exclude any architecture issues
  s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
    'VALID_ARCHS' => 'arm64 x86_64',
    'ENABLE_BITCODE' => 'NO',
    'OTHER_LDFLAGS' => '-ObjC -all_load',
    'HEADER_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}/AmwalSDK.xcframework/Headers"',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}/AmwalSDK.xcframework/Frameworks"',
    'DEFINES_MODULE' => 'YES',
    'CLANG_ENABLE_MODULES' => 'YES'
  }
  
  s.user_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
    'VALID_ARCHS' => 'arm64 x86_64',
    'ENABLE_BITCODE' => 'NO',
    'OTHER_LDFLAGS' => '-ObjC -all_load'
  }
end