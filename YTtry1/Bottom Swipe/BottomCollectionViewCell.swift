//
//  BottomCollectionViewCell.swift
//  YTtry1
//
//  Created by Nephilim  on 10/14/22.
//

import UIKit

class BottomCollectionViewCell: UICollectionViewCell {
    

    static let reuseIdentifier = "Cell2"
    
    
    var imageView2 : UIImageView?
    
    
    
    var videoNameLabel = UILabel()
    var videoViewsCount = UILabel()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let rect2 = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: 135, height: 135)
        imageView2 = UIImageView(frame: rect2)
        imageView2?.image = UIImage(named: "oracle")
        imageView2?.contentMode = .scaleAspectFill
            //.scaleToFill
        
        //.scaleAspectFill
        //.scaleAspectFit
        
        
        contentView.backgroundColor = .clear
        addSubview(imageView2!)
        imageView2?.layer.cornerRadius = 10
        imageView2?.clipsToBounds = true
        setupView()
    
    }
    
    
    
    private func setupView() {
        
        addSubview(videoNameLabel)
        videoNameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(imageView2!)
            make.top.equalTo(imageView2!.snp.bottom).offset(10)
        }
        
        videoNameLabel.text = "ALoha Alova"
        addSubview(videoViewsCount)
        
        videoViewsCount.snp.makeConstraints { make in
            make.left.right.equalTo(imageView2!)
            make.top.equalTo(videoNameLabel.snp.bottom)
        }
        videoViewsCount.font = UIFont.systemFont(ofSize: 12)
        videoViewsCount.textColor = .gray
        videoViewsCount.text = "99999999999"
       
        
        
    }
    
    
//    override var bounds :CGRect {
//           didSet {
//            //setupView()
//            print("bounds got fired")
//
//            //contentView.frame = bounds
//        }
//    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
