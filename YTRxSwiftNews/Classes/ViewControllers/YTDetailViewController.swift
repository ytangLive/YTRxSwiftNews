//
//  YTDetailViewController.swift
//  YTRxSwiftNewsDemo
//
//  Created by tangyin on 20/03/2018.
//  Copyright © 2018 ytang. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import Kingfisher
import RxCocoa

class YTDetailViewController: UIViewController {
    
    var webview : YTDetailWebView!
    var previousWeb : YTDetailWebView!
    var ids = [Int]()
    var previousId = 0
    var nextId = -1
    
    let viewModel = YTRxViewModel()
    
    var id = Int(){
        didSet {
            loadData()
            for (index,elment) in ids.enumerated() {
                if(id == elment){
                    if(index == 0){
                        previousId = 0
                        nextId = ids[index + 1]
                    }else if(index == ids.count - 1){
                        nextId = -1
                        previousId = ids[index - 1]
                    }else{
                        previousId = ids[index - 1]
                        nextId = ids[index + 1]
                    }
                    break;
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webview = YTDetailWebView.init(frame: view.bounds)
        webview.delegate = self
        webview.scrollView.delegate = self
        view.addSubview(webview)
        
        previousWeb = YTDetailWebView.init(frame: CGRect(x: 0, y: screenH, width: screenW, height: screenH))
        view.addSubview(previousWeb)
        
        setUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }

}

extension YTDetailViewController {
    func loadData() {
        let vmInput = YTRxViewModel.Input(category: .getNewsDesc(id))
        let vmOutput = viewModel.transform(intput: vmInput, modelType: YTNewsDetailModel.self)
        vmOutput.model.asObservable().subscribe(onNext: { (model) in
            if model is YTNewsDetailModel {
                let detailModel = model as! YTNewsDetailModel
                if let image = detailModel.image {
                    self.webview.imgView.kf.setImage(with: URL.init(string: image))
                    self.webview.titleLab.text = detailModel.title
                }else{
                    self.webview.imgView.isHidden = true
                    self.webview.previousLab.textColor = UIColor.colorFromHex(0x777777)
                }
                if let imageSource = detailModel.image_source {
                    self.webview.imgLab.text = "图片: " + imageSource
                }
                
                if (detailModel.title?.count)! > 16 {
                    self.webview.titleLab.frame = CGRect.init(x: 15, y: 120, width: screenW - 30, height: 55)
                }
                
                OperationQueue.main.addOperation {
                    self.webview.loadHTMLString(self.concatHTML(css: detailModel.css!, body: detailModel.body!), baseURL: nil)
                }
                
            }
        }).addDisposableTo(rx.disposeBag)
    }
    
    private func concatHTML(css:[String], body:String) -> String {
        var html = "<html>"
        html += "<head>"
        css.forEach {
            html += "<link rel=\"stylesheet\" href=\($0)>"
        }
        html += "<style>img{max-width:320px !important;}</style>"
        html += "</head>"
        html += "<body>"
        html += body
        html += "</body>"
        html += "</html>"
        return html
    }
    
    func setUI() {
        if previousId == 0 {
            webview.previousLab.text = "已经是第一篇了"
        } else {
            webview.previousLab.text = "载入上一篇"
        }
        if nextId == -1 {
            webview.nextLab.text = "已经是最后一篇了"
        } else {
            webview.nextLab.text = "载入下一篇"
        }
    }
    
    func changeWebview(_ newsId:Int) {
        webview.removeFromSuperview()
        previousWeb.delegate = self
        previousWeb.scrollView.delegate = self
        webview = previousWeb
        self.id = newsId
        previousWeb = YTDetailWebView(frame: CGRect(x: 0, y: -screenH, width: screenW, height: screenH))
        view.addSubview(previousWeb)
    }
}
    
extension YTDetailViewController : UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        webview.imgView.frame.origin.y = scrollView.contentOffset.y
        webview.imgView.frame.size.height = 200 - scrollView.contentOffset.y
        webview.maskImg.frame = CGRect(x: 0, y: webview.imgView.frame.size.height - 100, width:screenW , height: 100)
        
        if scrollView.contentOffset.y > 180 {
            UIApplication.shared.statusBarStyle = .default
        }else{
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y <= -60 {
            if previousId > 0 {
                previousWeb.frame = CGRect(x: 0, y: -screenH, width: screenW, height: screenH)
                UIView.animate(withDuration: 0.3, animations: {
                    self.previousWeb.transform = CGAffineTransform.init(translationX: 0, y: screenH)
                    self.webview.transform = CGAffineTransform.init(translationX: 0, y: screenH)
                }, completion: { (state) in
                    if state {
                        self.changeWebview(self.previousId)
                    }
                })
            }
        }
        
        if scrollView.contentOffset.y - 50 + screenH >= scrollView.contentSize.height {
            if nextId > 0 {
                previousWeb.frame = CGRect(x: 0, y: screenH, width: screenW, height: screenH)
                UIView.animate(withDuration: 0.3, animations: {
                    self.previousWeb.transform = CGAffineTransform.init(translationX: 0, y: -screenH)
                    self.webview.transform = CGAffineTransform.init(translationX: 0, y: -screenH)
                }, completion: { (state) in
                    if state {
                        self.changeWebview(self.nextId)
                    }
                })
            }
        }
    }
}

extension YTDetailViewController : UIWebViewDelegate
{
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webview.waitView.removeFromSuperview()
        webview.nextLab.frame = CGRect.init(x: 15, y: self.webview.scrollView.contentSize.height + 10, width: screenW - 30, height: 20)
    }
}





