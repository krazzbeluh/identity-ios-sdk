import Foundation
import UIKit
import WebKit
import IdentitySdkCore

public class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {    
    var webView: WKWebView!
    
    @IBOutlet var webViewContainer: UIView!
    @IBOutlet weak var loader: UIActivityIndicatorView?
    
    var url: String? = nil
    var delegate: Callback<Dictionary<String, String?>, ReachFiveError>? = nil
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.allowsLinkPreview = true
        webView.uiDelegate = self
        
        webViewContainer.addSubview(webView)
        webViewContainer.sendSubviewToBack(webView)
        addConstraints(to: webView, with: webViewContainer)
        
        if #available(iOS 11.0, *) {
            webView.frame = webViewContainer.safeAreaLayoutGuide.layoutFrame
        }
        
        let url = URL(string: self.url!)!
        webView.load(URLRequest(url: url))
    }
    
    func addConstraints(to webView: UIView, with superView: UIView) {
        webView.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(
            item: webView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: superView,
            attribute: .leading,
            multiplier: 1,
            constant: 0
        )
        let trailingConstraint = NSLayoutConstraint(
            item: webView,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: superView,
            attribute: .trailing,
            multiplier: 1,
            constant: 0
        )
        let topConstraint = NSLayoutConstraint(
            item: webView,
            attribute: .top,
            relatedBy: .equal,
            toItem: superView,
            attribute: .top,
            multiplier: 1, constant: 0
        )
        let bottomConstraint = NSLayoutConstraint(
            item: webView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: superView,
            attribute: .bottom,
            multiplier: 1,
            constant: 0
        )
        superView.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
    
    func loadHtml(html: String) {
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let scheme = webView.url?.scheme
        let queries = webView.url?.query
        
        if scheme == "reachfive" && queries != nil {
            let params = parseQueriesStrings(query: queries!)
            decisionHandler(.cancel)
            navigationController?.popViewController(animated: true)
            self.delegate!(.success(params))
        } else {
            decisionHandler(.allow)
        }
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loader?.stopAnimating()
        self.loader?.removeFromSuperview()
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
