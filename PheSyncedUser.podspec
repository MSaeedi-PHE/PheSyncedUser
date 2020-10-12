
Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '10.0'
s.name = "PheSyncedUser"
s.summary = "PheSyncedUser creates a unique id for user and syncs it across all PHE apps."
s.requires_arc = true

s.version = "1.0.0"
s.license = { :type => "MIT" }
s.author = { "Mohamad Saeedi" => "mo.saeedi@phe.gov.uk" }
s.homepage = "https://github.com/MSaeedi-PHE/PheSyncedUser/"

s.source = { :git => "https://github.com/MSaeedi-PHE/PheSyncedUser.git",
             :tag => "#{s.version}" }

s.framework = "UIKit"
s.source_files = "PheSyncedUser/**/*.{swift}"
#s.resources = "PheSyncedUser/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
s.swift_version = "4.2"

end
