//
//  SampleViewController.swift
//  YTtry1
//
//  Created by Nephilim  on 10/11/22.
//

import UIKit
import SnapKit

class SampleViewController: UIViewController {

    var playlistID = ""
    var image : UIImageView = {
        
        var img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(systemName: "sun.fill")
        return img
    }()
    var nameLabel : UILabel = {
       var label = UILabel()
        label.numberOfLines = 2
        label.text = "Channel Name"
        label.textColor = .black
        label.font = UIFont(name: "HiraMinProN-W6", size: 16)
        return label
    }()
    var detailLabel: UILabel = {
        var label = UILabel()
        label.textColor = .green
        label.font = UIFont(name: "HiraMinProN-W3", size: 10)
        label.text = "999999999 subscribers"
        return label
    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
//        view.addTapGesture {
//            print("this prints from sampleviewcontroller" + self.nameLabel.text!)
//        }
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        view.addSubview(image)
        image.snp.makeConstraints { make in
            make.height.equalTo(180)
            make.width.equalTo(339)
            make.centerX.equalTo(view)
            
            make.bottom.equalTo(view)
        }
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(image).offset(14)
            make.bottom.equalTo(image.snp.bottom).inset(14)
            
        }
        image.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(detailLabel)
            make.bottom.equalTo(image.snp.bottom).inset(28)
            make.height.lessThanOrEqualTo(60)
            
//            make.leading.bottom.equalTo(image).offset(20)
//            make.height.width.greaterThanOrEqualTo(image)
        }
        
    }


}
