//
//  YTRefreshView.swift
//  YTRxSwiftNewsDemo
//
//  Created by tangyin on 19/03/2018.
//  Copyright © 2018 ytang. All rights reserved.
//

import UIKit

class YTRefreshView: UIView {
    
    let circleLayer = CAShapeLayer()
    
    let indicatorView = UIActivityIndicatorView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
    }
    
    fileprivate var refreshing = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        creatCircleLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleLayer.position = CGPoint(x: frame.width/2, y: frame.height/2)
        indicatorView.center = CGPoint(x: frame.width/2, y: frame.height/2)
    }
    
    func creatCircleLayer() {
        circleLayer.path = UIBezierPath(arcCenter: CGPoint(x: 8, y: 8), radius: 8, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi / 2  + Double.pi  * 2), clockwise: true).cgPath
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 1.0
        circleLayer.lineCap = kCALineCapRound
        circleLayer.bounds = CGRect(x: 0, y: 0, width: 16, height: 16)
        circleLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        layer.addSublayer(circleLayer)
        
    }
}


extension YTRefreshView {
    func pullToRefresh(progress:CGFloat) {
        circleLayer.strokeEnd = progress
    }
    
    func beginRefresh(begin: @escaping() -> Void) {
        if refreshing {
            return
        }
        refreshing = true
        circleLayer.removeFromSuperlayer()
        addSubview(indicatorView)
        indicatorView.startAnimating()
        begin()
    }
    
    func endRefresh(){
        refreshing = false
        indicatorView.stopAnimating()
        indicatorView.removeFromSuperview()
    }
    
    func resetLayer(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.creatCircleLayer()
        }
    }
}
