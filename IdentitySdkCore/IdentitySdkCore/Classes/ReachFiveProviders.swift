import Foundation

public extension ReachFive {
    func getProvider(name: String) -> Provider? {
        return providers.first(where: { $0.name == name })
    }
    
    func getProviders() -> [Provider] {
        return providers
    }
    
    func initialize(callback: @escaping Callback<[Provider], ReachFiveError>) {
        switch self.state {
        case .NotInitialazed:
            reachFiveApi.clientConfig(callback: { configResult in
                configResult.map({ clientConfig in
                    self.scope = clientConfig.scope.components(separatedBy: " ")

                    self.reachFiveApi.providersConfigs(callback: { result in
                        callback(result.map({ providersConfigs in
                            let providers = self.createProviders(providersConfigsResult: providersConfigs)
                            self.providers = providers
                            self.state = .Initialazed
                            return providers
                        }))
                    })
                })
            })
        case .Initialazed:
            callback(.success(self.providers))
        }
    }
    
    func initialize() {
        self.initialize(callback: { _ in })
    }
    
    private func createProviders(providersConfigsResult: ProvidersConfigsResult) -> [Provider] {
        let webViewProvider = providersCreators.first(where: { $0.name == "webview" })
        return providersConfigsResult.items.map({ config in
            let nativeProvider = providersCreators.first(where: { $0.name == config.provider })
            if (nativeProvider != nil) {
                return nativeProvider?.create(sdkConfig: sdkConfig, providerConfig: config, reachFiveApi: reachFiveApi)
            } else if (webViewProvider != nil) {
                return webViewProvider?.create(sdkConfig: sdkConfig, providerConfig: config, reachFiveApi: reachFiveApi)
            } else {
                return nil
            }
        }).compactMap { $0 }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        for provider in providers {
            let _ = provider.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        for provider in providers {
            let _ = provider.application(app, open: url, options: options)
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        for provider in providers {
            let _ = provider.applicationDidBecomeActive(application)
        }
    }
}
