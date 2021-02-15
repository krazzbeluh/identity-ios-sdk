import Foundation
import BrightFutures

enum State {
    case NotInitialized
    case Initialized
}

public typealias PasswordlessCallback = (_ result: Result<AuthToken, ReachFiveError>) -> Void

/// ReachFive identity SDK
public class ReachFive: NSObject {
    let notificationPasswordlessName = Notification.Name("PasswordlessNotification")
    var passwordlessCallback: PasswordlessCallback? = nil
    var state: State = .NotInitialized
    let sdkConfig: SdkConfig
    let providersCreators: Array<ProviderCreator>
    let reachFiveApi: ReachFiveApi
    var providers: [Provider] = []
    internal var scope: [String] = []
    internal let storage: Storage
    let codeResponseType = "code"
    
    public init(sdkConfig: SdkConfig, providersCreators: Array<ProviderCreator>, storage: Storage?) {
        self.sdkConfig = sdkConfig
        self.providersCreators = providersCreators
        self.reachFiveApi = ReachFiveApi(sdkConfig: sdkConfig)
        self.storage = storage ?? UserDefaultsStorage()
    }
    
    public func logout() -> Future<(), ReachFiveError> {
        return self.providers
            .map { $0.logout() }
            .sequence()
            .flatMap { _ in self.reachFiveApi.logout() }
    }
    
    public func refreshAccessToken(authToken: AuthToken) -> Future<AuthToken, ReachFiveError> {
        let refreshRequest = RefreshRequest(
            clientId: sdkConfig.clientId,
            refreshToken: authToken.refreshToken ?? "",
            redirectUri: sdkConfig.scheme
        )
        return reachFiveApi
            .refreshAccessToken(refreshRequest)
            .flatMap({ AuthToken.fromOpenIdTokenResponseFuture($0) })
    }
    
    public override var description: String {
        return """
            Config: domain=\(sdkConfig.domain), clientId=\(sdkConfig.clientId)
            Providers: \(providers)
            Scope: \(scope.joined(separator: ""))
        """
    }
    
    public func loginCallback(tkn: String, scopes: [String]?)  -> String {
    
          let pkce = Pkce.generate()
          self.storage.save(key: "CODE_VERIFIER", value: pkce)
        
          let scope = [String](scopes!).joined(separator: " ")
          let options: [String:String] = [
          "client_id": sdkConfig.clientId,
          "tkn": tkn,
          "response_type": codeResponseType,
          "redirect_uri": sdkConfig.scheme,
          "scope": scope,
          "code_challenge": pkce.codeChallenge,
          "code_challenge_method": pkce.codeChallengeMethod
          ]
             return  self.reachFiveApi
                        .authorize(options: options)            
         }
    
    public func authWithCode(code: String, pkce :Pkce) -> Future<AuthToken, ReachFiveError> {
        let authCodeRequest = AuthCodeRequest(
            clientId: self.sdkConfig.clientId ,
            code: code,
            redirectUri: self.sdkConfig.scheme,
            pkce: pkce
        )
        return self.reachFiveApi
            .authWithCode(authCodeRequest: authCodeRequest)
            .flatMap({ AuthToken.fromOpenIdTokenResponseFuture($0) })
    }
}
