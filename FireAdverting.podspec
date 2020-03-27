#
# Be sure to run `pod lib lint GPFireable.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FireAdverting'
  s.version          = '0.1.26'
  s.summary          = 'A short description of GPFireable.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/conversun/FireAdverting.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Conver' => 'conversun@gmail.com' }
  s.source           = { :git => 'https://github.com/conversun/FireAdverting.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.1'
  s.static_framework = true
  s.default_subspec = 'Core'

  s.dependency 'mopub-ios-sdk'

  s.subspec 'Core' do |ss|
    ss.source_files = 'FireAdverting/Adverting/**/*'
  end

  s.subspec 'Native' do |ss|
    ss.source_files = 'FireAdverting/Native/**/*'
    ss.resource_bundles = {
      'FireAdverting' => ['FireAdverting/Assets/*']
    }

    ss.dependency 'FireAdverting/Core'
  end
end
