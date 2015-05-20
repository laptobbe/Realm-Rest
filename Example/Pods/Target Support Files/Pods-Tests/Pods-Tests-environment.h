
// To check if a library is compiled with CocoaPods you
// can use the `COCOAPODS` macro definition which is
// defined in the xcconfigs so it is available in
// headers also when they are imported in the client
// project.


// Expecta
#define COCOAPODS_POD_AVAILABLE_Expecta
#define COCOAPODS_VERSION_MAJOR_Expecta 1
#define COCOAPODS_VERSION_MINOR_Expecta 0
#define COCOAPODS_VERSION_PATCH_Expecta 0

// OCMock
#define COCOAPODS_POD_AVAILABLE_OCMock
#define COCOAPODS_VERSION_MAJOR_OCMock 3
#define COCOAPODS_VERSION_MINOR_OCMock 1
#define COCOAPODS_VERSION_PATCH_OCMock 2

// OHHTTPStubs
#define COCOAPODS_POD_AVAILABLE_OHHTTPStubs
#define COCOAPODS_VERSION_MAJOR_OHHTTPStubs 4
#define COCOAPODS_VERSION_MINOR_OHHTTPStubs 0
#define COCOAPODS_VERSION_PATCH_OHHTTPStubs 1

// Specta
#define COCOAPODS_POD_AVAILABLE_Specta
// This library does not follow semantic-versioning,
// so we were not able to define version macros.
// Please contact the author.
// Version: 0.3.0.beta1.

