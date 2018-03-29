//
//  YTViewModelType.swift
//  YTRxSwiftNewsDemo
//
//  Created by tangyin on 08/03/2018.
//  Copyright © 2018 ytang. All rights reserved.
//

import Foundation
import ObjectMapper

protocol YTViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform<T: BaseMappable>(intput:Input, modelType:T.Type) -> Output;
}
