import UIKit
import IdentitySdkCore

class UpdatePhoneNumberController: UIViewController {
    let authToken: AuthToken? = AuthTokenStorage.get()
    
    @IBOutlet weak var phoneNumberInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func update(_ sender: Any) {
        AppDelegate.reachfive()
            .updatePhoneNumber(authToken: self.authToken!, phoneNumber: phoneNumberInput.text ?? "")
            .onSuccess { profile in
                let alert = UIAlertController(
                    title: "Update",
                    message: "Update Success",
                    preferredStyle: UIAlertController.Style.alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            .onFailure { error in
                let alert = UIAlertController(
                    title: "Update",
                    message: "Update Error: \(error.localizedDescription)",
                    preferredStyle: UIAlertController.Style.alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
    }
}
