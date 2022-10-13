//
//  ViewController.swift
//  YTtry1
//
//  Created by Nephilim  on 10/7/22.
//

import UIKit
import YouTubeiOSPlayerHelper
import BottomSheet
import SnapKit



class ViewController: UIViewController {
    
    
    var networkService = NetworkService()
    
    var mainContentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .gray
        return v
        
    }()
    
    var playlistLabel: UILabel = {
        var label = UILabel()
        label.text = "Playlist Name"
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = .white
        return label
    }()
    
    var thePageVC: MainPageViewController!
    
    
    
    var detailView = DetailView()
    
    private var isBottomSheetIsShown = false
    
    var arrowButton: UIButton = {
        let image = UIImage(named: "Close_Open")
        let butt = UIButton(type: .custom)
        butt.setImage(image, for: .normal)
        return butt
    }()
    
    override func viewDidLoad() {

        title = "Youtube API"
        view.backgroundColor = UIColor(hexString: "#1D1B26")
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        
        super.viewDidLoad()
        setupMainPageController()
        
        
        view.addSubview(detailView)
        
        
        initSetup()
        
        setupButton()
        
       // video.load(withVideoId: "MUws5oXXYa8")
        // Do any additional setup after loading the view.
    }
    
    func setupMainPageController() {
        
        
        view.addSubview(mainContentView)
        mainContentView.backgroundColor = .clear
        mainContentView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        thePageVC = MainPageViewController()
        addChild(thePageVC)
        thePageVC.view.backgroundColor = .clear
        
        thePageVC.view.translatesAutoresizingMaskIntoConstraints = false

        // add the page VC's view to our container view
        mainContentView.addSubview(thePageVC.view)
        //проблема з констрейнами Пейджвью контроллера
        
        thePageVC.view.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(mainContentView)
//            make.centerX.equalTo(mainContentView)
//            make.centerY.equalTo(mainContentView)
//            make.width.equalTo(mainContentView.snp.width)
//            make.height.equalTo(mainContentView.snp.height)
        }
        
        thePageVC.didMove(toParent: self)
        //MARK: - adding Playlist label
        view.addSubview(playlistLabel)
        playlistLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.top.equalTo(mainContentView.snp.bottom).offset(14)
            
        }
        
        
    }
    

    
    func setupButton() {
        detailView.addSubview(arrowButton)
        
        arrowButton.addTarget(self, action: #selector(arrowButtonTapped), for: .touchUpInside)
        arrowButton.translatesAutoresizingMaskIntoConstraints = false
        arrowButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(detailView.snp.top)
            make.height.equalTo(40)
        }

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func initSetup() {
        
        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.snp.makeConstraints { make in
            make.height.equalTo(60)
            
            make.bottom.leading.trailing.equalToSuperview()
        }
        detailView.backgroundColor = UIColor(hexString: "#EE4289")
    }
    
    
    @objc func arrowButtonTapped() {
        if (isBottomSheetIsShown) {
            UIView.animate(withDuration: 0.3, animations: {
                
                self.detailView.snp.updateConstraints { make in
                    make.height.equalTo(60)
                    
                }
                
                self.view.layoutIfNeeded()
                self.isBottomSheetIsShown = false
                
                self.arrowButton.imageView?.transform = (self.arrowButton.imageView?.transform.rotated(by: .pi))!
            })
            
        } else {
            // show the bottom sheet
            UIView.animate(withDuration: 0.2, animations: {
                
                self.detailView.snp.updateConstraints { make in
                    make.height.equalTo(620)
                    
                }
                self.view.layoutIfNeeded()
            }) { (status) in
                // completion code
                self.isBottomSheetIsShown = true
                
                self.arrowButton.imageView?.transform = (self.arrowButton.imageView?.transform.rotated(by: .pi))!
    
                UIView.animate(withDuration: 0.1, animations: {
                    
                    self.detailView.snp.updateConstraints { make in
                        make.height.equalTo(600)
                    }
                    
                    self.view.layoutIfNeeded()
                }) { (status) in
                    
                }
            }
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
