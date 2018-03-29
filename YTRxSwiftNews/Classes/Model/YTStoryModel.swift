//
//  YTStoryModel.swift
//  YTRxSwiftNewsDemo
//
//  Created by tangyin on 19/03/2018.
//  Copyright © 2018 ytang. All rights reserved.
//

import UIKit
import ObjectMapper

struct YTlistModel:Mappable {
    
    var date:String = ""
    var stories:[YTStoryModel] = []
    var top_stories:[YTStoryModel] = []
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        date <- map["date"]
        stories <- map["stories"]
        top_stories <- map["top_stories"]
    }
}

struct YTStoryModel:Mappable {
    
    var images:[String] = []
    var type:Int = 0
    var id: Int = 0
    var ga_prefix: String = ""
    var title: String = ""
    var topImage: String = "" //top_stories
    var multipic = false
    
    init?(map:Map) {
        
    }
    
    mutating func mapping(map: Map) {
        images <- map["images"]
        type <- map["type"]
        id <- map["id"]
        ga_prefix <- map["ga_prefix"]
        title <- map["title"]
        topImage <- map["image"]
        multipic <- map["multipic"]
    }
}
