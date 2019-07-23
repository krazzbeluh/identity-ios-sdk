import UIKit
import IdentitySdkCore

class ProfileController: UIViewController {
    public var authToken: AuthToken?
    
    @IBOutlet weak var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel?.text = self.authToken?.user?.name
        
        AppDelegate.reachfive().getProfile(authToken: self.authToken!, callback: { result in
            switch result {
            case .success(let profile):
                print("Profile = \(profile)")
            case .failure(let error):
                print(error)
            }
        })
        
        AppDelegate.reachfive().updateProfile(
            authToken: self.authToken!,
            profile: Profile(nickname: "Updated nickname"),
            callback: { result in
                result.map { profile in
                    self.nameLabel?.text = profile.nickname
                }
            }
        )
        
    }

    @IBAction func logoutAction(_ sender: Any) {
        if self.authToken != nil {
            AppDelegate.reachfive().logout(authToken: self.authToken!, callback: { result in
                print("Logout ended \(result)")
            })
            self.authToken = nil
            self.navigationController?.popViewController(animated: true)
        }
    }

}
