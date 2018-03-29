//
//  YTMainViewController.swift
//  YTRxSwiftNewsDemo
//
//  Created by tangyin on 09/03/2018.
//  Copyright © 2018 ytang. All rights reserved.
//

import UIKit
import Kingfisher

class YTMainViewController: UITabBarController {
    
    let launchView = UIImageView()
    let viewModel = YTRxViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setLaunchView()
        
    }
    
    func setLaunchView() {
        launchView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        launchView.alpha = 0.9
        view.addSubview(launchView)
        
        let vmInput = YTRxViewModel.Input(category:.getLaunchImg)
        let vmOutput = viewModel.transform(intput: vmInput, modelType: YTLaunchModel.self)
        vmOutput.model.asObservable().subscribe(onNext: { (model) in
            if model is YTLaunchModel{
                let launchModel = model as! YTLaunchModel
                var url:String?
                if let imgModel = launchModel.creatives?.first {
                    url = imgModel.url
                }else{
                    url = "https://b-ssl.duitang.com/uploads/item/201601/30/20160130165754_WCMTr.png"
                }
                self.launchView.kf.setImage(with: URL.init(string: url!)!, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (_, _, _, _) in
                    
                    UIView.animate(withDuration: 1.5, animations: {
                        self.launchView.alpha = 1.0
                    }, completion: { (_) in
                        UIView.animate(withDuration: 0.5, animations: {
                            self.launchView.alpha = 0
                        }, completion: { (_) in
                            self.launchView.removeFromSuperview()
                        })
                    })
                    
                })
            }
        }).addDisposableTo(rx.disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
