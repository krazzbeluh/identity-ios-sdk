import Foundation
import BrightFutures

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
    internal var scope: [String] = []
    
    public init(sdkConfig: SdkConfig, providersCreators: Array<ProviderCreator>) {
        self.sdkConfig = sdkConfig
        self.providersCreators = providersCreators
        self.reachFiveApi = ReachFiveApi(sdkConfig: sdkConfig)
    }
            
    public func logout() -> Future<(), ReachFiveError> {
        return self.providers
            .map { $0.logout() }
            .sequence()
            .flatMap { _ in self.reachFiveApi.logout() }
    }
    
    public override var description: String {
        return """
        Config: domain=\(sdkConfig.domain), clientId=\(sdkConfig.clientId)
        Providers: \(providers)
        Scope: \(scope.joined(separator: ""))
        """
    }
}
