import UIKit
import IdentitySdkCore
import GoogleSignIn

class LoginController: UIViewController, UITableViewDataSource, UITableViewDelegate, GIDSignInUIDelegate {
    var providers: [Provider] = []
    
    @IBOutlet weak var error: UILabel!
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
        AppDelegate.shared().reachfive.loginWithPassword(username: email, password: password, scope: ReachFive.defaultScope, callback: { result in
            self.handleResult(result: result)
        })
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
    
    func handleResult(result: Result<AuthToken, ReachFiveError>) {
        switch result {
        case .success(let authToken):
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profileController = storyBoard.instantiateViewController(
                withIdentifier: "ProfileScene"
            ) as! ProfileController
            profileController.authToken = authToken
            self.self.navigationController?.pushViewController(profileController, animated: true)
        case .failure(.RequestError(let requestErrors)):
            self.error.text = requestErrors.errorUserMsg
        case .failure(let error):
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedProvider = providers[indexPath.row]
        
        AppDelegate.reachfive()
            .getProvider(name: selectedProvider.name)?
            .login(
                scope: ReachFive.defaultScope,
                origin: "home",
                viewController: self,
                callback: { result in self.handleResult(result: result) }
            )
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
