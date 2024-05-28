//
//  Film.swift
//  CodableVSClassicalJSONFetch
//
//  Created by Andrei Ionescu on 28.05.2024.
//

import Foundation

struct Film: Hashable, Codable {
    var title: String
    var year: String
    var rated: String
    var runtime: String
    var genre: String
    var releaseDate: String?
    var country1: String
    var country2: String?
    var country: [String: String]

    enum CodingKeys: String, CodingKey {
        case title
        case year
        case rated
        case runtime
        case genre
        case releaseDate = "released"
        case country
    }
    
    enum CountryKeys: String, CodingKey {
        case country1
        case country2
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try values.decode(String.self, forKey: .title)
        year = try values.decode(String.self, forKey: .year)
        rated = try values.decode(String.self, forKey: .rated)
        runtime = try values.decode(String.self, forKey: .runtime)
        genre = try values.decode(String.self, forKey: .genre)
        releaseDate = try values.decode(String.self, forKey: .releaseDate)
        country = try values.decode([String: String].self, forKey: .country)

        let country = try values.nestedContainer(keyedBy: CountryKeys.self, forKey: .country)
        
        country1 = try country.decode(String.self, forKey: .country1)
        if self.country.count > 1 {
            country2 = try country.decode(String.self, forKey: .country2)
        }
    }
}

struct Films: Codable {
    var films: [Film]
}
