import Foundation

enum State {
    case NotInitialazed
    case Initialazed
}

public class ReachFive: NSObject {
    var state: State = .NotInitialazed
    let sdkConfig: SdkConfig
    let providersCreators: Array<ProviderCreator>
    let reachFiveApi: ReachFiveApi
    var providers: [Provider] = []
    
    public static let defaultScope = ["openid", "email", "profile", "phone"]
    
    public init(sdkConfig: SdkConfig, providersCreators: Array<ProviderCreator>) {
        self.sdkConfig = sdkConfig
        self.providersCreators = providersCreators
        self.reachFiveApi = ReachFiveApi(sdkConfig: sdkConfig)
    }
    
    public func getProvider(name: String) -> Provider? {
        return providers.first(where: { $0.name == name })
    }
    
    public func getProviders() -> [Provider] {
        return providers
    }
    
    public func initialize(callback: @escaping Callback<[Provider], ReachFiveError>) {
        switch self.state {
        case .NotInitialazed:
            reachFiveApi.providersConfigs(callback: { result in
                callback(result.map({ providersConfigs in
                    let providers = self.createProviders(providersConfigsResult: providersConfigs)
                    self.providers = providers
                    self.state = .Initialazed
                    return providers
                }))
            })
        case .Initialazed:
            callback(.success(self.providers))
        }
    }
    
    public func initialize() {
        self.initialize(callback: { _ in })
    }
    
    func createProviders(providersConfigsResult: ProvidersConfigsResult) -> [Provider] {
        let webViewProvider = providersCreators.first(where: { $0.name == "webview" })
        return providersConfigsResult.items.map({ config in
            let nativeProvider = providersCreators.first(where: { $0.name == config.provider })
            if (nativeProvider != nil) {
                return nativeProvider?.create(sdkConfig: sdkConfig, providerConfig: config, reachFiveApi: reachFiveApi)
            } else if (webViewProvider != nil) {
                return webViewProvider?.create(sdkConfig: sdkConfig, providerConfig: config, reachFiveApi: reachFiveApi)
            } else {
                return nil
            }
        }).compactMap { $0 }
    }
    
    private func handleAuthResponse(callback: @escaping Callback<AuthToken, ReachFiveError>) -> Callback<AccessTokenResponse, ReachFiveError> {
        return { response in
            callback(response.flatMap { openIdTokenResponse in
                AuthToken.fromOpenIdTokenResponse(openIdTokenResponse: openIdTokenResponse)
            })
        }
    }
    
    public func signupWithPassword(profile: Profile, scope: [String], callback: @escaping Callback<AuthToken, ReachFiveError>) {
        let signupRequest = SignupRequest(
            clientId: sdkConfig.clientId,
            data: profile,
            scope: scope.joined(separator: " "),
            acceptTos: nil
        )
        reachFiveApi.signupWithPassword(signupRequest: signupRequest, callback: handleAuthResponse(callback: callback))
    }
    
    public func loginWithPassword(username: String, password: String, scope: [String], callback: @escaping Callback<AuthToken, ReachFiveError>) {
        let loginRequest = LoginRequest(
            username: username,
            password: password,
            grantType: "password",
            clientId: sdkConfig.clientId,
            scope: scope.joined(separator: " ")
        )
        reachFiveApi.loginWithPassword(loginRequest: loginRequest, callback: handleAuthResponse(callback: callback))
    }
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        for provider in providers {
            let _ = provider.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        return true
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        for provider in providers {
            let _ = provider.application(app, open: url, options: options)
        }
        return true
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        for provider in providers {
            let _ = provider.applicationDidBecomeActive(application)
        }
    }
    
    public func verifyPhoneNumber(
        authToken: AuthToken,
        phoneNumber: String,
        verificationCode: String,
        callback: @escaping Callback<Void, ReachFiveError>
    ) {
        let verifyPhoneNumberRequest = VerifyPhoneNumberRequest(phoneNumber: phoneNumber, verificationCode: verificationCode)
        reachFiveApi
            .verifyPhoneNumber(
                authToken: authToken,
                verifyPhoneNumberRequest: verifyPhoneNumberRequest,
                callback: callback
            )
    }
    
    public func updateEmail(
        authToken: AuthToken,
        email: String,
        redirectUrl: String? = nil,
        callback: @escaping Callback<Profile, ReachFiveError>
    ) {
        let updateEmailRequest = UpdateEmailRequest(email: email, redirectUrl: redirectUrl)
        reachFiveApi
            .updateEmail(
                authToken: authToken,
                updateEmailRequest: updateEmailRequest,
                callback: callback
            )
    }
    
    public func updateProfile(
        authToken: AuthToken,
        profile: Profile,
        callback: @escaping Callback<Profile, ReachFiveError>
    ) {
        reachFiveApi.updateProfile(authToken: authToken, profile: profile, callback: callback)
    }
    
    public func requestPasswordReset(
        authToken: AuthToken,
        email: String?,
        phoneNumber: String?,
        redirectUrl: String? = nil,
        callback: @escaping Callback<Void, ReachFiveError>
    ) {
        let requestPasswordResetRequest = RequestPasswordResetRequest(
            clientId: sdkConfig.clientId, email: email, phoneNumber: phoneNumber, redirectUrl: redirectUrl
        )
        reachFiveApi
            .requestPasswordReset(
                authToken: authToken,
                requestPasswordResetRequest: requestPasswordResetRequest,
                callback: callback
        )
    }
    
    public func logout(authToken: AuthToken, callback: @escaping Callback<Void, ReachFiveError>) {
        for provider in self.providers {
            provider.logout()
        }
        reachFiveApi.logout(authToken: authToken, callback: callback)
    }
    
    public override var description: String {
        return """
        Config: domain=\(sdkConfig.domain), clientId=\(sdkConfig.clientId)
        Providers: \(providers)
        """
    }
}
