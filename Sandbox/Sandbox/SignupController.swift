import UIKit
import IdentitySdkCore

class SignupController: UIViewController {
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var nameInput: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.reachfive().initialize()
    }

    @IBAction func signup(_ sender: Any) {
        let email = emailInput.text ?? ""
        let password = passwordInput.text ?? ""
        let name = nameInput.text ?? ""

        let profile = ProfileSignupRequest(password: password, email: email, name: name)
        AppDelegate.reachfive().signup(profile: profile, callback: { print($0) })
    }
}
