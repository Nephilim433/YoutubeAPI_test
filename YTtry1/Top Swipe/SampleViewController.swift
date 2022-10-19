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
    var image = UIImageView()
    
    var nameLabel : UILabel = {
       var label = UILabel()
        label.numberOfLines = 2
        label.text = ""
        label.textColor = .black
        label.font = UIFont(name: Constants.SFProTextSemibold, size: 16)
        return label
    }()
    var detailLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor(hexString: "#707070")
        label.font = UIFont(name: Constants.SFProTextRegular, size: 10)
        label.text = ""
        return label
    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(image)
        image.snp.makeConstraints { make in
            
            make.left.top.equalTo(view).offset(17)
            make.right.equalTo(view).inset(17)
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

        }
    }
}
