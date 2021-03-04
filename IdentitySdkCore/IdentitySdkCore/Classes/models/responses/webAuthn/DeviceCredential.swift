//
//  DeviceCredential.swift
//  IdentitySdkCore
//
//  Created by admin on 04/03/2021.
//  Copyright © 2021 Reachfive. All rights reserved.
//

import Foundation

public class DeviceCredential: Codable, DictionaryEncodable {
    public let friendlyName: String
    public let id: String
   
    
    public init(friendlyName: String, id: String) {
        self.friendlyName = friendlyName
        self.id = id
    }
    
}

