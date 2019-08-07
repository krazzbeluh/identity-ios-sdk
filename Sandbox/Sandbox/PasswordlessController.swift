import Foundation
import UIKit
import IdentitySdkCore

class PasswordlessController: UIViewController {
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var phoneNumberInput: UITextField!
    
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
}
