# Identity iOS SDK

## Installation

### Cocoapods
Follow the instructions to install [Cocoapods](https://cocoapods.org)

## Getting Started

This SDK is modular and you only need to import what you really plan on using. The only mandatory part is SDK Core.

### SDK Core (required)

It contains all the main tools and interfaces, as well as methods related to standard authentication by identifier and password.

It contains all common tools and interfaces, authentication with passwords.

add thes dependency into your `Podfile` file

```ruby
pod 'IdentitySdkCore'
```

### SDK WebView

This module uses a WebView to authenticate users, it enables all providers that are supported by ReachFive.

```ruby
pod 'IdentitySdkWebView'
```

### Facebook native provider

This module uses the Facebook native SDK to provider better user experience.

#### Dependencies

```ruby
pod 'IdentitySdkFacebook'
```

#### Configuration
[Facebook Connect](https://support.reach5.co/article/4-create-facebook-application)

in your `Info.plist` file add those lines, you can get your config in facebook official documentation [Facebook SDK iOS](https://developers.facebook.com/docs/facebook-login/ios)
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fb000000000000000</string>
    </array>
  </dict>
</array>
<key>FacebookAppID</key>
<string>00000000000000</string>
<key>FacebookDisplayName</key>
<string>My Facebook Application name</string>

<key>LSApplicationQueriesSchemes</key>
<array>
  <string>fbapi</string>
  <string>fb-messenger-share-api</string>
  <string>fbauth2</string>
  <string>fbshareextension</string>
</array>
```

### Google native provider

This module uses the Google native SDK to provide a better user experience.

#### Dependency

```ruby
pod 'IdentitySdkGoogle'
```

#### Configuration

To use Google's native SDK you need to create a Google app, the steps are described in this article [Google Connect](https://support.reach5.co/article/5-create-google-application).

Official documentation https://developers.google.com/identity/sign-in/ios/start-integrating

Google Sign-in requires a custom URL Scheme to be added to your project. To add the custom scheme:

Open your project configuration: double-click the project name in the left tree view. Select your app from the TARGETS section, then select the Info tab, and expand the URL Types section.

Click the + button, and add your reversed client ID as a URL scheme.

The reversed client ID is your client ID with the order of the dot-delimited fields reversed. For example:

```
com.googleusercontent.apps.1234567890-abcdefg
```

When completed, your config should look something similar to the following (but with your application-specific values):

![google custom scheme config](https://developers.google.com/identity/sign-in/ios/images/xcode_infotab_url_type_values.png)

add `GIDSignInUIDelegate` to your `ViewCoàntroller`

```swift
import GoogleSignIn

class LoginController: UIViewController, GIDSignInUIDelegate {
    ...
}

```


### Initialize the SDK

`AppDelegate.swift`
```swift
let reachfive = ReachFive(
    sdkConfig: SdkConfig(domain: "my-domain.reach5.net", clientId: "XXXXR5ClientIdXXXXX"),
    providersCreators: [FacebookProvider(), GoogleProvider(), WebViewProvider()]
)

static func reachfive() -> ReachFive {
    let app = UIApplication.shared.delegate as! AppDelegate
    return app.reachfive
}

func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return reachfive.application(app, open: url, options: options)
}
```

`ViewController.swift`
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    AppDelegate.reachfive().initialize(callback: { response in
        switch response {
        case .success(let providers):
            // You can use this list of providers to display buttons
        case .failure(let error):
            // handle error
        }
    })
}
```

### Login with Provider
```swift
AppDelegate.reachfive()
    .getProvider(name: "paypal")?
    .login(
        scope: ReachFive.defaultScope,
        origin: "home",
        viewController: self,
        callback: { result in
            switch response {
            case .success(let authToken):
                // Content user information
                let user = authToken.user
                let accessToken = authToken.accessToken
            case .failure(let error):
                    // handle error
            }
        }
    )
```

### Login with password

```swift
AppDelegate.reachfive().loginWithPassword(
    username: email,
    password: password,
    scope: ReachFive.defaultScope,
    callback: { response in
        handleResponse(response)
    }
)
```

### Sign-up with password

```swift
let profile = Profile(email: email, password: password)
AppDelegate.reachfive().signupWithPassword(
    profile: profile,
    scope: ReachFive.defaultScope,
    callback: {
        handleResponse(response)
    }
)
```
