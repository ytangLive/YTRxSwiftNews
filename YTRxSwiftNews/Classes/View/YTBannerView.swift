//
//  YTBannerView.swift
//  YTRxSwiftNewsDemo
//
//  Created by tangyin on 19/03/2018.
//  Copyright © 2018 ytang. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import Kingfisher

class YTBannerView: UICollectionView {
    
    let imageUrlArr = Variable([YTStoryModel]())
    
    var bannerDelegate:BannerDelegate?
    
    var offY = Variable(0.0)
    
    @IBOutlet weak var layout:UICollectionViewFlowLayout!
    
    override func awakeFromNib() {
        
        contentOffset.x = screenW
        layout.itemSize = CGSize(width: screenW, height: 200)
        
        self.imageUrlArr.asObservable().bind(to: rx.items(cellIdentifier: "YTBannerCollectionCell", cellType: YTBannerCollectionCell.self)){
            row, model, cell in
            cell.img.kf.setImage(with: URL.init(string: model.topImage))
            cell.imgTitle.text = model.title
        }.addDisposableTo(rx.disposeBag)
        
        rx.setDelegate(self).addDisposableTo(rx.disposeBag)
        
        
        offY.asObservable().subscribe(onNext: { (offy) in
            self.visibleCells.forEach({ (cell) in
                let cell = cell as! YTBannerCollectionCell
                cell.img.frame.origin.y = CGFloat.init(offy)
                cell.img.frame.size.height = 200 - CGFloat.init(offy)
            })
        }).addDisposableTo(rx.disposeBag)
        
        rx.modelSelected(YTStoryModel.self).subscribe(onNext: { (storyModel) in
            self.bannerDelegate?.selectedItem(model: storyModel)
        }).addDisposableTo(rx.disposeBag)
    }

}

extension YTBannerView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.imageUrlArr.value.count > 0){
            if scrollView.contentOffset.x >= CGFloat.init(imageUrlArr.value.count - 1) * screenW {
                scrollView.contentOffset.x = screenW
            }else if scrollView.contentOffset.x <  0{
                scrollView.contentOffset.x = CGFloat.init(imageUrlArr.value.count - 2) * screenW
            }
        }
        bannerDelegate?.scrollTo(index: Int(scrollView.contentOffset.x / screenW))
    }
}

protocol BannerDelegate {
    func selectedItem(model: YTStoryModel)
    func scrollTo(index: Int)
}
