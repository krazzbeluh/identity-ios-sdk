//
//  RegistrationOptions.swift
//  IdentitySdkCore
//
//  Created by admin on 11/01/2021.
//  Copyright © 2021 Reachfive. All rights reserved.
//

import Foundation

public class RegistrationOptions: Codable, DictionaryEncodable {
    public let friendlyName: String
    public let options: CredentialCreationOptions
   
    
    public init(friendlyName: String, options: CredentialCreationOptions) {
        self.friendlyName = friendlyName
        self.options = options
    }
    
}
