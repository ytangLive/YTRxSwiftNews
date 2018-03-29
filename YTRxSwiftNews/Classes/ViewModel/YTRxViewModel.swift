//
//  YTRxViewModel.swift
//  YTRxSwiftNewsDemo
//
//  Created by tangyin on 09/03/2018.
//  Copyright © 2018 ytang. All rights reserved.
//

import Foundation
import RxSwift
import NSObject_Rx
import ObjectMapper

class YTRxViewModel: NSObject, YTViewModelType {
    
    typealias Input = RxInput
    
    typealias Output = RxOutput
    
    struct RxInput {
        let category : YTNetworkTool
        
        init(category:YTNetworkTool) {
            self.category = category
        }
    }
    
    struct RxOutput {
        let model = Variable<Any>((Any.self))
    }
    
    func transform<T: BaseMappable>(intput: YTRxViewModel.RxInput, modelType:T.Type) -> YTRxViewModel.RxOutput {
        
        let output = RxOutput()
        
        rxNetTool.request(intput.category).mapObject(T.self).subscribe(
            onSuccess: { (model) in
            output.model.value = model
        }) { (error) in
            RxProgressHUD.showError(error.localizedDescription)
        }.addDisposableTo(rx.disposeBag)
        
        return output
    }
}
