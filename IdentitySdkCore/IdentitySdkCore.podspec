Pod::Spec.new do |spec|
  spec.name                  = "IdentitySdkCore"
  spec.version               = "4.0.0"
  spec.summary               = "ReachFive IdentitySdkCore"
  spec.description           = <<-DESC
      ReachFive Identity Sdk Core
  DESC
  spec.homepage              = "https://github.com/ReachFive/identity-ios-sdk"
  spec.license               = { :type => "MIT", :file => "LICENSE" }
  spec.author                = "ReachFive"
  spec.authors               = { "egor" => "egor@reach5.co" }
  spec.swift_versions        = ["5"]
  spec.source                = { :git => "https://github.com/ReachFive/identity-ios-sdk.git", :tag => "#{spec.version}" }
  spec.source_files          = "IdentitySdkCore/Classes/**/*.*"
  spec.platform              = :ios
  spec.ios.deployment_target = '12.2'

  spec.dependency 'Alamofire', '~> 4.8'
  spec.dependency 'AlamofireObjectMapper', '~> 5.2'
  spec.dependency 'AlamofireNetworkLogger'
end
