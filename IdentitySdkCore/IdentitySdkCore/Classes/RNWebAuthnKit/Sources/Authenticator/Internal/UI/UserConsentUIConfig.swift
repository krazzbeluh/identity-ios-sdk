import Foundation
import LocalAuthentication

public class UserConsentUIConfig {
    
    public var excludeKeyFoundPopupTitle: String = "Key Already Exists"
    public var excludeKeyFoundPopupMessage: String = "Force to create new key?"
    public var excludeKeyFoundPopupCancelButtonText: String = "Cancel"
    public var excludeKeyFoundPopupCreateButtonText: String = "Create"

    public var keyCreationTitle: String = "New Login Key"
    public var keyCreationCancelButtonText: String = "Cancel"
    public var keyCreationCreateButtonText: String = "Create"

    public var keySelectionTitle: String = "Confirm Account"
    public var keySelectionCancelButtonText: String = "Cancel"
    public var keySelectionSelectButtonText: String = "Confirm"
    
    public var showRPInformation: Bool = true
    public var alwaysShowKeySelection: Bool = false
    public var requireBiometrics: Bool = false

    public init() {}
    
    public var localAuthPolicy: LAPolicy {
        get {
            return self.requireBiometrics ?
                .deviceOwnerAuthenticationWithBiometrics :
                .deviceOwnerAuthentication
        }
    }

}
