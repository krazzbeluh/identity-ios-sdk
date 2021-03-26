import UIKit
import IdentitySdkCore
import PromiseKit
import CryptoSwift

class LoginWithFidoViewController: UIViewController{
    
    @IBOutlet weak var emailText: UITextField!
    let scopes = ["openid", "email", "profile", "phone", "full_write", "offline_access"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppDelegate.reachfive().initialize().onComplete { _ in }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        AppDelegate.reachfive().loginWithWebAuthn(email: self.emailText.text!,origin: AppDelegate.origin,scopes: scopes,viewController: self)
        { (authToken) -> Any in
            authToken.onSuccess(callback: self.goToProfile)
        }
    }
    
    func goToProfile(_ authToken: AuthToken) {
        AppDelegate.storage.save(key: AppDelegate.authKey, value: authToken)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profileController = storyBoard.instantiateViewController(
            withIdentifier: "ProfileScene"
            ) as! ProfileController
        profileController.authToken = authToken
        self.self.navigationController?.pushViewController(profileController, animated: true)
    }
}
