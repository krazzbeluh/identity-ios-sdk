//
//  R5PublicKeyCredentialRpEntity.swift
//  IdentitySdkCore
//
//  Created by admin on 11/01/2021.
//  Copyright © 2021 Reachfive. All rights reserved.
//

import Foundation

public class R5PublicKeyCredentialRpEntity: Codable, DictionaryEncodable {
    public var id: String
    public var name: String
    
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
