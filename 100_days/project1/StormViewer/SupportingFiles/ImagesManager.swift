//
//  ImagesManager.swift
//  
//
//  Created by Victor Rubenko on 24.02.2021.
//

import Foundation


class ImagesManager {
    private let fileManeger = FileManager.default
    private let path = Bundle.main.resourcePath!
    private lazy var items = try! fileManeger.contentsOfDirectory(atPath: path)
    var images: [String] {
        return items.filter( { $0.hasSuffix(".jpg") } )
    }
}
