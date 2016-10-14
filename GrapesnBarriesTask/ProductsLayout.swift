//
//  ProductsLayout.swift
//  GrapesnBarriesTask
//
//  Created by Moaz Ahmed on 10/12/16.
//  Copyright © 2016 Moaz Ahmed. All rights reserved.
//

import UIKit

protocol ProductsLayoutDelegate {
    // 1. Method to ask the delegate for the height of the image
    func heightForImageAtIndexPath(indexPath:IndexPath , withWidth:CGFloat) -> CGFloat
    // 2. Method to ask the delegate for the height of the description text text
    func heightForDescriptionAtIndexPath(indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
}


class ProductsLayoutAttributes: UICollectionViewLayoutAttributes {
    
    // 1. Custom attribute
    var imageHeight: CGFloat = 0.0
    
    // 2. Override copyWithZone to conform to NSCopying protocol
    override func copy(with zone: NSZone?) -> Any {
        let copy = super.copy(with: zone) as! ProductsLayoutAttributes
        copy.imageHeight = imageHeight
        return copy
    }
    
    // 3. Override isEqual
    override func isEqual(_ object: Any?) -> Bool {
        if let attributtes = object as? ProductsLayoutAttributes {
            if( attributtes.imageHeight == imageHeight  ) {
                return super.isEqual(object)
            }
        }
        return false
    }
}

class ProductsLayout: UICollectionViewLayout {

    
    var delegate: ProductsLayoutDelegate!
    
    var numberOfColumns = 2
    var cellPadding: CGFloat = 6.0
    var headerHeight: CGFloat = 100.0
    
    private var cache = [ProductsLayoutAttributes]()
    
    fileprivate var contentHeight: CGFloat = 0.0
    fileprivate var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    override class var layoutAttributesClass : AnyClass {
        return ProductsLayoutAttributes.self
    }
    
    override func prepare() {
        
        if cache.isEmpty {
            
            // Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            var column = 0
            var yOffset = [CGFloat](repeating: headerHeight + cellPadding * 2, count: numberOfColumns)
            
            // 3. Iterates through the list of items in the first section
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                
                let indexPath = IndexPath(item: item, section: 0)
                
                // 4. Asks the delegate for the height of the image and the description and calculates the cell frame.
                let width = columnWidth - cellPadding*2
                let imageHeight = delegate.heightForImageAtIndexPath(indexPath: indexPath , withWidth:width)
                let descriptionHeight = delegate.heightForDescriptionAtIndexPath(indexPath: indexPath, withWidth: width)
                let height = cellPadding +  imageHeight + descriptionHeight + cellPadding
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
                let attributes = ProductsLayoutAttributes(forCellWith: indexPath)
                attributes.imageHeight = imageHeight
                attributes.frame = insetFrame
                cache.append(attributes)
                
                // 6. Updates the collection view content height
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                
                column = column >= (numberOfColumns - 1) ? 0 : column + 1
            }
        }
    }
    
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    func clearLayout() {
        cache.removeAll()
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if elementKind == UICollectionElementKindSectionHeader {
            
            return getHeaderAttributes(for: indexPath)
            
        }
        return nil
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes  in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        
        if rect.intersects(CGRect(x: 0, y: 0, width: contentWidth, height: 150)) {
        
            let headerAttribute = getHeaderAttributes(for: IndexPath(item: 0, section: 0))
            
            layoutAttributes.append(headerAttribute)
        }
        
        return layoutAttributes
    }
    
    fileprivate func getHeaderAttributes(for indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        
        let frame = CGRect(x: 0, y: 0, width: contentWidth, height: 100)
        let headerAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
        let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
        headerAttribute.frame = insetFrame
        headerHeight = insetFrame.height
        return headerAttribute

    }
    
    
    
}
