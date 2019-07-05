import UIKit
import IdentitySdkCore
import GoogleSignIn

class LoginController: UIViewController, UITableViewDataSource, UITableViewDelegate, GIDSignInUIDelegate {
    var providers: [Provider] = []
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var providersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        providersTableView.dataSource = self
        providersTableView.delegate = self
        
        AppDelegate.reachfive().initialize(callback: { response in
            switch response {
            case .success(let providers):
                self.providers.append(contentsOf: providers)
                self.providersTableView.reloadData()
            case .failure(let error):
                print("initialize error \(error)")
            }
        })
    }
    
    public func reloadProvidersData(providers: [Provider]) {
        self.providers = providers
        self.providersTableView.reloadData()
    }
    
    @IBAction func login(_ sender: Any) {
        let email = emailInput.text ?? ""
        let password = passwordInput.text ?? ""
        AppDelegate.shared().reachfive.loginWithPassword(username: email, password: password, scope: ReachFive.defaultScope, callback: { print($0) })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return providers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "providerCell")
        
        let provider = providers[indexPath.row]
        
        cell?.textLabel?.text = provider.name
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedProvider = providers[indexPath.row]
        
        AppDelegate.reachfive().getProvider(name: selectedProvider.name)?.login(scope: ReachFive.defaultScope, origin: "home", viewController: self, callback: { result in print(result) })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
