import Foundation
import UIKit

public protocol ProviderCreator {
    var name: String { get }
    func create(sdkConfig: SdkConfig, providerConfig: ProviderConfig, reachFiveApi: ReachFiveApi) -> Provider
}

public protocol Provider {
    var name: String { get }
    func login(scope: [String], origin: String, viewController: UIViewController?, callback: @escaping Callback<AuthToken, ReachFiveError>)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    func applicationDidBecomeActive(_ application: UIApplication)
    func logout()
}
