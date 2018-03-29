//
//  RxProgressHUD.swift
//  RxSwiftDemo
//
//  Created by tangyin on 06/03/2018.
//  Copyright © 2018 ytang. All rights reserved.
//

import Foundation
import SVProgressHUD

enum HUDType {
     case success
     case error
     case loading
     case info
     case progress
}

class RxProgressHUD: NSObject {
     class func initRxProgressHUD() {
          SVProgressHUD.setFont(UIFont.systemFont(ofSize: 14.0))
          SVProgressHUD.setDefaultMaskType(.none)
          SVProgressHUD.setMinimumDismissTimeInterval(1.5)
     }
     
     class func showSuccess(_ status: String) {
          self.showRxProgressHUD(type: .success, status: status)
     }
     class func showError(_ status: String) {
          self.showRxProgressHUD(type: .error, status: status)
     }
     class func showLoading(_ status: String) {
          self.showRxProgressHUD(type: .loading, status: status)
     }
     class func showInfo(_ status: String) {
          self.showRxProgressHUD(type: .info, status: status)
     }
     class func showProgress(_ status: String, _ progress: CGFloat) {
          self.showRxProgressHUD(type: .success, status: status, progress: progress)
     }
     class func dismissHUD(_ delay: TimeInterval = 0) {
          SVProgressHUD.dismiss(withDelay: delay)
     }
}

extension RxProgressHUD {
     class func showRxProgressHUD(type:HUDType, status: String, progress: CGFloat = 0) {
          switch type {
          case .success:
               SVProgressHUD.showSuccess(withStatus: status)
          case .error:
               SVProgressHUD.showError(withStatus: status)
          case .loading:
               SVProgressHUD.show(withStatus: status)
          case .info:
               SVProgressHUD.showInfo(withStatus: status)
          case .progress:
               SVProgressHUD.showProgress(Float(progress), status: status)
          }
     }
}
