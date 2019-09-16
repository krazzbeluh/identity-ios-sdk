import UIKit
import IdentitySdkCore

class ProfileController: UIViewController {
    var authToken: AuthToken? = AppDelegate.storage.get(key: "AUTH_TOKEN")
    
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
        
        AppDelegate.reachfive()
            .refreshAccessToken(refreshToken: self.authToken?.refreshToken ?? "")
            .onComplete { result in
                print("refreshAccessToken result = \(result)")
            }
    }

    @IBAction func logoutAction(_ sender: Any) {
        AppDelegate.reachfive().logout()
            .onComplete { result in
                print("Logout ended \(result)")
                AppDelegate.storage.clear(key: "AUTH_TOKEN")
                self.authToken = nil
                self.navigationController?.popViewController(animated: true)
            }
    }

}
