//
//  FTWaterFallLayout.swift
//  FTWaterFallLayout
//
//  Created by liufengting on 05/12/2016.
//  Copyright © 2016 LiuFengting. All rights reserved.
//

import UIKit

public protocol FTWaterFallLayoutDelegate: NSObjectProtocol {
    func ftWaterFallLayout(layout: FTWaterFallLayout, heightForItem atIndex: IndexPath) -> CGFloat
}

public class FTWaterFallLayout: UICollectionViewFlowLayout {
    
    public var numberOfColumns: NSInteger = 2 {didSet{self.configure()}}
    public var sectionInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10){didSet{self.configure()}}
    public var itemMaginSize: CGSize = CGSize(width: 10, height: 10){didSet{self.configure()}}
    public var delegate : FTWaterFallLayoutDelegate?
    
    fileprivate var itemWidth: CGFloat = 0
    fileprivate var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    fileprivate var heightsForEachColumn: [NSInteger : CGFloat] = [:]
    
    // MARK: - private methods
    fileprivate func configure() {
        layoutAttributes.removeAll()
        for i in 0..<self.numberOfColumns{
            heightsForEachColumn[i] = sectionInsets.top
        }
        if self.collectionView != nil {
            itemWidth = ((self.collectionView?.frame.size.width)! - self.sectionInsets.left - self.sectionInsets.right - (self.itemMaginSize.width * CGFloat(self.numberOfColumns - 1)))/CGFloat(self.numberOfColumns)
        }
    }
    
    fileprivate func itemHeightForIndexPath(indexPath: IndexPath) -> CGFloat {
        if (delegate != nil) {
            return (delegate?.ftWaterFallLayout(layout: self, heightForItem: indexPath))!
        }
        debugPrint("Please set FTWaterFallLayout.delegate")
        return 0
    }
    
    fileprivate func getMinHeightColumn() -> NSInteger {
        var minIndex = 0
        var minHeight : CGFloat = heightsForEachColumn[0]!
        for i in 0 ..< heightsForEachColumn.count{
            let height : CGFloat = heightsForEachColumn[i]!
            if height < minHeight {
                minHeight = height
                minIndex = i
            }
        }
        return minIndex
    }
    
    fileprivate func getMaxHeight() -> CGFloat {
        var maxHeight : CGFloat = heightsForEachColumn[0]!
        for i in 0 ..< heightsForEachColumn.count{
            let height : CGFloat = heightsForEachColumn[i]!
            if height > maxHeight {
                maxHeight = height
            }
        }
        maxHeight += sectionInsets.bottom - itemMaginSize.height
        return maxHeight
    }
    
    // MARK: - UICollectionViewFlowLayout requied methods
    public override func prepare() {
        self.configure()
        
        let itemCount = self.collectionView!.numberOfItems(inSection: 0)
        for i in 0 ..< itemCount{
            let minHeightColumn = getMinHeightColumn()
            let indexPath = IndexPath(item: i, section: 0)
            let x = self.sectionInsets.left + (self.itemWidth + self.itemMaginSize.width) * CGFloat(minHeightColumn)
            var y = heightsForEachColumn[minHeightColumn]!
            let itemHeight = self.itemHeightForIndexPath(indexPath: indexPath)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
            layoutAttributes.append(attribute)
            y += itemHeight + self.itemMaginSize.height
            heightsForEachColumn[minHeightColumn] = y
        }
    }
    
    public override var collectionViewContentSize: CGSize {
        
        return CGSize(width: (self.collectionView?.bounds.size.width)!, height: self.getMaxHeight())
    }
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return layoutAttributes
    }
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.item]
    }
}
