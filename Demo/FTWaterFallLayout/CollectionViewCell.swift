//
//  CollectionViewCell.swift
//  FTWaterFallLayout
//
//  Created by liufengting on 05/12/2016.
//  Copyright © 2016 LiuFengting. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    public var imageUrl : String = "" {
        didSet{
            
            self.layer.cornerRadius = 10
            self.imageView.layer.cornerRadius = 10
            self.selectedBackgroundView = self.selectedBackgroundView_
            
            self.imageView.kf.setImage(with: URL(string: imageUrl)!)
 
        }
    }
    
    var selectedBackgroundView_ : UIView {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        return view
    }
    
}
