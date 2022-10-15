//
//  MidCollectionViewCell.swift
//  YTtry1
//
//  Created by Nephilim  on 10/14/22.
//

import UIKit
import SnapKit

class MidCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "Cell"
    
    
    var imageView2 : UIImageView?
    
    
    
    var imageView : UIImageView = {
        
        let rect = CGRect(x: 0, y: 0, width: 10, height: 10)
        let image = UIImage(named: "cover")
        let img = UIImageView(frame: rect)
        img.image = image
        img.contentMode = .scaleToFill
         
        
        
        return img
    }()
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var videoNameLabel = UILabel()
    var videoViewsCount = UILabel()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let rect2 = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: contentView.frame.width, height: 70)
        imageView2 = UIImageView(frame: rect2)
        imageView2?.image = UIImage(named: "oracle")
        imageView2?.contentMode = .center
            //.scaleToFill
        
        //.scaleAspectFill
        //.scaleAspectFit
        
        //imageView2?.clipsToBounds = true
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