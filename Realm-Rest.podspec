Pod::Spec.new do |s|
  s.name             = "Realm-Rest"
  s.version          = "2.1.0"
  s.summary          = "An extension to Realm.io for working with JSON based Rest API's"
  s.homepage         = "https://github.com/laptobbe/Realm-Rest"
  s.license          = 'MIT'
  s.author           = { "Tobias Sundstrand" => "tobias.sundstrand@gmail.com" }
  s.source           = { :git => "https://github.com/laptobbe/Realm-Rest.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/laptobbe'
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes'
  s.dependency 'Realm', '~> 0.90.5'
  s.dependency 'Realm+JSON', '~> 0.2.5'
  s.dependency 'NSString-UrlEncode', '~> 2.0.0'
  s.dependency 'NSURL+QueryDictionary', '~> 1.0.3'
  s.dependency 'KTBTaskQueue', '~> 1.0.1'
  s.dependency 'AFNetworking', '~> 2.5.0'
  s.dependency 'Functional.m', '~> 1.0.0'
end
