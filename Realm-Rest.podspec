#
# Be sure to run `pod lib lint Realm-Rest.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Realm-Rest"
  s.version          = "0.1.0"
  s.summary          = "An extension to Realm.io for working with JSON based Rest API's"
  s.homepage         = "https://github.com/laptobbe/Realm-Rest"
  s.license          = 'MIT'
  s.author           = { "Tobias Sundstrand" => "tobias.sundstrand@gmail.com" }
  s.source           = { :git => "https://github.com/laptobbe/Realm-Rest.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/laptobbe'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'Realm-Rest' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
