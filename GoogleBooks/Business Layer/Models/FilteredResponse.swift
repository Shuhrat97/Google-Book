//
//  FilteredResponse.swift
//  GoogleBooks
//
//  Created by Shuhrat Nurov on 24/12/22.
//

import Foundation

struct FilterResponse:Codable{
    let kind:String
    let items:[Book]
    let totalItems:Int
}

struct Book:Codable{
    let kind:String
    let id:String
    let etag:String
    let selfLink:String
    let volumeInfo:VolumeInfo
}

struct VolumeInfo:Codable{
    let title:String
    let authors:[String]?
    let imageLinks:ImageLinks?
    let language:String
    let publishedDate:String
    let description:String?
    let previewLink:String
    
    struct ImageLinks:Codable{
        let smallThumbnail:String
        let thumbnail:String
    }
}
