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
        
        AppDelegate.reachfive()
            .initialize()
            .onSuccess { providers in
                self.providers.append(contentsOf: providers)
                self.providersTableView.reloadData()
            }
            .onFailure { print("initialize error \($0)") }
    }
    
    public func reloadProvidersData(providers: [Provider]) {
        self.providers = providers
        self.providersTableView.reloadData()
    }
    
    @IBAction func login(_ sender: Any) {
        let email = emailInput.text ?? ""
        let password = passwordInput.text ?? ""
        AppDelegate.shared().reachfive
            .loginWithPassword(username: email, password: password)
            .onSuccess(callback: goToProfile)
            .onFailure(callback: { error in
                switch error {
                case .RequestError(let requestErrors):
                    self.error.text = requestErrors.errorUserMsg
                default:
                    self.error.text = error.localizedDescription
                }
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
            goToProfile(authToken)
        case .failure(let error):
            print(error)
        }
    }
        
    func goToProfile(_ authToken: AuthToken) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profileController = storyBoard.instantiateViewController(
            withIdentifier: "ProfileScene"
        ) as! ProfileController
        profileController.authToken = authToken
        self.self.navigationController?.pushViewController(profileController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedProvider = providers[indexPath.row]
        
        let scope = ["openid", "email", "profile", "phone", "full_write"]
        
        AppDelegate.reachfive()
            .getProvider(name: selectedProvider.name)?
            .login(
                scope: scope,
                origin: "home",
                viewController: self,
                callback: { result in self.handleResult(result: result) }
            )
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
