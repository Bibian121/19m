//
//  Item.swift
//  19m
//
//  Created by Matilda Davydov on 28.10.2022.
//

import Foundation

struct Item: Codable {
    let birth : Int?
    let occupation : String?
    let name : String?
    let lastname : String?
    let country : String?
    
    private enum CodingKeys: String, CodingKey {
        case birth = "birth"
        case occupation = "occupation"
        case name = "name"
        case lastname = "lastname"
        case country = "country"
    }
    
    init(birth:Int,occupation:String,name:String,lastname:String,country:String) {
        self.birth = birth
        self.occupation = occupation
        self.name = name
        self.lastname = lastname
        self.country = country
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let birth = try container.decode(Int.self, forKey: .birth)
        let occupation = try container.decode(String.self, forKey: .occupation)
        let name = try container.decode(String.self, forKey: .name)
        let lastname = try container.decode(String.self, forKey: .lastname)
        let country = try container.decode(String.self, forKey: .country)
        self.init(birth: birth, occupation: occupation, name: name, lastname: lastname, country: country)
    }
    
    public func encode(to encoder: Encoder) throws {
        var contrainer = encoder.container(keyedBy: CodingKeys.self)
        try contrainer.encode(birth, forKey: .birth)
        try contrainer.encode(occupation, forKey: .occupation)
        try contrainer.encode(name, forKey: .name)
        try contrainer.encode(lastname, forKey: .lastname)
        try contrainer.encode(country, forKey: .country)
    }

}

