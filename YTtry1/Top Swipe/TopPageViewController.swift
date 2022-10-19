//
//  TopPageViewController.swift
//  YTtry1
//
//  Created by Nephilim  on 10/11/22.
//

import Foundation
import UIKit
import SDWebImage

protocol MainPageDelegate {
    func givePagesTapGesture()
}

class TopPageViewController: UIPageViewController, NetworkServiceTPVCDelegate {
   
    var vcDelegate : MainPageDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var networkService = NetworkService()
    
    var channels = [ChannelModel]()
    var pages: [SampleViewController] = [SampleViewController]()
 
    private var timer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        networkService.tpvcDelegate = self
        networkService.combineChannelModel()
    }
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //this is for autoswipe every 5 secs
    var currentIndex = 0
    @objc func swipeSlide() {
        currentIndex = (currentIndex == pages.count - 1) ? 0 : currentIndex + 1
        
        self.setViewControllers([self.pages[currentIndex]], direction: .forward, animated: true, completion: nil)
    }
    
    //MARK: - NetworkService Methods
    func channelsFetched(_ channels: [ChannelModel]) {
        
        self.channels = channels
        //refresh table view
        DispatchQueue.main.async {
            
            for i in 0..<self.channels.count {
            let vc = SampleViewController()
            let channel = self.channels[i]
            vc.nameLabel.text = channel.title
            vc.playlistID = channel.uploadPlaylist
            vc.detailLabel.text = "\(channel.subsCount) subscribers"
            let url = URL(string: channel.bannerUrl)
            vc.image.sd_setImage(with: url, completed: nil)
            
            self.pages.append(vc)
                
        }
            self.setViewControllers([self.pages[0]], direction: .forward, animated: false, completion: nil)
            if self.channels.count == self.pages.count {
                self.vcDelegate?.givePagesTapGesture()
                self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.swipeSlide), userInfo: nil, repeats: true)
            }
        }
    }
}

extension TopPageViewController: UIPageViewControllerDataSource {
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
extension TopPageViewController: UIPageViewControllerDelegate {

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
