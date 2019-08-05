import Foundation
import SafariServices
import IdentitySdkCore
import BrightFutures

public class WebViewProvider: ProviderCreator {
    public static let NAME = "webview"
    
    public var name: String = NAME
    
    public init() {}
    
    public func create(sdkConfig: SdkConfig, providerConfig: ProviderConfig, reachFiveApi: ReachFiveApi) -> Provider {
        return ConfiguredWebViewProvider(sdkConfig: sdkConfig, providerConfig: providerConfig, reachFiveApi: reachFiveApi)
    }
}

class ConfiguredWebViewProvider: NSObject, Provider, SFSafariViewControllerDelegate {
    private let notificationName = Notification.Name("AuthCallbackNotification")
    private var safariViewController: SFSafariViewController? = nil
    private var pkce: Pkce = Pkce.generate()
    private var callback: Callback<AuthToken, ReachFiveError> = { _ in }

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
        self.callback = callback
        self.pkce = Pkce.generate()
        let url = self.buildUrl(sdkConfig: sdkConfig, providerConfig: providerConfig, scope: scope, pkce: pkce)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogin(_:)), name: self.notificationName, object: nil)
        
        self.safariViewController = SFSafariViewController.init(url: URL(string: url)!)
        
        viewController?.present(safariViewController!, animated: true)
    }
    
    @objc func handleLogin(_ notification : Notification) {
        NotificationCenter.default.removeObserver(self, name: self.notificationName, object: nil)
        
        let url = notification.object as? URL
        
        if let query = url?.query {
            let params = parseQueriesStrings(query: query)
            let code = params["code"]
            if code != nil {
                self.handleAuthCode(code!!)
            } else {
                self.callback(.failure(.TechnicalError(reason: "No authorization code")))
            }
        } else {
            callback(.failure(.TechnicalError(reason: "No authorization code")))
        }
        
        self.safariViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func handleAuthCode(_ code: String) {
        let authCodeRequest = AuthCodeRequest(clientId: self.sdkConfig.clientId, code: code, pkce: self.pkce)
        self.reachFiveApi.authWithCode(authCodeRequest: authCodeRequest)
            .flatMap({ AuthToken.fromOpenIdTokenResponseFuture($0) })
            .onSuccess { authToken in
                self.callback(.success(authToken))
            }
            .onFailure { error in
                self.callback(.failure(error))
            }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        NotificationCenter.default.removeObserver(self, name: self.notificationName, object: nil)
        controller.dismiss(animated: true, completion: nil)
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if let sourceApplication = options[.sourceApplication] {
            if (String(describing: sourceApplication) == "com.apple.SafariViewService") {
                NotificationCenter.default.post(name: self.notificationName, object: url)
                return true
            }
        }
        
        return false
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return true
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    public func logout() -> Future<Void, ReachFiveError> {
        return Future()
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
    
    func parseQueriesStrings(query: String) -> Dictionary<String, String?> {
        return query.split(separator: "&").reduce(Dictionary<String, String?>(), { ( acc, param) in
            var mutAcc = acc
            let splited = param.split(separator: "=")
            let key: String = String(splited.first!)
            let value: String? = splited.count > 1 ? String(splited[1]) : nil
            mutAcc.updateValue(value, forKey: key)
            return mutAcc
        })
    }
}
