
Pod::Spec.new do |s|
  s.name             = 'SmoothPicker'
  s.version          = '1.0.9'
  s.summary          = 'An simple component to Present A horizontal Picker with custom selections'

  s.description      =  'A Customized Component for creating a horizontal picker with custom styles '  
                      

  s.homepage         = 'https://github.com/AvaVaas'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AVAVaas' => 'ahmed.nasser2310@gmail.com' }
  s.source           = { :git => 'https://github.com/AvaVaas/SmoothPicker.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'

  s.source_files = 'SmoothPicker/Classes/**/*.{swift}'
  s.frameworks = 'UIKit'
  s.dependency 'SnapKit'
  s.swift_version = '4.2'

end
