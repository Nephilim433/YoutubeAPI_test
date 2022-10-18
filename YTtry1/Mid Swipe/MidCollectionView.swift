//
//  MidCollectionViewController.swift
//  YTtry1
//
//  Created by Nephilim  on 10/14/22.
//

import UIKit



class MidCollectionView: UICollectionView {
 
    
    var flowLayout: UICollectionViewFlowLayout = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        //layout.minimumInteritemSpacing = 10
        
        layout.sectionInset = UIEdgeInsets(top: 17, left: 0, bottom: 0, right: 0)
        return layout
    }()
    
    
     func viewDidLoad() {
     
    }

    
    
    init() {
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        
        register(MidCollectionViewCell.self, forCellWithReuseIdentifier: MidCollectionViewCell.reuseIdentifier)
 
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


