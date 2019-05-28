//
//  Todo.swift
//  PUTandPOST(iOSPT1)
//
//  Created by Dongwoo Pae on 5/27/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

struct Todo: Codable {
    var title: String
    var identifier: String
    
    init(title:String, identifier: String = UUID().uuidString)  {  // this is going to create a new identifier everytime we do put to update API
        self.title = title
        self.identifier = identifier
    }
}
