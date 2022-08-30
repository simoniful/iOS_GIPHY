//
//  PinterestLayout.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, RatioForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
    func numberOfItemsInCollectionView() -> Int
}

class PinterestLayout: UICollectionViewLayout {
    weak var delegate: PinterestLayoutDelegate?
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 8.0
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        let collectionViewItemCount = delegate?.numberOfItemsInCollectionView() ?? 0
        guard cache.isEmpty || collectionViewItemCount > cache.count, let collectionView = collectionView else { return }
        contentHeight = 0
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        for index in 0..<yOffset.count {
            yOffset[index % numberOfColumns] = cache.last(where: {$0.indexPath.row % numberOfColumns == index % numberOfColumns})?.frame.maxY ?? 0
        }
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            if indexPath.row >= cache.count {
                let photoHeight = (delegate?.collectionView(
                    collectionView,
                    RatioForPhotoAtIndexPath: indexPath))! * columnWidth
                
                let height = cellPadding * 2 + photoHeight
                let frame = CGRect(x: xOffset[column],
                                   y: yOffset[column],
                                   width: columnWidth,
                                   height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                
                column = column < (numberOfColumns - 1) ? (column + 1) : 0
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}

//class RxPinterestLayoutProxy: DelegateProxy<PinterestLayout, PinterestLayoutDelegate>, DelegateProxyType, PinterestLayoutDelegate {
//
//    static func registerKnownImplementations() {
//        self.register { (pinterestLayout) -> RxPinterestLayoutProxy in
//            RxPinterestLayoutProxy(parentObject: pinterestLayout, delegateProxy: self)
//        }
//    }
//
//    static func currentDelegate(for object: PinterestLayout) -> PinterestLayoutDelegate? {
//        return object.delegate
//    }
//
//    static func setCurrentDelegate(_ delegate: PinterestLayoutDelegate?, to object: PinterestLayout) {
//        object.delegate = delegate
//    }
//}
//
//extension Reactive where Base: PinterestLayout {
//    var rx_delegate: DelegateProxy<PinterestLayout, PinterestLayoutDelegate> {
//        return RxPinterestLayoutProxy.proxy(for: self.base)
//    }
//
//    var rx_RatioForPhotoAtIndexPath: Observable<CGFloat?> {
//        return rx_delegate.sentMessage(#selector(PinterestLayoutDelegate.collectionView(_:RatioForPhotoAtIndexPath:))).map { arr in arr[0] as? CGFloat }
//    }
//}


