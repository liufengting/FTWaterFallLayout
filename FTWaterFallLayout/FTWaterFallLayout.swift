//
//  FTFTWaterFallLayout.swift
//  FTFTWaterFallLayout
//
//  Created by liufengting on 05/12/2016.
//  Copyright © 2016 LiuFengting. All rights reserved.
//

import UIKit

public protocol FTWaterFallLayoutDelegate: NSObjectProtocol {

    func collectionViewLayout(for section: Int) -> FTWaterFallLayout.Layout
    func collectionView(_ collectionView: UICollectionView, layout: FTWaterFallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize

    // MARK: - Optional
    func collectionView(_ collectionView: UICollectionView, layout: FTWaterFallLayout, minimumInteritemSpacingFor section: Int) -> CGFloat?
    func collectionView(_ collectionView: UICollectionView, layout: FTWaterFallLayout, minimumLineSpacingFor section: Int) -> CGFloat?
    func collectionView(_ collectionView: UICollectionView, layout: FTWaterFallLayout, sectionInsetFor section: Int) -> UIEdgeInsets?
    func collectionView(_ collectionView: UICollectionView, layout: FTWaterFallLayout, headerHeightFor section: Int) -> CGFloat?
    func collectionView(_ collectionView: UICollectionView, layout: FTWaterFallLayout, headerInsetFor section: Int) -> UIEdgeInsets?
    func collectionView(_ collectionView: UICollectionView, layout: FTWaterFallLayout, footerHeightFor section: Int) -> CGFloat?
    func collectionView(_ collectionView: UICollectionView, layout: FTWaterFallLayout, footerInsetFor section: Int) -> UIEdgeInsets?
    func collectionView(_ collectionView: UICollectionView, layout: FTWaterFallLayout, estimatedSizeForItemAt indexPath: IndexPath) -> CGSize?

}

extension FTWaterFallLayoutDelegate {
    public func collectionView(_ collectionView: UICollectionView, layout: FTWaterFallLayout, minimumInteritemSpacingFor section: Int) -> CGFloat? { return nil }
    public func collectionView(_ collectionView: UICollectionView, layout: FTWaterFallLayout, minimumLineSpacingFor section: Int) -> CGFloat? { return nil }
    public func collectionView(_ collectionView: UICollectionView, layout: FTWaterFallLayout, sectionInsetFor section: Int) -> UIEdgeInsets? { return nil }
    public func collectionView(_ collectionView: UICollectionView, layout: FTWaterFallLayout, headerHeightFor section: Int) -> CGFloat? { return nil }
    public func collectionView(_ collectionView: UICollectionView, layout: FTWaterFallLayout, headerInsetFor section: Int) -> UIEdgeInsets? { return nil }
    public func collectionView(_ collectionView: UICollectionView, layout: FTWaterFallLayout, footerHeightFor section: Int) -> CGFloat? { return nil }
    public func collectionView(_ collectionView: UICollectionView, layout: FTWaterFallLayout, footerInsetFor section: Int) -> UIEdgeInsets? { return nil }
    public func collectionView(_ collectionView: UICollectionView, layout: FTWaterFallLayout, estimatedSizeForItemAt indexPath: IndexPath) -> CGSize? { return nil }
}

public class FTWaterFallLayout: UICollectionViewFlowLayout {
    
    public static let ft_automaticSize: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)

    public enum DistributionMethod {

        case equal
        case balanced
    }
    
    public enum Layout {
        case flow(column: Int)
        case waterfall(column: Int, distributionMethod :DistributionMethod)

        var column: Int {
            switch self {
            case let .flow(column): return column
            case let .waterfall(column, _): return column
            }
        }
    }

    public struct Const {
        static let minimumLineSpacing: CGFloat = 10.0
        static let minimumInteritemSpacing: CGFloat = 10.0
        static let sectionInset: UIEdgeInsets = .zero
        static let headerHeight: CGFloat = 0.0
        static let headerInset: UIEdgeInsets = .zero
        static let footerHeight: CGFloat = 0.0
        static let footerInset: UIEdgeInsets = .zero
        static let estimatedItemSize: CGSize = CGSize(width: 300.0, height: 300.0)
    }

    public override var minimumLineSpacing: CGFloat {
        get {
            Const.minimumLineSpacing
        }
        set {
            if newValue != minimumLineSpacing {
                invalidateLayout()
            }
        }
    }

    public override var minimumInteritemSpacing: CGFloat {
        get {
            Const.minimumInteritemSpacing
        }
        set {
            if newValue != minimumInteritemSpacing {
                invalidateLayout()
            }
        }
    }

    public override var sectionInset: UIEdgeInsets {
        get {
            Const.sectionInset
        }
        set {
            if newValue != sectionInset {
                invalidateLayout()
            }
        }
    }

    public override var estimatedItemSize: CGSize {
        get {
            Const.estimatedItemSize
        }
        set {
            if newValue != estimatedItemSize {
                invalidateLayout()
            }
        }
    }
    
    public var headerHeight: CGFloat = Const.headerHeight {
        didSet { invalidateLayoutIfChanged(oldValue, headerHeight) }
    }

    public var headerInset: UIEdgeInsets = Const.headerInset {
        didSet { invalidateLayoutIfChanged(oldValue, headerInset) }
    }

    public var footerHeight: CGFloat = Const.footerHeight {
        didSet { invalidateLayoutIfChanged(oldValue, footerHeight) }
    }

    public var footerInset: UIEdgeInsets = Const.footerInset {
        didSet { invalidateLayoutIfChanged(oldValue, footerInset) }
    }

    private lazy var headersAttribute = [Int: UICollectionViewLayoutAttributes]()
    private lazy var footersAttribute = [Int: UICollectionViewLayoutAttributes]()
    private lazy var columnHeights = [[CGFloat]]()
    private lazy var allItemAttributes = [UICollectionViewLayoutAttributes]()
    private lazy var sectionItemAttributes = [[UICollectionViewLayoutAttributes]]()
    private lazy var cachedItemSizes = [IndexPath: CGSize]()

    public weak var delegate: FTWaterFallLayoutDelegate?

    public override func prepare() {
        super.prepare()
        cleaunup()

        guard let collectionView = collectionView else { return }
        guard let delegate = delegate else { return }

        let numberOfSections = collectionView.numberOfSections
        if numberOfSections == 0 { return }

        (0..<numberOfSections).forEach { section in
            let columnCount = delegate.collectionViewLayout(for: section).column
            columnHeights.append(Array(repeating: 0.0, count: columnCount))
        }

        var position: CGFloat = 0.0
        (0..<numberOfSections).forEach { section in
            layoutHeader(position: &position, collectionView: collectionView, delegate: delegate, section: section)
            layoutItems(position: position, collectionView: collectionView, delegate: delegate, section: section)
            layoutFooter(position: &position, collectionView: collectionView, delegate: delegate, section: section)
        }
    }

    public override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView, collectionView.numberOfSections > 0  else {
            return .zero
        }
        var contentSize = collectionView.bounds.size
        contentSize.height = columnHeights.last?.first ?? 0.0
        return contentSize
    }

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.section >= sectionItemAttributes.count {
            return nil
        }
        if indexPath.item >= sectionItemAttributes[indexPath.section].count {
            return nil
        }
        return sectionItemAttributes[indexPath.section][indexPath.item]
    }

    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return allItemAttributes.filter { rect.intersects($0.frame) }
    }

    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        return newBounds.width != (collectionView?.bounds ?? .zero).width
        let same = newBounds.width != (collectionView?.bounds ?? .zero).width
        print(same)
        return same
    }

    override public func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        let same = cachedItemSizes[originalAttributes.indexPath] != preferredAttributes.size
        print("sada", same)
        return same
//        return cachedItemSizes[originalAttributes.indexPath] != preferredAttributes.size
    }

    override public func invalidationContext(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)

        guard let _ = collectionView else { return context }

        let oldContentSize = self.collectionViewContentSize
        cachedItemSizes[originalAttributes.indexPath] = preferredAttributes.size
        let newContentSize = self.collectionViewContentSize
        context.contentSizeAdjustment = CGSize(width: 0, height: newContentSize.height - oldContentSize.height)

        /*
         let indexPaths: [IndexPath] = (originalAttributes.indexPath.item..<collectionView.numberOfItems(inSection: originalAttributes.indexPath.section))
            .map { [originalAttributes.indexPath.section, $0] }
         context.invalidateItems(at: indexPaths)
         */
        _ = context.invalidateEverything
        return context
    }

    private func cleaunup() {
        headersAttribute.removeAll()
        footersAttribute.removeAll()
        columnHeights.removeAll()
        allItemAttributes.removeAll()
        sectionItemAttributes.removeAll()
    }

    private func invalidateLayoutIfChanged<T: Equatable>(_ old: T, _ new: T) {
        if old != new { invalidateLayout() }
    }

    private func layoutHeader(position: inout CGFloat, collectionView: UICollectionView,  delegate: FTWaterFallLayoutDelegate, section: Int) {
        let columnCount = delegate.collectionViewLayout(for: section).column
        let headerHeight = self.headerHeight(for: section)
        let headerInset = self.headerInset(for: section)

        position += headerInset.top

        if headerHeight > 0 {
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: [section, 0])
            attributes.frame = CGRect(
                x: headerInset.left,
                y: position,
                width: collectionView.bounds.width - (headerInset.left + headerInset.right),
                height: headerHeight
            )
            headersAttribute[section] = attributes
            allItemAttributes.append(attributes)

            position = attributes.frame.maxY + headerInset.bottom
        }

        position += sectionInset(for: section).top
        columnHeights[section] = Array(repeating: position, count: columnCount)
    }

    private func pickColumn(itemIndex: Int,
                            delegate: FTWaterFallLayoutDelegate,
                            section: Int) -> Int {

        let layout = delegate.collectionViewLayout(for: section)
        switch layout {
        case .flow:
            let columnCount = delegate.collectionViewLayout(for: section).column
            return itemIndex % columnCount
        case .waterfall(_, let distributionMethod):
            if distributionMethod == .balanced {
                var minIndex: Int = 0
                var minValue = CGFloat.greatestFiniteMagnitude
                columnHeights[section].enumerated().forEach { (index, element) in
                    if element < minValue {
                        minIndex = index
                        minValue = element
                    }
                }
                return minIndex
            } else {
                let columnCount = delegate.collectionViewLayout(for: section).column
                return itemIndex % columnCount
            }
        }
    }

    private func layoutItems(position: CGFloat, collectionView: UICollectionView, delegate: FTWaterFallLayoutDelegate, section: Int) {
        let sectionInset = self.sectionInset(for: section)
        let minimumInteritemSpacing = self.minimumInteritemSpacing(for: section)
        let minimumLineSpacing = self.minimumInteritemSpacing(for: section)

        let columnCount = delegate.collectionViewLayout(for: section).column
        let itemCount = collectionView.numberOfItems(inSection: section)
        let width = collectionView.bounds.width - (sectionInset.left + sectionInset.right)
        let itemWidth = floor((width - CGFloat(columnCount - 1) * minimumLineSpacing) / CGFloat(columnCount))
        let paddingLeft = itemWidth + minimumLineSpacing

        var itemAttributes: [UICollectionViewLayoutAttributes] = []

        (0..<itemCount).forEach { index in
            let indexPath: IndexPath = [section, index]
            let columnIndex = pickColumn(itemIndex: index, delegate: delegate, section: section)

            let itemHeight: CGFloat
            let itemSize = delegate.collectionView(collectionView, layout: self, sizeForItemAt: indexPath)

            if itemSize == FTWaterFallLayout.ft_automaticSize {
                itemHeight = (cachedItemSizes[indexPath] ?? estimatedSizeForItemAt(indexPath)).height
            } else {
                cachedItemSizes[indexPath] = itemSize
                itemHeight = itemSize.height > 0 && itemSize.width > 0 ? floor(itemSize.height * itemWidth / itemSize.width) : 0.0
            }


            let offsetY: CGFloat
            let layout = delegate.collectionViewLayout(for: section)
            switch layout {
            case .flow:
                offsetY = index < columnCount ? position : columnHeights[section][columnIndex]
            case .waterfall:
                offsetY = columnHeights[section][columnIndex]
            }

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(
                x: sectionInset.left + paddingLeft * CGFloat(columnIndex),
                y: offsetY,
                width: itemWidth,
                height: itemHeight
            )
            itemAttributes.append(attributes)
            columnHeights[section][columnIndex] = attributes.frame.maxY + minimumInteritemSpacing

            if case .flow = layout, index % columnCount == columnCount - 1 {
                let maxHeight = columnHeights[section].enumerated().sorted { $0.element > $1.element }.first?.element ?? 0.0
                columnHeights[section] = Array(repeating: maxHeight, count: columnCount)
            }
        }
        allItemAttributes.append(contentsOf: itemAttributes)
        sectionItemAttributes.append(itemAttributes)
    }

    private func layoutFooter(position: inout CGFloat, collectionView: UICollectionView, delegate: FTWaterFallLayoutDelegate, section: Int) {
        let sectionInset = self.sectionInset(for: section)
        let minimumInteritemSpacing = self.minimumInteritemSpacing(for: section)
        let columnCount = delegate.collectionViewLayout(for: section).column
        let longestColumnIndex = columnHeights[section].enumerated().sorted { $0.element > $1.element }.first?.offset ?? 0

        if columnHeights[section].count > 0 {
            position = columnHeights[section][longestColumnIndex] - minimumInteritemSpacing + sectionInset.bottom
        } else {
            position = 0.0
        }
        let footerHeight = self.footerHeight(for: section)
        let footerInset = self.footerInset(for: section)
        position += footerInset.top

        if footerHeight > 0.0 {
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: [section, 0])
            attributes.frame = CGRect(x: footerInset.left, y: position, width: collectionView.bounds.width - (footerInset.left + footerInset.right), height: footerHeight)
            footersAttribute[section] = attributes
            allItemAttributes.append(attributes)
            position = attributes.frame.maxY + footerInset.bottom
        }
        columnHeights[section] = Array(repeating: position, count: columnCount)
    }

    private func minimumInteritemSpacing(for section: Int) -> CGFloat {
        return collectionView.flatMap { delegate?.collectionView($0, layout: self, minimumInteritemSpacingFor: section) } ?? minimumInteritemSpacing
    }

    private func minimumLineSpacing(for section: Int) -> CGFloat {
        return collectionView.flatMap { delegate?.collectionView($0, layout: self, minimumLineSpacingFor: section) } ?? minimumLineSpacing
    }

    private func sectionInset(for section: Int) -> UIEdgeInsets {
        return collectionView.flatMap { delegate?.collectionView($0, layout: self, sectionInsetFor: section) } ?? sectionInset
    }

    private func headerHeight(for section: Int) -> CGFloat {
        return collectionView.flatMap { delegate?.collectionView($0, layout: self, headerHeightFor: section) } ?? headerHeight
    }

    private func headerInset(for section: Int) -> UIEdgeInsets {
        return collectionView.flatMap { delegate?.collectionView($0, layout: self, headerInsetFor: section) } ?? headerInset
    }

    private func footerHeight(for section: Int) -> CGFloat {
        return collectionView.flatMap { delegate?.collectionView($0, layout: self, footerHeightFor: section) } ?? footerHeight
    }

    private func footerInset(for section: Int) -> UIEdgeInsets {
        return collectionView.flatMap { delegate?.collectionView($0, layout: self, footerInsetFor: section) } ?? footerInset
    }

    private func estimatedSizeForItemAt(_ indexPath: IndexPath) -> CGSize {
        return collectionView.flatMap { delegate?.collectionView($0, layout: self, estimatedSizeForItemAt: indexPath) } ?? estimatedItemSize
    }
    
}
