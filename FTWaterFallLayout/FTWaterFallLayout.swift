//
//  FTWaterFallLayout.swift
//  FTWaterFallLayout
//
//  Created by liufengting on 05/12/2016.
//  Copyright © 2016 LiuFengting. All rights reserved.
//

import UIKit

@objc public protocol FTWaterFallLayoutDelegate {
    
    func ftWaterFallLayout(_ layout: FTWaterFallLayout, heightForItemAt indexPath: IndexPath) -> CGFloat
    @objc optional func ftWaterFallLayout(_ layout: FTWaterFallLayout, heightForHeaderAt section: Int) -> CGFloat
    @objc optional func ftWaterFallLayout(_ layout: FTWaterFallLayout, heightForFooterAt section: Int) -> CGFloat

}

public class FTWaterFallLayout: UICollectionViewFlowLayout {
    
    public var numberOfColumns: Int = 2
    public var sectionInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    public var itemMaginSize: CGSize = CGSize(width: 10, height: 10)
    public var delegate : FTWaterFallLayoutDelegate?
    
    var itemWidth: CGFloat = 0
    var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    var heightsForEachColumn: [Int : CGFloat] = [:]
    
    var headerAttributes: UICollectionViewLayoutAttributes?
    var footerAttributes: UICollectionViewLayoutAttributes?

    public func setupWith(numberOfColumns: Int, sectionInsets: UIEdgeInsets, itemMaginSize: CGSize, delegate: FTWaterFallLayoutDelegate) {
        self.numberOfColumns = numberOfColumns
        self.sectionInsets = sectionInsets
        self.itemMaginSize = itemMaginSize
        self.delegate = delegate
    }
    
    // MARK: - private methods
    
    func configure() {
        layoutAttributes.removeAll()
        for i in 0..<self.numberOfColumns{
            heightsForEachColumn[i] = self.headerHeightForSection(section: 0) + sectionInsets.top
        }
        if self.collectionView != nil {
            itemWidth = ((self.collectionView?.frame.size.width)! - self.sectionInsets.left - self.sectionInsets.right - (self.itemMaginSize.width * CGFloat(self.numberOfColumns - 1)))/CGFloat(self.numberOfColumns)
        }
    }
    
    func headerHeightForSection(section: Int) -> CGFloat {
        if let headerHeight = delegate?.ftWaterFallLayout?(self, heightForHeaderAt: section) {
            return headerHeight
        }
        return 0
    }
    
    func itemHeightForIndexPath(indexPath: IndexPath) -> CGFloat {
        if let height = delegate?.ftWaterFallLayout(self, heightForItemAt: indexPath) {
            return height
        }
        return 0
    }
    
    func footerHeightForSection(section: Int) -> CGFloat {
        if let footerHeight = delegate?.ftWaterFallLayout?(self, heightForFooterAt: section) {
            return footerHeight
        }
        return 0
    }
    
    func getMinHeightColumn() -> Int {
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
    
    func getMaxHeight() -> CGFloat {
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
        
        if let _ = self.collectionView?.numberOfSections {
            let attribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: 0))
            attribute.frame = CGRect(x: 0, y: 0, width: self.collectionView!.bounds.width, height: self.headerHeightForSection(section: 0))
            self.headerAttributes = attribute
            
            let fa = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: 0))
            fa.frame = CGRect(x: 0, y: self.getMaxHeight(), width: self.collectionView!.bounds.width, height: self.footerHeightForSection(section: 0))
            self.footerAttributes = fa
        }
        
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
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == UICollectionView.elementKindSectionHeader {
            return headerAttributes
        } else {
            return footerAttributes
        }
        
    }
    
}
