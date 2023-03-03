Pod::Spec.new do |s|

  s.name = 'HZDebugTool'
  s.version = '1.0.0'
  s.summary = 'Development tool'
  s.homepage = 'https://github.com/Boxzhi/HZNavigationBar'
  s.author = { 'HeZhizhi' => 'coderhzz@163.com' }
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.social_media_url = 'https://www.jianshu.com/u/9767e7dda727'
  s.source = { :git => "https://github.com/Boxzhi/HZDebugTool.git", :tag => s.version }

  s.ios.deployment_target = '10.0'
  s.source_files = 'HZDebugTool/*.swift'
  s.framework = 'UIKit'
  s.swift_version = '5.0'
  s.dependency 'SnapKit'
  s.source_files = 'Core/*.swift', 'Extensions/*.swift', 'SAMKeychain/*.{bundle,h,m}'
  s.resources = 'Core/*.{png,bundle}', 'SAMKeychain/*.{png,bundle}'

end
