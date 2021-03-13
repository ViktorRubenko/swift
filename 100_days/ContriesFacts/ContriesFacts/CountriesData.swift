//
//  CountriesData.swift
//  ContriesFacts
//
//  Created by Victor Rubenko on 13.03.2021.
//

import Foundation


struct CountriesData {
    var countries = [Country]()
    
    init() {
        guard let url = URL(string: "https://restcountries.eu/rest/v2/all?fields=name;alpha2Code;capital;population;demonym;area;nativeName;currencies;languages;flag") else { return }
        if let data = try? Data(contentsOf: url) {
            let jsonDecoder = JSONDecoder()
            guard let countries_list = try? jsonDecoder.decode([Country].self, from: data) else {
                print("Failed to load countries.")
                return
            }
            countries = countries_list
        }
    }
}
