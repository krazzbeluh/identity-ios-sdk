import UIKit
import IdentitySdkCore
import BrightFutures

//TODO
//      - déplacer le bouton login with refresh ici pour que, même logué, on puisse afficher les passkey (qui sont expirées )
//      - ajouter une option convertion vers un mdp fort automatique et vers SIWA
//      - voir les SLO liés et bouton pour les délier
class ProfileController: UIViewController {
    var authToken: AuthToken?
    var devices: [DeviceCredential] = [] {
        didSet {
            print("devices \(devices)")
            if devices.isEmpty {
                listPasskeyLabel.isHidden = true
                credentialTableview.isHidden = true
            } else {
                listPasskeyLabel.isHidden = false
                credentialTableview.isHidden = false
            }
        }
    }
    
    var clearTokenObserver: NSObjectProtocol?
    var setTokenObserver: NSObjectProtocol?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var customIdentifierLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var methodLabel: UILabel!
    
    @IBOutlet weak var listPasskeyLabel: UILabel!
    @IBOutlet weak var credentialTableview: UITableView!
    
    @IBOutlet weak var profileTabBarItem: UITabBarItem!
    
    @IBOutlet weak var updatePasswordButton: UIButton!
    @IBOutlet weak var registerPasskeyButton: UIButton!
    @IBOutlet weak var updatePhoneButton: UIButton!
    
    override func viewDidLoad() {
        print("ProfileController.viewDidLoad")
        super.viewDidLoad()
        
        credentialTableview.delegate = self
        credentialTableview.dataSource = self
        
        clearTokenObserver = NotificationCenter.default.addObserver(forName: .DidClearAuthToken, object: nil, queue: nil) { _ in
            self.didLogout()
        }
        
        setTokenObserver = NotificationCenter.default.addObserver(forName: .DidSetAuthToken, object: nil, queue: nil) { _ in
            self.didLogin()
        }
        
        authToken = AppDelegate.storage.get(key: SecureStorage.authKey)
        if authToken != nil {
            profileTabBarItem.image = SandboxTabBarController.profileCheck
            profileTabBarItem.selectedImage = SandboxTabBarController.profileCheckFill
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ProfileController.viewWillAppear")
        authToken = AppDelegate.storage.get(key: SecureStorage.authKey)
        guard let authToken else {
            print("not logged in")
            return
        }
        
        updatePasswordButton.isHidden = false
        registerPasskeyButton.isHidden = false
        updatePhoneButton.isHidden = false
        
        AppDelegate.reachfive()
            .getProfile(authToken: authToken)
            .onSuccess { profile in
                self.nameLabel.text = profile.givenName
                self.familyNameLabel.text = profile.familyName
                if let email = profile.email {
                    self.emailLabel.text = email
                    self.emailLabel.text?.append(profile.emailVerified == true ? " ✔︎" : " ✘")
                }
                if let phoneNumber = profile.phoneNumber {
                    self.phoneNumberLabel.text = phoneNumber
                    self.phoneNumberLabel.text?.append(profile.phoneNumberVerified == true ? " ✔︎" : " ✘")
                }
                self.customIdentifierLabel.text = profile.customIdentifier
                if let loginSummary = profile.loginSummary, let lastLogin = loginSummary.lastLogin {
                    self.loginLabel.text = self.format(date: lastLogin)
                    self.methodLabel.text = loginSummary.lastProvider
                }
            }
            .onFailure { error in
                // probably the token is expired so remove it
                AppDelegate.storage.clear(key: SecureStorage.authKey)
                print("getProfile error = \(error.message())")
            }
        
        reloadCredentials(authToken: authToken)
        
        super.viewWillAppear(animated)
    }
    
    func didLogin() {
        print("ProfileController.didLogin")
        authToken = AppDelegate.storage.get(key: SecureStorage.authKey)
    }
    
    func didLogout() {
        print("ProfileController.didLogout")
        authToken = nil
        nameLabel.text = nil
        familyNameLabel.text = nil
        emailLabel.text = nil
        phoneNumberLabel.text = nil
        customIdentifierLabel.text = nil
        loginLabel.text = nil
        methodLabel.text = nil
        devices = []
        credentialTableview.reloadData()
        
        updatePasswordButton.isHidden = true
        registerPasskeyButton.isHidden = true
        updatePhoneButton.isHidden = true
    }
    
    private func reloadCredentials(authToken: AuthToken) {
        // Beware that a valid token for profile might not be fresh enough to retrieve the credentials
        AppDelegate.reachfive().listWebAuthnCredentials(authToken: authToken).onSuccess { listCredentials in
                self.devices = listCredentials
        
                //TODO comprendre pourquoi on fait un async. En a-t-on vraiment besoin ?
                DispatchQueue.main.async {
                    self.credentialTableview.reloadData()
                }
            }
            .onFailure { error in
                self.devices = []
                print("getCredentials error = \(error.message())")
            }
    }
    
    @available(iOS 16.0, *)
    @IBAction func registerNewPasskey(_ sender: Any) {
        print("registerNewPasskey")
        guard let window = view.window else { fatalError("The view was not in the app's view hierarchy!") }
        guard let authToken else {
            print("not logged in")
            return
        }
        AppDelegate.reachfive()
            .getProfile(authToken: authToken)
            .onSuccess { profile in
                
                let friendlyName: String
                // here the priority for phone number over email follows the backend rule
                if let phone = profile.phoneNumber {
                    friendlyName = phone
                } else if let email = profile.email {
                    friendlyName = email
                } else {
                    friendlyName = "Should have had an identifier"
                }
                
                let alert = UIAlertController(
                    title: "Register New Passkey",
                    message: "Name the passkey",
                    preferredStyle: .alert
                )
                // init the text field with the profile's identifier
                alert.addTextField { field in
                    field.text = friendlyName
                }
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                let registerAction = UIAlertAction(title: "Add", style: .default) { [unowned alert] (_) in
                    let textField = alert.textFields?[0]
                    
                    AppDelegate.reachfive().registerNewPasskey(withRequest: NewPasskeyRequest(anchor: window, friendlyName: textField?.text ?? friendlyName), authToken: authToken)
                        .onSuccess { _ in
                            self.reloadCredentials(authToken: authToken)
                        }
                        .onFailure { error in
                            switch error {
                            case .AuthCanceled: return
                            default:
                                let alert = AppDelegate.createAlert(title: "Register New Passkey", message: "Error: \(error.message())")
                                self.present(alert, animated: true)
                            }
                        }
                }
                alert.addAction(registerAction)
                alert.preferredAction = registerAction
                self.present(alert, animated: true)
            }
    }
    
    private func format(date: Int) -> String {
        let lastLogin = Date(timeIntervalSince1970: TimeInterval(date / 1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        dateFormatter.locale = Locale(identifier: "en_GB")
        return dateFormatter.string(from: lastLogin)
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        AppDelegate.reachfive().logout()
            .onComplete { result in
                AppDelegate.storage.clear(key: SecureStorage.authKey)
                self.navigationController?.popViewController(animated: true)
            }
    }
}

extension ProfileController: UITableViewDelegate {
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProfileController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = credentialTableview.dequeueReusableCell(withIdentifier: "credentialCell") else {
            fatalError("No credentialCell cell")
        }
        
        let friendlyName = devices[indexPath.row].friendlyName
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = friendlyName
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = friendlyName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let authToken else { return }
            let element = devices[indexPath.row]
            AppDelegate.reachfive().deleteWebAuthnRegistration(id: element.id, authToken: authToken)
                .onSuccess { _ in
                    self.devices.remove(at: indexPath.row)
                    print("did remove passkey \(element.friendlyName)")
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                .onFailure { error in print(error.message()) }
        }
    }
}
