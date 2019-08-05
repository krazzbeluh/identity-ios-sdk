import UIKit
import IdentitySdkCore

class ProfileController: UIViewController {
    var authToken: AuthToken? = AuthTokenStorage.get()
    
    @IBOutlet weak var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel?.text = self.authToken?.user?.name
        
        AppDelegate.reachfive()
            .getProfile(authToken: self.authToken!)
            .onSuccess { profile in print("Profile = \(profile)") }
            .onFailure { error in print("getProfile error = \(error)") }
        
        AppDelegate.reachfive()
            .updateProfile(
                authToken: self.authToken!,
                profile: Profile(nickname: "Updated nickname")
            )
            .onSuccess { profile in
                self.nameLabel?.text = profile.nickname
            }
            .onFailure { error in print("updateProfile error = \(error)") }
    }

    @IBAction func logoutAction(_ sender: Any) {
        if self.authToken != nil {
            AppDelegate.reachfive().logout(authToken: self.authToken!)
                .onComplete { result in
                    print("Logout ended \(result)")
                    AuthTokenStorage.clear()
                    self.authToken = nil
                    self.navigationController?.popViewController(animated: true)
                }
        }
    }

}
