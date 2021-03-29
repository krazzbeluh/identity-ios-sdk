import UIKit
import IdentitySdkCore
import PromiseKit
import CryptoSwift

class SignUpFidoControllerViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var givenNameText: UITextField!
    @IBOutlet weak var familyNameText: UITextField!
    @IBOutlet weak var deviceNameText: UITextField!
    let scopes = ["openid", "email", "profile", "phone", "full_write", "offline_access"]
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        AppDelegate.reachfive().initialize().onComplete { _ in }
        deviceNameText.text = UIDevice.current.name
    }
    
    @IBAction func SignupButton(_ sender: Any) {
        let profile = ProfileWebAuthnSignupRequest(
            email: emailText.text,
            givenName: givenNameText.text,
            familyName: familyNameText.text )
        
        AppDelegate.reachfive().signupWithWebAuthn(profile: profile,origin: AppDelegate.origin,friendlyName: deviceNameText.text,viewController: self,scopes: self.scopes)
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
