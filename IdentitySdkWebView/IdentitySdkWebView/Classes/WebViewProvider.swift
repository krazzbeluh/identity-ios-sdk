import Foundation
import IdentitySdkCore

public class WebViewProvider: ProviderCreator {
    public static let NAME = "webview"
    
    public var name: String = NAME
    
    public init() {}
    
    public func create(sdkConfig: SdkConfig, providerConfig: ProviderConfig, reachFiveApi: ReachFiveApi) -> Provider {
        return ConfiguredWebViewProvider(sdkConfig: sdkConfig, providerConfig: providerConfig, reachFiveApi: reachFiveApi)
    }
}

class ConfiguredWebViewProvider: NSObject, Provider {
    var name: String = WebViewProvider.NAME
    
    let sdkConfig: SdkConfig
    let providerConfig: ProviderConfig
    let reachFiveApi: ReachFiveApi
    
    public init(sdkConfig: SdkConfig, providerConfig: ProviderConfig, reachFiveApi: ReachFiveApi) {
        self.sdkConfig = sdkConfig
        self.providerConfig = providerConfig
        self.reachFiveApi = reachFiveApi
        self.name = providerConfig.provider
    }
    
    public func login(scope: [String], origin: String, viewController: UIViewController?, callback: @escaping Callback<AuthToken, ReachFiveError>) {
        let frameworkBundle = Bundle(identifier: "org.cocoapods.IdentitySdkWebView")
        let storyboard = UIStoryboard(name: "WebView", bundle: frameworkBundle)
        let webViewController = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        let pkce = Pkce.generate()
        let url = self.buildUrl(sdkConfig: sdkConfig, providerConfig: providerConfig, scope: scope, pkce: pkce)
        webViewController.url = url
        webViewController.delegate = {
            switch $0 {
            case .success(let params):
                let code = params["code"] as? String
                if code != nil {
                    let authCodeRequest = AuthCodeRequest(clientId: self.sdkConfig.clientId, code: code!, pkce: pkce)
                    self.reachFiveApi.authWithCode(authCodeRequest: authCodeRequest, callback: { response in
                        switch response {
                        case .success(let openIdTokenResponse):
                            callback(AuthToken.fromOpenIdTokenResponse(openIdTokenResponse: openIdTokenResponse))
                        case .failure(let error): callback(.failure(ReachFiveError.TechnicalError(reason: error.localizedDescription)))
                        }
                    })
                } else {
                    callback(.failure(.TechnicalError(reason: "No authorization code")))
                }
            case .failure(let error):
                callback(.failure(.TechnicalError(reason: error.localizedDescription)))
            }
        }
        viewController?.show(webViewController, sender: nil)
    }
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return true
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return true
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func buildUrl(sdkConfig: SdkConfig, providerConfig: ProviderConfig, scope: [String], pkce: Pkce) -> String {
        let params = [
            "provider": providerConfig.provider,
            "client_id": sdkConfig.clientId,
            "response_type": "code",
            "redirect_uri": "reachfive://callback",
            "scope": scope.joined(separator: " "),
            "platform": "ios",
            "code_challenge": pkce.codeChallenge,
            "code_challenge_method": pkce.codeChallengeMethod,
        ]
        let queryStrings = params
            .map { "\($0)=\($1)" }
            .map { $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) }
            .filter { $0 != nil }
            .map { $0! }
            .joined(separator: "&")
        return "https://\(sdkConfig.domain)/oauth/authorize?\(queryStrings)"
    }
    
    override var description: String {
        return "Provider: \(self.name)"
    }
}
