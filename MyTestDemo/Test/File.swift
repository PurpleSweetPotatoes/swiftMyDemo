//
//  File.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2024/6/13.
//  Copyright © 2024 Garmin All rights reserved
//  

import Foundation


struct ActivityTypeDTO: Codable {
    let typeId: Int?
    let typeKey: String
    let parentTypeId: Int?
    let isHidden: Bool?
    let restricted: Bool?
    let trimmable: Bool?
}

struct AccessControlRuleDTO: Codable {
    let typeId: Int
    let typeKey: String
}
