//
//  YTNetworkTool.swift
//  YTRxSwiftNewsDemo
//
//  Created by tangyin on 08/03/2018.
//  Copyright © 2018 ytang. All rights reserved.
//

import Foundation
import Moya

let rxNetTool = RxMoyaProvider<YTNetworkTool>()

enum YTNetworkTool {
    case getLaunchImg
    case getNewsList
    case getMoreNews(String)
    case getThemeList
    case getThemeDesc(Int)
    case getNewsDesc(Int)
}

extension YTNetworkTool :  TargetType{
    var baseURL: URL {
        return URL(string: "http://news-at.zhihu.com/api/")!
    }
    
    var path: String {
        switch self {
        case .getLaunchImg:
            return "7/prefetch-launch-images/750*1142"
        case .getNewsList:
            return "4/news/latest"
        case .getMoreNews(let date):
            return "4/news/before/" + date
        case .getThemeList:
            return "4/themes"
        case .getThemeDesc(let id):
            return "4/theme/\(id)"
        case .getNewsDesc(let id):
            return "4/news/\(id)"
        }

    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
