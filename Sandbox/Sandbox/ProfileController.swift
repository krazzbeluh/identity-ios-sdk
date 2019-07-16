import UIKit
import IdentitySdkCore

class ProfileController: UIViewController {
    public var authToken: AuthToken?
    
    @IBOutlet weak var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel?.text = self.authToken?.user?.name
    }

    @IBAction func logoutAction(_ sender: Any) {
        if self.authToken != nil {
            AppDelegate.reachfive().logout(authToken: self.authToken!, callback: { result in
                print("Logout ended \(result)")
            })
        }
    }

}
