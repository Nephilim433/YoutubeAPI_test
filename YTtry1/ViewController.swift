//
//  ViewController.swift
//  YTtry1
//
//  Created by Nephilim  on 10/7/22.
//

import UIKit
import YouTubeiOSPlayerHelper
import SnapKit



class ViewController: UIViewController, MainPageDelegate, NetworkServiceForViewController {
    
    
    
    func videosFetched(_ vidoes: [VideoModel]) {
        //print("vidoes.count \(vidoes.count) <<<<>>>>><<<<<>>><<<<>>><<<")
        self.videoModels = vidoes
        midCollectionView.reloadData()
    }
    func videosFetched2(_ vidoes: [VideoModel]) {
        print("vidoes2.count \(vidoes.count) <<<<>>>>><<<<<>>><<<<>>><<<")
        self.videoModels2 = vidoes
        bottomCollectionView.reloadData()
    }
    
    func givePagesTapGesture() {
        //print("openDetailViewWith executes <<<<<<<<")
        thePageVC.pages.forEach { page in
            page.view.addTapGesture {
                print("addTapGesture executes")
                self.arrowButtonTapped()
                self.detailView.playVideo(playlistID: page.playlistID)
                //self.detailView.playerView.playVideo()
            }
        }
    }

    
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
        label.text = "Playlist Name"
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = .white
        return label
    }()
    var playlistLabel2: UILabel = {
        var label = UILabel()
        label.text = "Playlist Name"
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = .white
        return label
    }()
    
    var thePageVC: MainPageViewController!
    var midCollectionView = MidCollectionView()
    var bottomCollectionView = BottomCollectionView()
    
    var detailView :DetailView = {
        let view = Bundle.main.loadNibNamed("DetailView", owner: self, options: nil)?.first as! DetailView
        return view
    }()
    
    var networkService = NetworkService()
    var videoModels = [VideoModel]()
    var videoModels2 = [VideoModel]()
    
    private var isBottomSheetIsShown = false
    
    var arrowButton: UIButton = {
        let image = UIImage(named: "Close_Open")
        let butt = UIButton(type: .custom)
        
        butt.setImage(image, for: .normal)
        butt.imageView?.transform = (butt.imageView?.transform.rotated(by: .pi))!
        return butt
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.layer.removeAllAnimations()
    }
    
    override func viewDidLoad() {
        title = "Youtube API"
        view.backgroundColor = UIColor(hexString: "#1D1B26")
        setupScrollView()
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        
        super.viewDidLoad()
        
        midCollectionView.delegate = self
        midCollectionView.dataSource = self
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        
        thePageVC.vcDelegate = self
        networkService.vcDelegate = self
        
        networkService.combineChannelModel()
        networkService.fetchVideosFromPlaylists()
        
        
        setupMidCollectionView()
        setupBottomCollectionView()
        initSetup()
        setupButton()
        detailView.playPauseButton.addTarget(self, action: #selector(arrowButtonTapped), for: .touchUpInside)
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
            //make.height.equalTo(playlistLabel.snp.height)
            //make.top.equalTo(mainContentView.snp.bottom)
            make.top.equalTo(midCollectionView.snp_bottomMargin).offset(5)
            //make.top.equalTo(playlistLabel.snp.bottom).offset(200)
            
            //make.top.equalTo(midCollectionView.snp.bottom)
            
        }
        
        scrollContentView.addSubview(bottomCollectionView)
        bottomCollectionView.snp.makeConstraints { make in
            make.left.equalTo(playlistLabel.snp.left)
            make.right.equalTo(view)
            make.top.equalTo(playlistLabel2.snp.bottom)
            make.height.equalTo(220)
        }
    }
    private func setupScrollView() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(view)
        }
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.snp.makeConstraints { make in

            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view)
            make.width.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }
        
        scrollContentView.addSubview(mainContentView)

        mainContentView.backgroundColor = .clear
        mainContentView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(scrollContentView)
            make.height.equalTo(255)
        }
        thePageVC = MainPageViewController()
        addChild(thePageVC)
        thePageVC.view.backgroundColor = .clear

        thePageVC.view.translatesAutoresizingMaskIntoConstraints = false

        
        mainContentView.addSubview(thePageVC.view)
        

        thePageVC.view.snp.makeConstraints { make in
            
            make.edges.equalTo(mainContentView)
        }

        
        thePageVC.didMove(toParent: self)
        
    }
    
 
    func setupButton() {
        detailView.addSubview(arrowButton)
        
        arrowButton.addTarget(self, action: #selector(arrowButtonTapped), for: .touchUpInside)
        arrowButton.translatesAutoresizingMaskIntoConstraints = false
        arrowButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(detailView.snp.top)
            make.height.equalTo(37)
        }

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func initSetup() {

        navigationController?.view.addSubview(detailView)
        
        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.snp.makeConstraints { make in
            make.height.equalTo(44)
            //make.bottom.leading.trailing.equalTo(window)
            //make.width.equalTo(window.snp.width)
            make.bottom.leading.trailing.equalToSuperview()
        }
        detailView.backgroundColor = UIColor(hexString: "#EE4289")
        detailView.clipsToBounds = true
        detailView.layer.cornerRadius = 16
        detailView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    }
    @objc func arrowButtonTapped() {
    
            if (isBottomSheetIsShown) {
                UIView.animate(withDuration: 0.3,  animations: {
                    self.detailView.snp.updateConstraints { make in
                        make.height.equalTo(37)
                    }
                    self.isBottomSheetIsShown = false
                    
                    
                    self.view.alpha = 1
                    self.arrowButton.imageView?.transform = (self.arrowButton.imageView?.transform.rotated(by: .pi))!
                    
                self.detailView.layoutIfNeeded()
                self.navigationController?.view.layoutIfNeeded()
                self.view.layoutIfNeeded()
            })
            
        } else {
             //show the bottom sheet
            UIView.animate(withDuration: 0.5, delay: 0, options: .layoutSubviews, animations: {
                self.view.alpha = 0.5
                
                self.detailView.snp.updateConstraints { make in
                    make.height.equalTo(580)
                }
                
                self.view.layoutIfNeeded()
                self.navigationController?.view.layoutIfNeeded()
            }) { (status) in
                // completion code
                self.isBottomSheetIsShown = true
                
                
                self.arrowButton.imageView?.transform = (self.arrowButton.imageView?.transform.rotated(by: .pi))!
                
                //window?.subviews.last?.setNeedsLayout()
                UIView.animate(withDuration: 0.2, animations: {
                    self.detailView.snp.updateConstraints { make in
                        make.height.equalTo(570)
                    }

                    self.navigationController?.view.layoutIfNeeded()
                    self.view.layoutIfNeeded()
                    self.detailView.layoutIfNeeded()
                }) { (status) in

                }
            }
        }
        
    }
    


}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.midCollectionView {
            print("bla bla ")
            let model = videoModels[indexPath.item]
            
            detailView.playVideo(videoID:model.videoID )
            detailView.videoNameLabel.text = model.videoName
            //detailView.playerView.load(withPlaylistId: "UU16K9cMnL5DjXksOo0FjR_A")
            //detailView.playerView.playVideo()
            arrowButtonTapped()
            //arrowButtonTapped()
        } else {
            let model = videoModels2[indexPath.item]
            detailView.playVideo(videoID:model.videoID )
            detailView.videoNameLabel.text = model.videoName
            //detailView.playerView.load(withPlaylistId: "UU16K9cMnL5DjXksOo0FjR_A")
            //detailView.playerView.playVideo()
            arrowButtonTapped()
            //arrowButtonTapped()
            print("bottom collection view")
            arrowButtonTapped()
        }
        
    }
    // MARK: UICollectionViewDataSource

     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
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
             
             //print("bottom cell executed")
            return cell
         }
    }

}


extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.midCollectionView {
        return CGSize(width: 160, height: 150)
        } else {
            return CGSize(width: 135, height: 185)
        }
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIView {
    
    func addTapGesture(action : @escaping ()->Void ){
        let tap = MyTapGestureRecognizer(target: self , action: #selector(self.handleTap(_:)))
        tap.action = action
        tap.numberOfTapsRequired = 1
        
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
    }
    @objc func handleTap(_ sender: MyTapGestureRecognizer) {
        sender.action!()
    }
}

class MyTapGestureRecognizer: UITapGestureRecognizer {
    var action : (()->Void)? = nil
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter
    }()
}

extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}
