<p align="center">
 <img src="https://www.reachfive.com/hs-fs/hubfs/Reachfive_April2019/Images/site-logo.png?width=700&height=192&name=site-logo.png"/>
</p>

[![CircleCI](https://circleci.com/gh/ReachFive/identity-ios-sdk/tree/master.svg?style=svg)](https://circleci.com/gh/ReachFive/identity-ios-sdk/tree/master)
[![Download](https://img.shields.io/cocoapods/v/IdentitySdkCore.svg?style=flat) ](https://cocoapods.org/pods/IdentitySdkCore)

# ReachFive Identity iOS SDK

## Cocoapods pods

- [IdentitySdkCore](https://cocoapods.org/pods/IdentitySdkCore)
- [IdentitySdkWebView](https://cocoapods.org/pods/IdentitySdkWebView)
- [IdentitySdkFacebook](https://cocoapods.org/pods/IdentitySdkFacebook)
- [IdentitySdkGoogle](https://cocoapods.org/pods/IdentitySdkGoogle)

## Installation

Refer to the [public documentation](https://developer.reach5.co/guides/installation/ios) to install the SDKs and to initialize your ReachFive client.

## Demo application

In addition to the libraries, we provide in the `Sandbox` directory a simple iOS application which integrates the ReachFive SDKs.

Install [Cocoapods](https://cocoapods.org).

```sh
sudo gem install cocoapods

cd Sandbox
pod install

open Sandbox.xcworkspace

pod update
```

You also need to set the ReachFive client configuration within the SDK as below:

```
SdkConfig(
  domain: "my-reachfive-url",
  clientId: "my-reachfive-client-id",
  scheme: "my-reachfive-url-scheme"
)
```

The URL scheme must follow this pattern: `reachfive-${clientId}://callback`.

## Documentation

You'll find the documentation of the methods exposed on https://developer.reachfive.com/sdk-ios/index.html.

## Changelog

Please refer to [changelog](CHANGELOG.md) to see the descriptions of each release.

## License

MIT © [ReachFive](https://reachfive.co/)
