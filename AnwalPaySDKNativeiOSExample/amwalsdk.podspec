Pod::Spec.new do |s|
  s.name             = 'amwalsdk'
  s.version          = '1.0.61'
  s.summary          = 'AMWAL SDK for iOS'
  s.description      = 'The AMWAL SDK provides features for payment integration in iOS applications.'
  s.homepage         = 'https://github.com/amwal-pay/AnwalPaySDKNativeiOSExample'
  s.license          = { :type => 'MIT' }
  s.author           = { 'Amwal Pay' => 'amr.elskaan@amwal-pay.com' }
  s.platform         = :ios, '12.0'
  s.swift_version    = '5.0'
  s.pod_target_xcconfig = { 'SWIFT_OPTIMIZATION_LEVEL' => '-Onone' }

  s.source           = {
    :http => "https://github.com/amwal-pay/AnwalPaySDKNativeiOSExample/releases/download/v#{s.version}/amwalsdk-#{s.version}.zip",
    :type => 'zip'
  }
  s.source_files     = 'amwalsdk/*.{h,m,swift}'
  s.resource_bundles = {
    'amwalsdk' => ['amwalsdk/**/*.{storyboard,xib,xcassets,json,png,jpg,strings,ttf,otf}']
  }

  s.vendored_frameworks = [
    'amwalsdk/Flutter/*.xcframework'
  ]

  s.xcconfig = {
    'ENABLE_BITCODE' => 'NO',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/amwalsdk/Flutter',
    'OTHER_LDFLAGS' => '$(inherited) -framework Flutter -framework FlutterPluginRegistrant'
  }

end
