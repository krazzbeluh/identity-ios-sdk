//
//  R5AuthenticatorSelectionCriteria.swift
//  IdentitySdkCore
//
//  Created by admin on 11/01/2021.
//  Copyright © 2021 Reachfive. All rights reserved.
//

import Foundation

public class R5AuthenticatorSelectionCriteria: Codable, DictionaryEncodable {
    public var authenticatorAttachment: String
    public var requireResidentKey: Bool
    public var residentKey: String
    public var userVerification: String
    
    public init(authenticatorAttachment: String, requireResidentKey: Bool, residentKey: String,userVerification: String) {
        self.authenticatorAttachment = authenticatorAttachment
        self.residentKey = residentKey
        self.requireResidentKey = requireResidentKey
        self.userVerification = userVerification
    }
}
