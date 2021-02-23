//
//  CredentialCreationOptions.swift
//  IdentitySdkCore
//
//  Created by admin on 11/01/2021.
//  Copyright © 2021 Reachfive. All rights reserved.
//

import Foundation

public class CredentialCreationOptions: Codable, DictionaryEncodable {
    public let publicKey: R5PublicKeyCredentialCreationOptions

    public init(publicKey: R5PublicKeyCredentialCreationOptions) {
        self.publicKey = publicKey
        
    }
}
