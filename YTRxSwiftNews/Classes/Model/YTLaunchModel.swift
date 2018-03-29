//
//  YTLaunchModel.swift
//  YTRxSwiftNewsDemo
//
//  Created by tangyin on 09/03/2018.
//  Copyright © 2018 ytang. All rights reserved.
//

import UIKit
import ObjectMapper

struct YTLaunchModel:Mappable {
    var creatives:[YTLaunchModelImg]?
        
    init?(map:Map) {
            
    }
        
    mutating func mapping(map: Map) {
        creatives <- map["creatives"]
    }
}

struct YTLaunchModelImg:Mappable {
    var url: String = ""
    
    init?(map:Map) {
        
    }
    
    mutating func mapping(map: Map) {
        url <- map["url"]
    }
}
