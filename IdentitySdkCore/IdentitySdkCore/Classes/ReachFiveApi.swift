import Alamofire
import BrightFutures

public class ReachFiveApi {
    let decoder = JSONDecoder()
    let sdkConfig: SdkConfig
    
    let deviceInfo: String = "\(UIDevice.current.modelName) \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    
    public init(sdkConfig: SdkConfig) {
        self.sdkConfig = sdkConfig
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    public func clientConfig() -> Future<ClientConfigResponse, ReachFiveError> {
        return Alamofire
            .request(createUrl(path: "/identity/v1/config?client_id=\(sdkConfig.clientId)"))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJson(type: ClientConfigResponse.self, decoder: self.decoder)
    }
    
    public func providersConfigs() -> Future<ProvidersConfigsResult, ReachFiveError> {
        return Alamofire
            .request(createUrl(path: "/api/v1/providers?platform=ios&device=\(deviceInfo)"))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJson(type: ProvidersConfigsResult.self, decoder: self.decoder)
    }
    
    public func loginWithProvider(
        loginProviderRequest: LoginProviderRequest
    ) -> Future<AccessTokenResponse, ReachFiveError> {
        return Alamofire
            .request(createUrl(path: "/identity/v1/oauth/provider/token?device=\(deviceInfo)"), method: .post, parameters: loginProviderRequest.dictionary(), encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJson(type: AccessTokenResponse.self, decoder: self.decoder)
    }
    
    public func signupWithPassword(signupRequest: SignupRequest) -> Future<AccessTokenResponse, ReachFiveError> {
        return Alamofire
            .request(
                createUrl(path: "/identity/v1/signup-token?device=\(deviceInfo)"),
                method: .post,
                parameters: signupRequest.dictionary(),
                encoding: JSONEncoding.default
            )
            .validate(contentType: ["application/json"])
            .responseJson(type: AccessTokenResponse.self, decoder: self.decoder)
    }
    
    public func loginWithPassword(loginRequest: LoginRequest) -> Future<AccessTokenResponse, ReachFiveError> {
        return Alamofire
            .request(
                createUrl(path: "/oauth/token?device=\(deviceInfo)"),
                method: .post,
                parameters: loginRequest.dictionary(),
                encoding: JSONEncoding.default
            )
            .validate(contentType: ["application/json"])
            .responseJson(type: AccessTokenResponse.self, decoder: self.decoder)
    }
    
    public func authWithCode(authCodeRequest: AuthCodeRequest) -> Future<AccessTokenResponse, ReachFiveError> {
        return Alamofire
            .request(
                createUrl(path: "/oauth/token?device=\(deviceInfo)"),
                method: .post,
                parameters: authCodeRequest.dictionary(),
                encoding: JSONEncoding.default
            )
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJson(type: AccessTokenResponse.self, decoder: self.decoder)
    }
    
    public func getProfile(authToken: AuthToken) -> Future<Profile, ReachFiveError> {
        return Alamofire
            .request(
                createUrl(path: "/identity/v1/me?device=\(deviceInfo)"),
                method: .get,
                headers: tokenHeader(authToken)
            )
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJson(type: Profile.self, decoder: self.decoder)
    }
    
    public func verifyPhoneNumber(
        authToken: AuthToken,
        verifyPhoneNumberRequest: VerifyPhoneNumberRequest
    ) -> Future<(), ReachFiveError> {
        return Alamofire
            .request(
                createUrl(path: "/identity/v1/verify-phone-number?device=\(deviceInfo)"),
                method: .post,
                parameters: verifyPhoneNumberRequest.dictionary(),
                encoding: JSONEncoding.default,
                headers: tokenHeader(authToken)
            )
            .validate(contentType: ["application/json"])
            .responseJson(decoder: self.decoder)
    }

    public func updateEmail(
        authToken: AuthToken,
        updateEmailRequest: UpdateEmailRequest
    ) -> Future<Profile, ReachFiveError> {
        return Alamofire
            .request(
                createUrl(path: "/identity/v1/update-email?device=\(deviceInfo)"),
                method: .post,
                parameters: updateEmailRequest.dictionary(),
                encoding: JSONEncoding.default,
                headers: tokenHeader(authToken)
            )
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJson(type: Profile.self, decoder: self.decoder)
    }
    
    public func updateProfile(
        authToken: AuthToken,
        profile: Profile
    ) -> Future<Profile, ReachFiveError> {
        return Alamofire
            .request(
                createUrl(path: "/identity/v1/update-profile?device=\(deviceInfo)"),
                method: .post,
                parameters: profile.dictionary(),
                encoding: JSONEncoding.default,
                headers: tokenHeader(authToken)
            )
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJson(type: Profile.self, decoder: self.decoder)
    }
    
    public func updatePassword(
        authToken: AuthToken?,
        updatePasswordRequest: UpdatePasswordRequest
    ) -> Future<(), ReachFiveError> {
        let headers: [String: String] = authToken != nil ? tokenHeader(authToken!) : [:]
        return Alamofire
            .request(
                createUrl(path: "/identity/v1/update-password?device=\(deviceInfo)"),
                method: .post,
                parameters: updatePasswordRequest.dictionary(),
                encoding: JSONEncoding.default,
                headers: headers
            )
            .validate(contentType: ["application/json"])
            .responseJson(decoder: self.decoder)
    }
    
    public func updatePhoneNumber(
        authToken: AuthToken,
        updatePhoneNumberRequest: UpdatePhoneNumberRequest
    ) -> Future<Profile, ReachFiveError> {
        return Alamofire
            .request(
                createUrl(path: "/identity/v1/update-phone-number?device=\(deviceInfo)"),
                method: .post,
                parameters: updatePhoneNumberRequest.dictionary(),
                encoding: JSONEncoding.default,
                headers: tokenHeader(authToken)
            )
            .validate(contentType: ["application/json"])
            .responseJson(type: Profile.self, decoder: self.decoder)
    }
    
    public func requestPasswordReset(
        requestPasswordResetRequest: RequestPasswordResetRequest
    ) -> Future<(), ReachFiveError> {
        return Alamofire
            .request(createUrl(
                path: "/identity/v1/forgot-password?device=\(deviceInfo)"),
                method: .post,
                parameters: requestPasswordResetRequest.dictionary(),
                encoding: JSONEncoding.default
            )
            .validate(contentType: ["application/json"])
            .responseJson(decoder: self.decoder)
    }
    
    public func startPasswordless(_ startPasswordlessRequest: StartPasswordlessRequest) -> Future<(), ReachFiveError> {
        return Alamofire
            .request(
                createUrl(path: "/identity/v1/passwordless/start?device=\(deviceInfo)"),
                method: .post,
                parameters: startPasswordlessRequest.dictionary(),
                encoding: JSONEncoding.default
            )
            .validate(statusCode: 200..<300)
            .responseJson(decoder: self.decoder)
    }
    
    public func logout() -> Future<(), ReachFiveError> {
        return Alamofire
            .request(
                createUrl(path: "/identity/v1/logout?device=\(deviceInfo)"),
                method: .get
            )
            .validate(statusCode: 200..<300)
            .responseJson(decoder: self.decoder)
    }
    
    func tokenHeader(_ authToken: AuthToken) -> [String: String] {
        return ["Authorization": "\(authToken.tokenType ?? "Bearer") \(authToken.accessToken)"]
    }
    
    func createUrl(path: String) -> String {
        return "https://\(sdkConfig.domain)\(path)"
    }
}
