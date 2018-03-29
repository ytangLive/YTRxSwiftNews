//
//  YTHomeViewController.swift
//  YTRxSwiftNewsDemo
//
//  Created by tangyin on 09/03/2018.
//  Copyright © 2018 ytang. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import Kingfisher
import RxCocoa
import RxDataSources
import SwiftDate
import Then

class YTHomeViewController: UIViewController {

    var barImg = UIView()
    
    let viewModel = YTRxViewModel()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, YTStoryModel>>()
    let dataArr = Variable([SectionModel<String, YTStoryModel>]())
    var newsDate = ""
    let titleNum = Variable(0)
    var refreshView:YTRefreshView?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: YTBannerView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadData()
        setBarUI()
        addRefreshView()
        
        dataSource.configureCell = { (dataSource, tv, indexPath, model) in
            let cell = tv.dequeueReusableCell(withIdentifier: "YTListTableViewCell") as! YTListTableViewCell
            cell.title.text = model.title
            cell.img.kf.setImage(with: URL.init(string: model.images.first!))
            cell.morePic.isHidden = !model.multipic
            
            return cell
        }
        
        dataArr.asObservable().bind(to: tableView.rx.items(dataSource: dataSource)).addDisposableTo(rx.disposeBag)
        
        tableView.rx.setDelegate(self).addDisposableTo(rx.disposeBag)
        
        tableView.rx
            .modelSelected(YTStoryModel.self)
            .subscribe(onNext: { (model) in
                self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
                let detailVC = YTDetailViewController()
                self.dataArr.value.forEach({ (sectionModel) in
                    sectionModel.items.forEach({ (storyModel) in
                        detailVC.ids.append(storyModel.id)
                    })
                })
                detailVC.id = model.id
                self.navigationController?.pushViewController(detailVC, animated: true)
        }).addDisposableTo(rx.disposeBag)
        
        self.titleNum
            .asObservable()
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (num) in
                if num == 0 {
                    self.title = "今日要闻"
                } else {
                    let date = try! DateInRegion.init(string: self.dataSource[num].model, format: DateFormat.custom("yyyyMMdd"))
                    self.title = "\(date.month)月\(date.day)日 \(date.weekday.toWeekday())"
                    
                }
        }).addDisposableTo(rx.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBarUI() {
        barImg = (navigationController?.navigationBar.subviews.first)!
        barImg.alpha = 0
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor.rgb(63, 141, 208)
        navigationController?.navigationBar.isTranslucent = false
        
        tableView.frame = CGRect.init(x: 0, y: -64, width: screenW, height: screenH)
        
        bannerView.bannerDelegate = self;
        
    }
    
    func addRefreshView() {
        refreshView = YTRefreshView().then{
            $0.frame = CGRect(x: 118, y: -42, width: 40, height: 40)
            $0.backgroundColor = UIColor.clear
        }
        view.addSubview(refreshView!)
    }

    func loadData() {
        
        let vmInput = YTRxViewModel.Input(category: .getNewsList)
        let vmOutput = viewModel.transform(intput: vmInput, modelType: YTlistModel.self)
        vmOutput.model.asObservable().subscribe(onNext: { (model) in
            if model is YTlistModel {
                let listModel = model as! YTlistModel
                self.dataArr.value = [SectionModel(model: listModel.date, items: listModel.stories)]
                self.newsDate = listModel.date
                var arr = listModel.top_stories
                arr.insert(arr.last!, at: 0)
                arr.append(arr[1])
                self.bannerView.imageUrlArr.value = arr
                self.pageControl.numberOfPages = listModel.top_stories.count
                self.refreshView?.endRefresh()
            }
        }).addDisposableTo(rx.disposeBag)
    }
    
    func loadMoreData() {
        let vmInput = YTRxViewModel.Input(category: .getMoreNews(newsDate))
        let vmOutput = viewModel.transform(intput: vmInput, modelType: YTlistModel.self)
        vmOutput.model.asObservable().subscribe(onNext: { (model) in
            if model is YTlistModel {
                let listModel = model as! YTlistModel
                self.dataArr.value.append(SectionModel(model: listModel.date, items: listModel.stories))
                self.newsDate = listModel.date
            }
        }).addDisposableTo(rx.disposeBag)
    }
        
}

extension YTHomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.section == self.dataArr.value.count - 1 && indexPath.row == 0){
            loadMoreData()
        }
        
        self.titleNum.value = (tableView.indexPathsForVisibleRows?.reduce(Int.max) {
            (result, indexPath) -> Int in
            return min(result, indexPath.section)
        })!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section > 0){
            return UILabel().then({
                $0.frame = CGRect(x: 0, y: 0, width: screenW, height: 38)
                $0.backgroundColor = UIColor.rgb(63, 141, 208)
                $0.textColor = UIColor.white
                $0.font = UIFont.systemFont(ofSize: 15)
                $0.textAlignment = .center
                let date = try! DateInRegion.init(string: dataSource[section].model, format: DateFormat.custom("yyyyMMdd"))
                $0.text = "\(date.month)月\(date.day)日 \(date.weekday.toWeekday())"
            })
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        
        return 38
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
}

extension YTHomeViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        bannerView.offY.value = Double(scrollView.contentOffset.y)
        barImg.alpha = scrollView.contentOffset.y / 200
        refreshView?.pullToRefresh(progress: -scrollView.contentOffset.y / 64)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(scrollView.contentOffset.y <= -64){
            refreshView?.beginRefresh {
                self.loadData()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        refreshView?.resetLayer()
    }
}

extension YTHomeViewController : BannerDelegate {
    func selectedItem(model: YTStoryModel) {
        let detailVC = YTDetailViewController()
        self.dataArr.value.forEach({ (sectionModel) in
            sectionModel.items.forEach({ (storyModel) in
                detailVC.ids.append(storyModel.id)
            })
        })
        detailVC.id = model.id
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollTo(index: Int) {
        var currentPage = index
        if(index >= pageControl.numberOfPages){
            currentPage = 0
        }
        self.pageControl.currentPage = currentPage
    }
}
