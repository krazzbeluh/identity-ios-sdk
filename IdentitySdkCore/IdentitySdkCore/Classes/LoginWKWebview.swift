import UIKit
import WebKit
import Alamofire
import BrightFutures

public class LoginWKWebview: UIView {
    var webView: WKWebView?
    var reachfive: ReachFive?
    var promise: Promise<AuthToken, ReachFiveError>?
    var pkce: Pkce?
    var origin: String?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func loadLoginWebview(reachfive: ReachFive, promise: Promise<AuthToken, ReachFiveError>, state: String? = nil, nonce: String? = nil, scope: [String]? = nil, origin: String? = nil) {
        let pkce = Pkce.generate()
        
        self.reachfive = reachfive
        self.promise = promise
        self.pkce = pkce
        self.origin = origin
        
        let rect = CGRect(origin: .zero, size: frame.size)
        let webView = WKWebView(frame: rect, configuration: WKWebViewConfiguration())
        self.webView = webView
        webView.navigationDelegate = self
        addSubview(webView)
        webView.load(URLRequest(url: reachfive.buildAuthorizeURL(pkce: pkce, state: state, nonce: nonce, scope: scope, origin: origin)))
    }
}

extension LoginWKWebview: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> ()) {
        guard let reachfive,
              let promise,
              let pkce,
              let url = navigationAction.request.url,
              url.scheme == reachfive.sdkConfig.baseScheme.lowercased()
        else {
            decisionHandler(.allow)
            return
        }
        
        decisionHandler(.cancel)
        let params = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems
        guard let params, let code = params.first(where: { $0.name == "code" })?.value else {
            promise.failure(.TechnicalError(reason: "No authorization code", apiError: ApiError(fromQueryParams: params)))
            return
        }
        
        promise.completeWith(reachfive.authWithCode(code: code, pkce: pkce))
    }
}
