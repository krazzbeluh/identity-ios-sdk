import Foundation
import ObjectMapper

public class LoginSummary: NSObject, ImmutableMappable {
    public let firstLogin: Int?
    public let lastLogin: Int?
    public let total: Int?
    public let origins: [String]?
    public let devices: [String]?
    public let lastProvider: String?
    
    public init(
        firstLogin: Int?,
        lastLogin: Int?,
        total: Int?,
        origins: [String]?,
        devices: [String]?,
        lastProvider: String?
        ) {
        self.firstLogin = firstLogin
        self.lastLogin = lastLogin
        self.total = total
        self.origins = origins
        self.devices = devices
        self.lastProvider = lastProvider
    }
    
    public required init(map: Map) throws {
        firstLogin = try? map.value("first_login")
        lastLogin = try? map.value("last_login")
        total = try? map.value("total")
        origins = try? map.value("origins")
        devices = try? map.value("devices")
        lastProvider = try? map.value("last_provider")
    }
    
    public func mapping(map: Map) {
        firstLogin >>> map["first_login"]
        lastLogin >>> map["last_login"]
        total >>> map["total"]
        origins >>> map["origins"]
        devices >>> map["devices"]
        lastProvider >>> map["last_provider"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}
