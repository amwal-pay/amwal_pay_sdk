Pod::Spec.new do |s|
  s.name             = 'amwalsdk'
  s.version          = '1.0.72'
  s.summary          = 'AMWAL SDK for iOS'
  s.description      = 'The AMWAL SDK provides features for payment integration in iOS applications.'
  s.homepage         = 'https://github.com/amwal-pay/AnwalPaySDKNativeiOSExample'
  s.license          = { :type => 'MIT' }
  s.author           = { 'Amwal Pay' => 'amr.elskaan@amwal-pay.com' }
  s.platform         = :ios, '12.0'
  s.swift_version    = '5.0'
  s.dependency 'Flutter', '3.27.300'

  # s.source           = {
  #   :path => '.'
  # }

  s.source           = {
    :http => "https://github.com/amwal-pay/AnwalPaySDKNativeiOSExample/releases/download/v#{s.version}/amwalsdk.zip"
  }
  s.source_files     = '*.{h,m,swift}'
  
  # Common configurations
  s.pod_target_xcconfig = {
    'SWIFT_OPTIMIZATION_LEVEL' => '-Onone',
    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES',
    'ENABLE_BITCODE' => 'NO',
    'VALID_ARCHS' => 'arm64 arm64e x86_64',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => '',
    'ONLY_ACTIVE_ARCH' => 'YES'
  }

  # Debug configuration
  s.subspec 'Debug' do |debug|
    debug.vendored_frameworks = 'Flutter/Debug/*.xcframework'
    debug.xcconfig = {
      'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}/amwalsdk/Flutter/Debug"',
      'OTHER_LDFLAGS' => '$(inherited) -framework Flutter -framework FlutterPluginRegistrant',
      'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES',
      'SWIFT_INCLUDE_PATHS' => '$(inherited) "${PODS_ROOT}/amwalsdk/Flutter/Debug"',
      'DEFINES_MODULE' => 'YES',
      'SWIFT_INSTALL_OBJC_HEADER' => 'NO',
      'VALID_ARCHS' => 'arm64 arm64e x86_64',
      'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => ''
    }
  end

  # Release configuration
  s.subspec 'Release' do |release|
    release.vendored_frameworks = 'Flutter/Release/*.xcframework'
    release.xcconfig = {
      'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}/amwalsdk/Flutter/Release"',
      'OTHER_LDFLAGS' => '$(inherited) -framework Flutter -framework FlutterPluginRegistrant',
      'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES',
      'SWIFT_INCLUDE_PATHS' => '$(inherited) "${PODS_ROOT}/amwalsdk/Flutter/Release"',
      'DEFINES_MODULE' => 'YES',
      'SWIFT_INSTALL_OBJC_HEADER' => 'NO',
      'VALID_ARCHS' => 'arm64 arm64e x86_64',
      'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => ''
    }
  end

  
  # Default to Debug configuration
  s.default_subspec = 'Debug'
end
