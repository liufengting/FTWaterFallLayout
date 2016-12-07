//
//  ViewController.swift
//  FTWaterFallLayout
//
//  Created by liufengting on 05/12/2016.
//  Copyright © 2016 LiuFengting. All rights reserved.
//

import UIKit
import FTImageSize

private let CellReuseIdentifier = "CellIdentifier"

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, FTWaterFallLayoutDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.collectionViewLayout = self.collectionViewLayout
        
    }
    
    var collectionViewLayout : FTWaterFallLayout {
        let layout : FTWaterFallLayout = FTWaterFallLayout()
        layout.numberOfColumns = 2
        layout.sectionInsets = UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 10)
        layout.itemMaginSize = CGSize(width: 10, height: 10)
        layout.delegate = self
        return layout
    }
    
    var imageArray : [String] {
        var array : [String] = []
        for _ in 0..<8 {
            for i in 1..<8 {
                array.append("https://s3-ap-southeast-1.amazonaws.com/lftdemoimages/0\(i).jpg")
            }
        }
        return array
    }
    
    
    // MARK: FTWaterFallLayoutDelegate
    
    func ftWaterFallLayout(layout: FTWaterFallLayout, heightForItem atIndex: IndexPath) -> CGFloat {
        // get image size without downloading it !!!!!!
        return FTImageSize.getImageSizeFromImageURL(imageArray[atIndex.item], perferdWidth: (self.view.frame.size.width - 50)/2).height
    }
    
    func ftWaterFallLayout(layout: FTWaterFallLayout, heightForHeader atSection: NSInteger) -> CGFloat {
        return 5
    }

    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellReuseIdentifier, for: indexPath) as! CollectionViewCell
        
        cell.imageUrl = imageArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

