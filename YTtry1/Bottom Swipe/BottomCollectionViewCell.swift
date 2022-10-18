//
//  BottomCollectionViewCell.swift
//  YTtry1
//
//  Created by Nephilim  on 10/14/22.
//

import UIKit

class BottomCollectionViewCell: UICollectionViewCell {
    

    static let reuseIdentifier = "Cell2"
    
    
    var imageView : UIImageView?
    
    
    
    var videoNameLabel: UILabel = {
       let label = UILabel()
       label.numberOfLines = 2
       return label
   }()
    var videoViewsCount = UILabel()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let rect2 = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: 135, height: 135)
        imageView = UIImageView(frame: rect2)
        imageView?.image = UIImage(named: "oracle")
        imageView?.contentMode = .scaleAspectFill
        videoNameLabel.textColor = .white
        videoViewsCount.textColor = UIColor(hexString: "#707070")
        
        
        contentView.backgroundColor = .clear
        addSubview(imageView!)
        imageView?.layer.cornerRadius = 10
        imageView?.clipsToBounds = true
        setupView()
    
    }
    
    
    
    private func setupView() {
        
        addSubview(videoNameLabel)
        videoNameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(imageView!)
            make.top.equalTo(imageView!.snp.bottom).offset(10)
        }
        
        videoNameLabel.text = "ALoha Alova"
        addSubview(videoViewsCount)
        
        videoViewsCount.snp.makeConstraints { make in
            make.left.right.equalTo(imageView!)
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
