Pod::Spec.new do |s|
  s.name             = 'CLSDK'
  s.version          = '1.0.0'
  s.license          = { :type => 'MIT' }
  s.homepage         = 'http://example.com'
  s.authors          = { 'Your Name' => 'email@example.com' }
  s.summary          = 'A awesome framework.'
  s.source           = { :git => 'https://github.com/corpsele/CLSDK.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '10.0'
  
  # 声明这是一个二进制的 Framework
  s.vendored_frameworks = 'CLSDK.framework'

  # 【关键】声明依赖。
  # 当 App pod 'MyFramework' 时，它会自动 pod 'Masonry'
  # s.dependency 'Masonry', '~> 1.1.0'
  s.dependency 'Alamofire'
end
