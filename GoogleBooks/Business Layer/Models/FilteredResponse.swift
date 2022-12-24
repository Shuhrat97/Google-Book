//
//  FilteredResponse.swift
//  GoogleBooks
//
//  Created by Shuhrat Nurov on 24/12/22.
//

import Foundation

//{
// "kind": "books#volumes",
// "items": [
//  {
//   "kind": "books#volume",
//   "id": "_ojXNuzgHRcC",
//   "etag": "OTD2tB19qn4",
//   "selfLink": "https://www.googleapis.com/books/v1/volumes/_ojXNuzgHRcC",
//   "volumeInfo": {
//    "title": "Flowers",
//    "authors": [
//     "Vijaya Khisty Bodach"
//    ],
//   ...
//  },
//  {
//   "kind": "books#volume",
//   "id": "RJxWIQOvoZUC",
//   "etag": "NsxMT6kCCVs",
//   "selfLink": "https://www.googleapis.com/books/v1/volumes/RJxWIQOvoZUC",
//   "volumeInfo": {
//    "title": "Flowers",
//    "authors": [
//     "Gail Saunders-Smith"
//    ],
//    ...
//  },
//  {
//   "kind": "books#volume",
//   "id": "zaRoX10_UsMC",
//   "etag": "pm1sLMgKfMA",
//   "selfLink": "https://www.googleapis.com/books/v1/volumes/zaRoX10_UsMC",
//   "volumeInfo": {
//    "title": "Flowers",
//    "authors": [
//     "Paul McEvoy"
//    ],
//    ...
//  },
//  "totalItems": 3
//}

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
    
    struct ImageLinks:Codable{
        let smallThumbnail:String
        let thumbnail:String
    }
}


