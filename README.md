# Realm-Rest

[![Build Status](https://travis-ci.org/laptobbe/Realm-Rest.svg?branch=master)](https://travis-ci.org/laptobbe/Realm-Rest)
[![Version](https://img.shields.io/cocoapods/v/Realm-Rest.svg?style=flat)](http://cocoadocs.org/docsets/Realm-Rest)
[![License](https://img.shields.io/cocoapods/l/Realm-Rest.svg?style=flat)](http://cocoadocs.org/docsets/Realm-Rest)
[![Platform](https://img.shields.io/cocoapods/p/Realm-Rest.svg?style=flat)](http://cocoadocs.org/docsets/Realm-Rest)

A first version of an extension to Realm.io for working with JSON based Rest API's

## Installation

Realm-Rest is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "Realm-Rest"

## Basic Usage

``` objc
[realm setBaseUrl:@"http://api.example.com" queuePersistance:RestRequestQueuePeristanceDatabase];

@interface User : RLMObject
@property NSString* username;
@property NSString* name;
@end

[User restInDefaultRealmWithRequestType:RestRequestTypePost
	parameters:@{
		RestRequestParameterStyleJSON : @{
			”username”:”foo”,
			”password”:”bar”
		}}
	headers:nil
	userInfo:@{@"action":@"login"}
	success:^(id primaryKey) {
    	User *user = [User objectForPrimaryKey:primaryKey];
    	//Use object
	}
	failure:^(NSError *error, NSDictionary *userInfo) {
		//Handle error
	}
];

```

## Usage Details

Se the [Wiki](https://github.com/laptobbe/Realm-Rest/wiki/Usage) for more details on how to use Realm-Rest

## Author

Tobias Sundstrand, tobias.sundstrand@gmail.com

## License

Realm-Rest is available under the MIT license. See the LICENSE file for more info.

