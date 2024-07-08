import Foundation
import UIKit

class RecoveryStartController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    
    @IBAction func sendLink(_ sender: Any) {
        guard let username = username.text, !username.isEmpty else { return }
        var email: String?
        var phoneNumber: String?
        if (username.contains("@")) {
            email = username
        } else {
            phoneNumber = username
        }
        
        AppDelegate.reachfive().requestAccountRecovery(email: email, phoneNumber: phoneNumber, origin: "RecoveryStartController:sendLink")
            .onSuccess { _ in
                if let verificationController = self.storyboard?.instantiateViewController(withIdentifier: "AccountRecoveryVerification") as? RecoveryVerificationController {
                    verificationController.email = email
                    verificationController.phoneNumber = phoneNumber
                    self.navigationController?.pushViewController(verificationController, animated: true)
                }
            }
            .onFailure { error in
                let alert = AppDelegate.createAlert(title: "Login failed", message: "Error: \(error.message())")
                self.present(alert, animated: true)
            }
    }
}
