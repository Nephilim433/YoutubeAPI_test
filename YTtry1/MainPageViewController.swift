//
//  MainPageViewController.swift
//  YTtry1
//
//  Created by Nephilim  on 10/11/22.
//

import Foundation
import UIKit
import SDWebImage

class MainPageViewController: UIPageViewController, NetworkServiceDelegate,NetworkServiceDelegate2 {
    
    var statistics : [VideoStatistics] = []
    
    

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var networkService = NetworkService()
    var videos = [Video]()
    var pages: [SampleViewController] = [SampleViewController]()
    
    let colors: [UIColor] = [
            .red,
            .green,
            .blue,
            .cyan,
            .yellow,
            .orange
        ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        //networkService.fetchChannnelInfo()
        //MARK: - Don't forget to uncomment it !
        networkService.fetchVideosFromPlaylists()
        networkService.delegate = self
        networkService.delegate2 = self
        networkService.getUploadPlaylist()
        
        

        
         
    }
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - NetworkService Methods
    
    func videosFetched(_ vidoes: [Video]) {
        //set the returned videos to outr video property
        self.videos = vidoes
        //refresh table view
        DispatchQueue.main.async {
        
            for i in 0..<self.videos.count {
            let vc = SampleViewController()
            let video = self.videos[i]
            vc.nameLabel.text = video.title
            let url = URL(string: video.thumbnail)
            vc.image.sd_setImage(with: url, completed: nil)
            //vc.view.backgroundColor = colors[i]
            //vc.image.image = UIImage(systemName: "tray.full")
            self.pages.append(vc)
                
        }
            self.setViewControllers([self.pages[0]], direction: .forward, animated: false, completion: nil)
    }
        
    }
    
    func mapStatisticts() {
            //print("printing mapStat model = \(self.statistics)")
            for i in 0..<self.videos.count {
                self.pages[i].detailLabel.text = self.statistics[i].viewCount
            }
    }
    
    func mapBanner() {
        
    }
}






extension MainPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = pages.firstIndex(of: viewController as! SampleViewController) else { return nil }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else { return pages.last }

        guard pages.count > previousIndex else { return nil }

        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController as! SampleViewController) else { return nil }

        let nextIndex = viewControllerIndex + 1

        guard nextIndex < pages.count else { return pages.first }

        guard pages.count > nextIndex else { return nil }

        return pages[nextIndex]
    }
}
extension MainPageViewController: UIPageViewControllerDelegate {

    // if you do NOT want the built-in PageControl (the "dots"), comment-out these funcs
    

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {

        guard let firstVC = pageViewController.viewControllers?.first else {
            return 0
        }
        guard let firstVCIndex = pages.firstIndex(of: firstVC as! SampleViewController) else {
            return 0
        }

        return firstVCIndex
    }
}
