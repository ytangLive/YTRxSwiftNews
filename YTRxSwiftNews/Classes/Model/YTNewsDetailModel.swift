//
//  YTNewsDetailModel.swift
//  YTRxSwiftNewsDemo
//
//  Created by tangyin on 20/03/2018.
//  Copyright © 2018 ytang. All rights reserved.
//

import UIKit
import ObjectMapper

struct YTNewsDetailModel: Mappable{
    
    var body: String?
    var ga_prefix: String?
    var id: Int?
    var image: String?
    var image_source: String?
    var share_url: String?
    var title: String?
    var type: Int?
    var images: [String]?
    var css: [String]?
    var js: [String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        body <- map["body"]
        ga_prefix <- map["ga_prefix"]
        id <- map["id"]
        image <- map["image"]
        image_source <- map["image_source"]
        share_url <- map["share_url"]
        title <- map["title"]
        type <- map["type"]
        images <- map["images"]
        css <- map["css"]
        js <- map["js"]
    }
}
