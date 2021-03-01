import UIKit
import IdentitySdkCore

class ProfileController: UIViewController {
    var authToken: AuthToken? = AppDelegate.storage.get(key: AppDelegate.authKey)

    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AppDelegate.reachfive()
            .getProfile(authToken: self.authToken!)
            .onSuccess { profile in print("Profile = \(profile)")
                self.nameLabel?.text = "Given name: " + profile.givenName!
                self.familyNameLabel?.text = "Family name: " + profile.familyName!
                self.emailLabel?.text = "Email: " + profile.email!
        }
            .onFailure { error in print("getProfile error = \(error)") }

       /* AppDelegate.reachfive()
            .updateProfile(
                authToken: self.authToken!,
                profile: Profile(nickname: "Updated nickname")
            )
            .onSuccess { profile in
                self.nameLabel?.text = profile.nickname
            }
            .onFailure { error in print("updateProfile error = \(error)") }
 */
    }
 

    @IBAction func logoutAction(_ sender: Any) {
        AppDelegate.reachfive().logout()
            .onComplete { result in
                print("Logout ended \(result)")
                AppDelegate.storage.clear(key: AppDelegate.authKey)
                self.authToken = nil
                self.navigationController?.popViewController(animated: true)
            }
    }

}
