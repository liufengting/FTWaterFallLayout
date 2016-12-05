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
        
        self.imageArray.append(contentsOf: imageArray)
        self.imageArray.append(contentsOf: imageArray)
        self.imageArray.append(contentsOf: imageArray)
    }
    
    var collectionViewLayout : FTWaterFallLayout {
        let layout : FTWaterFallLayout = FTWaterFallLayout()
        layout.numberOfColumns = 2
        layout.sectionInsets = UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 10)
        layout.itemMaginSize = CGSize(width: 10, height: 10)
        layout.delegate = self
        return layout
    }
    
    var imageArray : [String] = [ "http://ww4.sinaimg.cn/mw600/7352978fgw1f6gkap8p45j20f00f074t.jpg",
                                  "http://ww3.sinaimg.cn/mw600/c0679ecagw1f6ff68fzb1j20gt0gtwhf.jpg",
                                  "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff69na87j20gt08a3z2.jpg",
                                  "http://ww1.sinaimg.cn/mw600/c0679ecagw1f6ff6ar7v7j20gt0me3yy.jpg",
                                  "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff6csucjj20gt0aijrh.jpg",
                                  "http://ww4.sinaimg.cn/mw600/7352978fgw1f6gkap8p45j20f00f074t.jpg",
                                  "http://ww3.sinaimg.cn/mw600/c0679ecagw1f6ff68fzb1j20gt0gtwhf.jpg",
                                  "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff69na87j20gt08a3z2.jpg",
                                  "http://ww1.sinaimg.cn/mw600/c0679ecagw1f6ff6ar7v7j20gt0me3yy.jpg" ];
    
    
    
    // MARK: FTWaterFallLayoutDelegate
    
     func ftWaterFallLayout(layout: FTWaterFallLayout, heightForItem atIndex: IndexPath) -> CGFloat {
        // get image size without downloading it !!!!!!
        return FTImageSize.getImageSizeFromImageURL(imageArray[atIndex.item], perferdWidth: (self.view.frame.size.width - 50)/2).height
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

