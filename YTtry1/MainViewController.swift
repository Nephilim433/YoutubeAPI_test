//
//  MainViewController.swift
//  YTtry1
//
//  Created by Nephilim  on 10/7/22.
//

import UIKit
import YouTubeiOSPlayerHelper
import SnapKit

class MainViewController: UIViewController, MainPageDelegate, NetworkServiceMainVCDelegate {

    var scrollView : UIScrollView = {
        let sc = UIScrollView()
        sc.alwaysBounceVertical = true
        sc.showsVerticalScrollIndicator = false
        sc.backgroundColor = .clear
        return sc
    }()
    var scrollContentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()
    var mainContentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()
    var playlistLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.font = UIFont(name: Constants.SFProDisplayBold, size: 23)
        label.textColor = .white
        return label
    }()
    var playlistLabel2: UILabel = {
        var label = UILabel()
        label.text = ""
        
        label.font = UIFont(name: Constants.SFProDisplayBold, size: 23)
        label.textColor = .white
        return label
    }()
    
    var thePageVC: TopPageViewController!
    var midCollectionView = MidCollectionView()
    var bottomCollectionView = BottomCollectionView()
    
    var playerView :PlayerView = {
        let view = Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView
        return view
    }()
    
    var networkService = NetworkService()
    var videoModels = [VideoModel]()
    var videoModels2 = [VideoModel]()
    
    private var isDetailViewShown = false

    let attrs = [NSAttributedString.Key.font: UIFont(name: Constants.SFProDisplayBold, size: 34),NSAttributedString.Key.foregroundColor: UIColor.white]
    
    override func viewDidLoad() {
        title = "Youtube API"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = attrs as [NSAttributedString.Key : Any]
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = UIColor(hexString: Constants.backgorundHexColor)
        setupScrollView()
        super.viewDidLoad()
        
        midCollectionView.delegate = self
        midCollectionView.dataSource = self
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        
        thePageVC.vcDelegate = self
        networkService.mainvcDelegate = self
        
        networkService.combineChannelModel()
        networkService.fetchVideosFromPlaylists()

        setupMidCollectionView()
        setupBottomCollectionView()
        initSetup()
        
        playerView.arrowButton.addTarget(self, action: #selector(arrowButtonTapped), for: .touchUpInside)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK: - setup mid collectionview
    private func setupMidCollectionView() {
        //MARK: - adding Playlist label
        scrollContentView.addSubview(playlistLabel)
        playlistLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.top.equalTo(mainContentView.snp.bottom)
        }
        midCollectionView.showsHorizontalScrollIndicator = false
        scrollContentView.addSubview(midCollectionView)
        midCollectionView.translatesAutoresizingMaskIntoConstraints = false
        midCollectionView.backgroundColor = .clear
        midCollectionView.snp.makeConstraints { make in
            make.left.equalTo(playlistLabel.snp.left)
            make.right.equalTo(view)
            make.top.equalTo(playlistLabel.snp.bottom)
            make.height.equalTo(150)
        }
    }
    private func setupBottomCollectionView() {
        //MARK: -  adding Second Playlist Label
        scrollContentView.addSubview(playlistLabel2)
        playlistLabel2.snp.makeConstraints { make in
            make.leading.equalTo(playlistLabel.snp.leading)
            make.top.equalTo(midCollectionView.snp_bottomMargin).offset(5)
        }
        //MARK: - adding BottomCollectionView
        scrollContentView.addSubview(bottomCollectionView)
        bottomCollectionView.showsHorizontalScrollIndicator = false
        bottomCollectionView.snp.makeConstraints { make in
            make.left.equalTo(playlistLabel.snp.left)
            make.right.equalTo(view)
            make.top.equalTo(playlistLabel2.snp.bottom)
            make.height.equalTo(210)
        }
    }
    private func setupScrollView() {
        //MARK: - setup srollview
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(view)
        }
        //MARK: - adding contentview to it
        scrollView.addSubview(scrollContentView)
        scrollContentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view)
            make.width.equalTo(scrollView)
            
            make.height.equalTo(800)
        }
        //MARK: - setting up page view at the top
        scrollContentView.addSubview(mainContentView)
        mainContentView.backgroundColor = .clear
        mainContentView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(scrollContentView)
            make.height.equalTo(255)
        }
        
        thePageVC = TopPageViewController()
        addChild(thePageVC)
        thePageVC.view.backgroundColor = .clear
        mainContentView.addSubview(thePageVC.view)
        thePageVC.view.snp.makeConstraints { make in
            make.edges.equalTo(mainContentView)
        }
        thePageVC.didMove(toParent: self)
    }

    func initSetup() {
        //MARK: - addding deteilview
        navigationController?.view.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.bottom.leading.trailing.equalToSuperview()
        }
        playerView.clipsToBounds = true
        playerView.layer.cornerRadius = 16
        playerView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    }
    
    func videosFetched(_ vidoes: [VideoModel]) {
        
        self.videoModels = vidoes
        midCollectionView.reloadData()
    }
    func videosFetched2(_ vidoes: [VideoModel]) {
        self.videoModels2 = vidoes
        bottomCollectionView.reloadData()
    }
    func playlistsTitleFetched(_ plTitle: String) {
        playlistLabel.text = plTitle
    }
    func playlistsTitleFetched2(_ plTitle: String) {
        playlistLabel2.text = plTitle
    }
    
    func givePagesTapGesture() {
        thePageVC.pages.forEach { page in
            page.view.addTapGesture {
                self.arrowButtonTapped()
                self.playerView.playVideo(playlistID: page.playlistID)
            }
        }
    }

    @objc func arrowButtonTapped() {
        
        if (isDetailViewShown) {
            
            UIView.animate(withDuration: 0.3,  animations: {
                self.playerView.snp.updateConstraints { make in
                    make.height.equalTo(44)
                }
                self.isDetailViewShown = false
                self.view.alpha = 1
                self.playerView.arrowButton.imageView?.transform = (self.playerView.arrowButton.imageView?.transform.rotated(by: .pi))!
                self.navigationController?.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: .layoutSubviews, animations: {
                self.view.alpha = 0.5
                self.playerView.snp.updateConstraints { make in
                    make.height.equalTo(580)
                }
                self.navigationController?.view.layoutIfNeeded()
            }) { _ in
                self.isDetailViewShown = true
                self.playerView.arrowButton.imageView?.transform = (self.playerView.arrowButton.imageView?.transform.rotated(by: .pi))!
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.playerView.snp.updateConstraints { make in
                        make.height.equalTo(570)
                    }
                    self.navigationController?.view.layoutIfNeeded()
                })
            }
        }
        
    }
}

// MARK: UICollectionViewDelegate & UICollectionViewDataSource
extension MainViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.midCollectionView {
            
            let model = videoModels[indexPath.item]
            playerView.playVideo(videoID:model.videoID )
            playerView.videoNameLabel.text = model.videoName
            arrowButtonTapped()

        } else {
            
            let model = videoModels2[indexPath.item]
            playerView.playVideo(videoID:model.videoID )
            playerView.videoNameLabel.text = model.videoName
            arrowButtonTapped()
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.midCollectionView {
            return videoModels.count
        } else {
            return videoModels2.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.midCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MidCollectionViewCell.reuseIdentifier, for: indexPath) as! MidCollectionViewCell
            
            if videoModels.count == 0 {
                cell.imageView?.image = UIImage(named: "cover")
            } else {
                let model = videoModels[indexPath.item]
                cell.imageView?.sd_setImage(with: URL(string: model.videoPreviewURL), placeholderImage: UIImage(named: "cover"))
                let viewsCount = Int(model.videoViewsCount)?.formattedWithSeparator
                cell.videoViewsCount.text = "\(viewsCount!) views"
                cell.videoNameLabel.text = model.videoName
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCollectionViewCell.reuseIdentifier, for: indexPath) as! BottomCollectionViewCell
            if videoModels2.count == 0 {
                cell.imageView?.image = UIImage(named: "cover")
            } else {
                let model = videoModels2[indexPath.item]
                cell.imageView?.sd_setImage(with: URL(string: model.videoPreviewURL), placeholderImage: UIImage(named: "cover"))
                let viewsCount = Int(model.videoViewsCount)?.formattedWithSeparator
                cell.videoViewsCount.text = "\(viewsCount!) views"
                cell.videoNameLabel.text = model.videoName
            }
            return cell
        }
    }
}

extension MainViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.midCollectionView {
            return CGSize(width: 160, height: 150)
        } else {
            return CGSize(width: 135, height: 185)
        }
    }
}
