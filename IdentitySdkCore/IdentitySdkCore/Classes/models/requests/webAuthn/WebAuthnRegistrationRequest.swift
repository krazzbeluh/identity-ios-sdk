//
//  WebAuthnRegistrationRequest.swift
//  IdentitySdkCore
//
//  Created by admin on 11/01/2021.
//  Copyright © 2021 Reachfive. All rights reserved.
//

import Foundation

public class WebAuthnRegistrationRequest: Codable, DictionaryEncodable {
    public let origin: String
    public let friendlyName: String
    public let profile: ProfileWebAuthnSignupRequest?
    public let clientId: String?
    
    public init(origin: String, friendlyName: String, profile: ProfileWebAuthnSignupRequest?,clientId: String?) {
        self.origin = origin
        self.friendlyName = friendlyName
        self.profile = profile
        self.clientId = clientId
    }
}
