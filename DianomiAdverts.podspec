Pod::Spec.new do |spec|
  spec.name         = "DianomiAdverts"
  spec.version      = "1.0.0"
  spec.summary      = "A framework to integrate Dianomi Ads in your app."

  spec.description  = <<-DESC
  DiamomiAdverts is a framework to integrate Dianomi Ads in your app.
                   DESC
  spec.homepage     = "https://github.com/DianomiLtd/dianomi-ios-sdk"
  spec.license      = "MIT"
  spec.author       = { "Mirek Petricek" => "mirek.petricek@waracle.com" }
  spec.platform     = :ios
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "git@github.com:DianomiLtd/dianomi-ios-sdk.git", :tag => "#{spec.version}" }
  spec.source_files  = "DianomiAdverts/Sources/**/*.{h,m,swift}"
  spec.swift_version = '5.0'
end
