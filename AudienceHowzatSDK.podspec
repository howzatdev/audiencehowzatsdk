
Pod::Spec.new do |s|
  s.name             = 'AudienceHowzatSDK'
  s.version          = '0.1.12'
  s.summary          = 'HowzatAudienceSDK by Howzat team'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "Howzat SDK is an iOS cocospod SDK.You can use this SDK to use Audience"

  s.homepage         = 'https://github.com/howzatdev/audiencehowzatsdk'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'howzatdev' => 'devaccounts@howzat.com' }
  s.source           = { :git => 'https://github.com/howzatdev/audiencehowzatsdk.git', :tag => s.version.to_s,:branch => 'master' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  s.source_files = 'AudienceHowzatSDK/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AudienceHowzatSDK' => ['AudienceHowzatSDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Starscream', '4.0.4'
end
