Pod::Spec.new do |s|
  s.name             = 'RxPageViewController'
  s.version          = '0.1.1'
  s.summary          = 'RxSwift reactive wrapper for UIPageViewController'
  s.swift_version    = '5.0'

  s.description      = <<-DESC
      This API allows the 'UIPageViewController' to be used in an Rx environment.
      It also provides transition and indicator options when initializing the DataSource.
                       DESC

  s.homepage         = 'https://github.com/wonbi92/RxPageViewController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wonbi92' => 'bin9239@gmail.com' }
  s.source           = { :git => 'https://github.com/wonbi92/RxPageViewController.git', :tag => s.version.to_s }

  s.platform         = :ios, '13.0'

  s.source_files = 'RxPageViewController/Classes/**/*'

  s.framework = 'UIKit'
  s.dependency 'RxSwift', '~> 6.0'
  s.dependency 'RxCocoa', '~> 6.0'
end
