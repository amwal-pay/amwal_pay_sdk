Pod::Spec.new do |s|
  s.name             = 'amwalsdk'
  s.version          = '1.0.31'
  s.summary          = 'AMWAL SDK for iOS'
  s.description      = 'The AMWAL SDK provides features for payment integration in iOS applications.'
  s.homepage         = 'https://github.com/amwal-pay/AnwalPaySDKNativeiOSExample'
  s.license          = { :type => 'MIT' }
  s.author           = { 'Amwal Pay' => 'amr.elskaan@amwal-pay.com' }
  s.platform         = :ios, '12.0'
  s.swift_version    = '5.0'

  s.source           = { :path => "." }
  s.vendored_frameworks = 'amwalsdk.framework'
  s.preserve_paths = 'amwalsdk.framework/Frameworks/*.framework'

  s.xcconfig = {
    'ENABLE_BITCODE' => 'NO',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/amwalsdk/amwalsdk.framework/Frameworks',
    'OTHER_LDFLAGS' => '$(inherited) -framework Flutter -framework FlutterPluginRegistrant'
  }
end
