import Foundation
import UIKit
import WebKit
import IdentitySdkCore

public class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {    
    @IBOutlet weak var webView: WKWebView!
    
    var url: String? = nil
    var delegate: Callback<Dictionary<String, String?>, ReachFiveError>? = nil
    
    public override func viewDidLoad() {
        super.viewDidLoad()
                
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        
        let url = URL(string: self.url!)!
        webView.load(URLRequest(url: url))
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
