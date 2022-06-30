//
//  Cities.swift
//  Weather
//
//  Created by MacOne-YJ4KBJ on 17/06/2022.
//

import Foundation
struct Cities: Codable{
    let displayName: String
    let lat : String
    let lon : String

    enum CodingKeys: String, CodingKey {
        case lat, lon
        case displayName = "display_name"
    }
}
