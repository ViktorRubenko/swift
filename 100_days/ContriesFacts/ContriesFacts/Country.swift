//
//  Country.swift
//  ContriesFacts
//
//  Created by Victor Rubenko on 13.03.2021.
//

import Foundation


struct Country: Codable {
    let flag: String
    let name: String
    let alpha2Code: String
    let capital: String
    let population: Int
    let demonym: String
    let area: Float?
    let nativeName: String
    let currencies: [Currency]
    let languages: [Language]
}

struct Currency: Codable {
    let code: String?
    let name: String?
    let symbol: String?
}

struct Language: Codable {
    let iso639_1: String?
    let iso639_2: String
    let name: String
    let nativeName: String
}
