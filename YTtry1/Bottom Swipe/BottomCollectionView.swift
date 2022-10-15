//
//  BottomCollectionView.swift
//  YTtry1
//
//  Created by Nephilim  on 10/14/22.
//

import UIKit

class BottomCollectionView: UICollectionView{

    var flowLayout: UICollectionViewFlowLayout = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 5, right: 5)
        return layout
    }()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        backgroundColor = .clear
        register(BottomCollectionViewCell.self, forCellWithReuseIdentifier: BottomCollectionViewCell.reuseIdentifier)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

