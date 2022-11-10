Pod::Spec.new do |s|
  s.name = "GXTwitterKit"
  s.version = "3.5.2"
  s.summary = "Increase user engagement and app growth."
  s.homepage = "https://github.com/genexuslabs/twitter-kit-ios"
  s.documentation_url = "https://github.com/genexuslabs/twitter-kit-ios/wiki"
  s.social_media_url = "https://twitter.com/GeneXus"
  s.authors = "Twitter", "GeneXus"
  s.platform = :ios, "9.0"
  s.source = { :http => "https://github.com/genexuslabs/twitter-kit-ios/releases/download/v#{s.version}-TK/TwitterKit.zip" }
  s.vendored_frameworks = "TwitterKit.xcframework"
  s.license = { :type => "Commercial", :text => "Twitter Kit: Copyright Twitter, Inc. All Rights Reserved. Use of this software is subject to the terms and conditions of the Twitter Kit Agreement located at https://dev.twitter.com/overview/terms/twitterkit and the Developer Agreement located at https://dev.twitter.com/overview/terms/agreement. OSS: https://github.com/twitter/twitter-kit-ios/blob/master/OS_LICENSES.md"}
  s.resources = ["TwitterKit.xcframework/ios-arm64_armv7_armv7s/TwitterKit.framework/TwitterKitResources.bundle", "TwitterKit.xcframework/ios-arm64_armv7_armv7s/TwitterKit.framework/TwitterShareExtensionUIResources.bundle"]
  s.frameworks = "CoreText", "QuartzCore", "CoreData", "CoreGraphics", "Foundation", "Security", "UIKit", "CoreMedia", "AVFoundation", "SafariServices"
  s.dependency "GXTwitterCore", ">= 3.3.1"
end
