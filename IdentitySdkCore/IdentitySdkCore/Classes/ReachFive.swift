import Foundation

enum State {
    case NotInitialazed
    case Initialazed
}

public class ReachFive: NSObject {
    var state: State = .NotInitialazed
    let sdkConfig: SdkConfig
    let providersCreators: Array<ProviderCreator>
    let reachFiveApi: ReachFiveApi
    var providers: [Provider] = []
    
    public static let defaultScope = ["openid", "email", "profile", "phone"]
    
    public init(sdkConfig: SdkConfig, providersCreators: Array<ProviderCreator>) {
        self.sdkConfig = sdkConfig
        self.providersCreators = providersCreators
        self.reachFiveApi = ReachFiveApi(sdkConfig: sdkConfig)
    }
            
    public func logout(authToken: AuthToken, callback: @escaping Callback<Void, ReachFiveError>) {
        for provider in self.providers {
            provider.logout()
        }
        reachFiveApi.logout(authToken: authToken, callback: callback)
    }
    
    public override var description: String {
        return """
        Config: domain=\(sdkConfig.domain), clientId=\(sdkConfig.clientId)
        Providers: \(providers)
        """
    }
}
