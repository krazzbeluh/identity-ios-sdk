# Changelog

## v5.1.0
- Support of refreshToken
- Passwordless code verifification
- Passwordless intercept magic link

### Breaking changes
- The login with provider requires now the `scope` parameter `login(scope: [String]?, origin: String, viewController: UIViewController?).`
- The `signedUid` field was removed from the [Profile](https://developer.reach5.co/api/identity-ios/#profile) model.

## v5.0.0

- Use [Futures](https://github.com/Thomvis/BrightFutures) instead of callbacks, we use the [BrightFutures](https://github.com/Thomvis/BrightFutures) library
- Passwordless Start, it allows to launch the passwordless authentication flow
- Update password

### Breaking changes
We use Future instead callbacks, you need to transform yours callbacks into the Future
```swift
AppDelegate.reachfive()
  .loginWithPassword(username: email, password: password)
  .onSuccess { authToken in
    // Handle success
  }
  .onFailure { error in
    // Handle error
  }
```

instead of

```swift
AppDelegate.reachfive()
  .loginWithPassword(
    username: email,
    password: password,
    callback: { response in
        switch response {
          case .success(let authToken):
            // Handle success
          case .failure(let error):
            // handle error
          }
    }
)
```


## v4.0.0-beta.15
Use SFSafariViewController instead of WKWebView

## v4.0.0-beta.13
Fix UserConsent

## v4.0.0-beta.12
Add getProfile

## v4.0.0

### 9th July 2019

### Changes

New modular version of the Identity SDK iOS:

- [`IdentitySdkCore`](IdentitySdkCore)
- [`IdentitySdkFacebook`](IdentitySdkFacebook)
- [`IdentitySdkGoogle`](IdentitySdkGoogle)
- [`IdentitySdkWebView`](IdentitySdkWebView)
