import Foundation
import BrightFutures

enum State {
    case NotInitialized
    case Initialized
}

public typealias PasswordlessCallback = (_ result: Result<AuthToken, ReachFiveError>) -> Void

/// ReachFive identity SDK
public class ReachFive: NSObject {
    let notificationPasswordlessName = Notification.Name("PasswordlessNotification")
    var passwordlessCallback: PasswordlessCallback? = nil
    var state: State = .NotInitialized
    let sdkConfig: SdkConfig
    let providersCreators: Array<ProviderCreator>
    let reachFiveApi: ReachFiveApi
    var providers: [Provider] = []
    internal var scope: [String] = []
    internal let storage: Storage
    
    public init(sdkConfig: SdkConfig, providersCreators: Array<ProviderCreator>, storage: Storage?) {
        self.sdkConfig = sdkConfig
        self.providersCreators = providersCreators
        self.reachFiveApi = ReachFiveApi(sdkConfig: sdkConfig)
        self.storage = storage ?? UserDefaultsStorage()
    }
    
    public func logout() -> Future<(), ReachFiveError> {
        return self.providers
            .map { $0.logout() }
            .sequence()
            .flatMap { _ in self.reachFiveApi.logout() }
    }
    
    public func refreshAccessToken(authToken: AuthToken) -> Future<AuthToken, ReachFiveError> {
        let refreshRequest = RefreshRequest(
            clientId: sdkConfig.clientId,
            refreshToken: authToken.refreshToken ?? "",
            redirectUri: sdkConfig.scheme
        )
        return reachFiveApi
            .refreshAccessToken(refreshRequest)
            .flatMap({ AuthToken.fromOpenIdTokenResponseFuture($0) })
    }
    
    public override var description: String {
        return """
            Config: domain=\(sdkConfig.domain), clientId=\(sdkConfig.clientId)
            Providers: \(providers)
            Scope: \(scope.joined(separator: ""))
        """
    }
}
