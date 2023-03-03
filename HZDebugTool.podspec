Pod::Spec.new do |s|

  s.name = 'HZDebugTool'
  s.version = '1.0.1'
  s.summary = 'Development tool'
  s.homepage = 'https://github.com/Boxzhi/HZDebugTool'
  s.author = { 'HeZhizhi' => 'coderhzz@163.com' }
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.social_media_url = 'https://www.jianshu.com/u/9767e7dda727'
  s.source = { :git => "https://github.com/Boxzhi/HZDebugTool.git", :tag => s.version }

  s.ios.deployment_target = '11.0'
  s.framework = 'UIKit'
  s.swift_version = '5.0'

  s.subspec 'Core' do |core|
    core.dependency 'SnapKit'
    core.dependency 'HZDebugTool/SAMKeychain'
    core.source_files = 'Core/*.swift', 'Extensions/*.swift'
    core.resources = 'Core/*.{png,bundle}'
  end

  s.subspec 'SAMKeychain' do |keychain|
    keychain.source_files = 'SAMKeychain/*.{h,m,swift}'
    keychain.resources = 'SAMKeychain/*.{png,bundle}'
  end

end
