//
//  GalleryModels.swift
//  PixbayApp
//
//  Created by D2k on 16/12/20.
//

import Foundation

//MARK:- Gallery
struct Gallery: Codable {
    let total: Int?
    let hits: [Photo]?

    enum CodingKeys: String, CodingKey {
        case total = "total"
        case hits = "hits"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        hits = try values.decodeIfPresent([Photo].self, forKey: .hits)
    }
}

//MARK:- Photo
struct Photo : Codable {
    let previewURL : String?
    let largeImageURL : String?
    let imageWidth : Int?
    let imageHeight : Int?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        previewURL = try values.decodeIfPresent(String.self, forKey: .previewURL)
        largeImageURL = try values.decodeIfPresent(String.self, forKey: .largeImageURL)
        imageWidth = try values.decodeIfPresent(Int.self, forKey: .imageWidth)
        imageHeight = try values.decodeIfPresent(Int.self, forKey: .imageHeight)
    }

}

