#
# Be sure to run `pod lib lint DJSemiModalViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DJSemiModalViewController'
  s.version          = '0.1.1'
  s.summary          = 'Simple semi modal presentation dialog with stacked content.'

  s.description      = 'DJSemiModalViewController is a semi modal presentation dialog that grows with it´s added content. DJSemiModalViewController works for iPhone and iPad. The content is added to a UIStackView that is inside of an UIScrollView that adds scroll if needed. DJSemiModalViewController mimic the design of the standard NFC dialog on iPhone.'

  s.homepage         = 'https://github.com/davnag/DJSemiModalViewController'
  s.screenshots      = 'https://raw.githubusercontent.com/davnag/DJSemiModalViewController/master/screenshots_1.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'David Jonsén' => 'jonsen.dev@outlook.com' }
  s.source           = { :git => 'https://github.com/davnag/DJSemiModalViewController.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.swift_version = '4.0'

  s.source_files = 'DJSemiModalViewController/Classes/**/*'
  
  # s.resource_bundles = {
  #   'DJSemiModalViewController' => ['DJSemiModalViewController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit'
end
