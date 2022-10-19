//
//  BottomCollectionViewCell.swift
//  YTtry1
//
//  Created by Nephilim  on 10/14/22.
//

import UIKit

class BottomCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "Cell"
    
    var imageView : UIImageView?

    var videoNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .white
        label.font = UIFont(name: Constants.SFProTextMedium, size: 17)
        return label
    }()

    var videoViewsCount: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#707070")
        label.font = UIFont(name: Constants.SFProTextMedium, size: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let rect2 = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: 135, height: 135)
        imageView = UIImageView(frame: rect2)
        imageView?.image = UIImage(named: "oracle")
        imageView?.contentMode = .scaleAspectFill
        
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
        
        addSubview(videoViewsCount)
        videoViewsCount.snp.makeConstraints { make in
            make.left.right.equalTo(imageView!)
            make.top.equalTo(videoNameLabel.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
