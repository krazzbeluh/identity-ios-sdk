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

        let profile = Profile(email: email, password: password, name: name)
        AppDelegate.reachfive().signupWithPassword(profile: profile, scope: ReachFive.defaultScope, callback: { print($0) })
    }
}
