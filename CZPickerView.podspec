#
# Be sure to run `pod lib lint CZPickerView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CZPickerView'
  s.version          = '1.1.1'
  s.summary          = 'Swift/modified version of CZPickerView'

  s.description      = <<-DESC
Swift/modified version of CZPickerView.
                       DESC

  s.homepage         = 'https://github.com/kientux/pickerview'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kientux' => 'ntkien93@gmail.com' }
  s.source           = { :git => 'https://github.com/kientux/pickerview.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_versions = '5.5'

  s.source_files = 'Sources/CZPickerView/**/*.swift'
  s.resource_bundles = {
    'CZPickerView' => ['Sources/CZPickerView/Resources/**/*.{xib,storyboard,xcassets,png}']
  }
end
