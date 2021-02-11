//
//  RedirectionViewController.swift
//  Sandbox
//
//  Created by admin on 11/02/2021.
//  Copyright © 2021 Reachfive. All rights reserved.
//

import UIKit
import SafariServices
import IdentitySdkCore
import BrightFutures

class RedirectionViewController: UIViewController, SFSafariViewControllerDelegate
 {
       let pkce: Pkce? = UserDefaultsStorage().take(key: "PASSWORDLESS_PKCE")
       var url = String()
       private let notificationName = Notification.Name("AuthCallbackNotification")
       private var safariViewController: SFSafariViewController? = nil
       private var promise: Promise<AuthToken, ReachFiveError>?
       var name: String = "webview"
     
    override func viewDidLoad() {
        super.viewDidLoad()
        login(
            viewController: self
        )
        .onComplete { result in
            self.handleResult(result: result)
        }
    }
    public func login(
           viewController: UIViewController?
       ) -> Future<AuthToken, ReachFiveError> {
           self.promise?.tryFailure(.AuthCanceled)
           let promise = Promise<AuthToken, ReachFiveError>()
           self.promise = promise
           
           NotificationCenter.default.addObserver(self, selector: #selector(handleLogin(_:)), name: self.notificationName, object: nil)
           
           self.safariViewController = SFSafariViewController.init(url: URL(string: url)!)
           self.safariViewController?.delegate = self
           viewController?.present(safariViewController!, animated: true)
           return promise.future
       }
    
    
    @objc func handleLogin(_ notification : Notification) {
           NotificationCenter.default.removeObserver(self, name: self.notificationName, object: nil)
           
           let url = notification.object as? URL
           if let query = url?.query {
               let params = QueryString.parseQueriesStrings(query: query)
               let code = params["code"]
               if code != nil {
                   self.handleAuthCode(code!!)
               } else {
                   self.promise?.failure(.TechnicalError(reason: "No authorization code"))
               }
           } else {
               self.promise?.failure(.TechnicalError(reason: "No authorization code"))
           }           
           self.safariViewController?.dismiss(animated: true, completion: nil)
       }
    
    private func handleAuthCode(_ code: String) {
         
           
        AppDelegate.reachfive().authWithCode(code: code,pkce: self.pkce!)
               .onSuccess { authToken in
                   self.promise?.success(authToken)
               }
               .onFailure { error in
                   self.promise?.failure(error)
               }
       }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
          NotificationCenter.default.removeObserver(self, name: self.notificationName, object: nil)
          controller.dismiss(animated: true, completion: nil)
      }
      
      public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
          if let sourceApplication = options[.sourceApplication] {
              if (String(describing: sourceApplication) == "com.apple.SafariViewService") {
                  NotificationCenter.default.post(name: self.notificationName, object: url)
                  return true
              }
          }
          
          return false
      }
      
      func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
          return true
      }
      
      public func applicationDidBecomeActive(_ application: UIApplication) {
          
      }
      
      public func logout() -> Future<(), ReachFiveError> {
          return Future.init(value: ())
      }
    
    func handleResult(result: Result<AuthToken, ReachFiveError>) {
        switch result {
        case .success(let authToken):
            goToProfile(authToken)
        case .failure(let error):
            print(error)
        }
    }
    
    func goToProfile(_ authToken: AuthToken) {
        AppDelegate.storage.save(key: AppDelegate.authKey, value: authToken)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profileController = storyBoard.instantiateViewController(
            withIdentifier: "ProfileScene"
        ) as! ProfileController
        profileController.authToken = authToken
        self.self.navigationController?.pushViewController(profileController, animated: true)
    }
   
}
