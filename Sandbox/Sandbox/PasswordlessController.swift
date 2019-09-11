import Foundation
import UIKit
import IdentitySdkCore

class PasswordlessController: UIViewController {
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var phoneNumberInput: UITextField!
    @IBOutlet weak var verificationCodeInput: UITextField!
    
    @IBAction func loginWithEmail(_ sender: Any) {
        AppDelegate.reachfive()
            .startPasswordless(.Email(email: emailInput.text ?? ""))
            .onComplete { result in
                print("startPasswordless email \(result)")
            }
    }
    
    @IBAction func loginWithPhoneNumber(_ sender: Any) {
        AppDelegate.reachfive()
            .startPasswordless(.PhoneNumber(phoneNumber: phoneNumberInput.text ?? ""))
            .onComplete { result in
                print("startPasswordless phone number \(result)")
            }
    }
    @IBAction func verifyCode(_ sender: Any) {
        let verifyAuthCodeRequest = VerifyAuthCodeRequest(
            phoneNumber: phoneNumberInput.text,
            email: emailInput.text,
            verificationCode: verificationCodeInput.text ?? ""
        )
        AppDelegate.reachfive()
            .verifyPasswordlessCode(verifyAuthCodeRequest: verifyAuthCodeRequest)
            .onComplete { result in
                let alert = AppDelegate.createAlert(title: "Verify code success", message: "Success")
                self.present(alert, animated: true, completion: nil)
            }
        
    }
}
