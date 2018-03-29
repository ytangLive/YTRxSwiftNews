//
//  Response+ObjectMapper.swift
//  YTRxSwiftNewsDemo
//
//  Created by tangyin on 09/03/2018.
//  Copyright © 2018 ytang. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

extension Response {
    func mapObject<T: BaseMappable>(_ type: T.Type) throws -> T {
        guard let object = Mapper<T>().map(JSONObject: try mapJSON()) else {
             throw MoyaError.jsonMapping(self)
        }
        
        return object
    }
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    func mapObject<T: BaseMappable>(_ type:T.Type) -> Single<T> {
        return flatMap({ (response) -> Single<T> in
            return Single.just(try response.mapObject(T.self))
        })
    }
}
