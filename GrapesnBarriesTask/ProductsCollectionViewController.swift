//
//  ProductsCollectionViewController.swift
//  GrapesnBarriesTask
//
//  Created by Moaz Ahmed on 10/11/16.
//  Copyright © 2016 Moaz Ahmed. All rights reserved.
//

import UIKit
import AVFoundation

private let reuseIdentifier = "ProductsCell"

class ProductsCollectionViewController: UICollectionViewController {
    
    var labelHeights = [IndexPath:CGFloat]()
    var fontd: UIFont!
    
    var products: [Product]? {
        didSet {
//            DispatchQueue.main.async {
//                self.collectionView!.reloadData()
//            }
            updateUI()
        }
    }
    
    @objc private func updateUI() {
        
        (collectionView?.collectionViewLayout as? ProductsLayout)?.clearLayout()
        DispatchQueue.main.async {
            self.collectionView!.reloadData()
        }
    }
    
//    private let leftAndRightPaddings: CGFloat = 24.0
//    private let numberOfItemsPerRow: CGFloat = 2.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
//        let width = (collectionView!.frame.width - leftAndRightPaddings) / numberOfItemsPerRow
//        let layout = collectionViewLayout as! UICollectionViewFlowLayout
//        layout.itemSize = CGSize(width: width, height: width * 2)

        if let layout = collectionView?.collectionViewLayout as? ProductsLayout {
            layout.delegate = self
        }
        
        if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
        collectionView!.backgroundColor = UIColor.clear
        
        collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name(rawValue: imageDataDidFinishedDownloadingNotification), object: nil)
        
        GnBClient.sharedInstance().getProducts(fromID: 0, count: 14, products: { (productsArray) in
            
            self.products = productsArray!
            print(self.products)
            
        })


        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        //updateUI()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (products?.count) ?? 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductsCollectionViewCell
    
        // Configure the cell
        
        cell.product = products?[indexPath.item]
        //labelHeights[indexPath] = cell.productDescription.requiredHeight()
        fontd = cell.productDescription.font
        
        return cell
    }

}


extension ProductsCollectionViewController : ProductsLayoutDelegate {
    
    func heightForImageAtIndexPath(indexPath:IndexPath , withWidth width:CGFloat) -> CGFloat {
        
        let product = products?[indexPath.item]
        if let imageHeight = product?.imageSize?.height, let imageWidth = product?.imageSize?.width {
            
            //get image height for current image width while maintaining aspect ratio
            let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
            
            let rect  = AVMakeRect(aspectRatio: CGSize(width: imageWidth, height: imageHeight), insideRect: boundingRect)
            
            return rect.size.height
        }
        
        return width
    }
    
    func heightForDescriptionAtIndexPath(indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
    
        let cellPadding = CGFloat(4)
        let textHeight = products?[indexPath.item].heightForDescription(font: fontd, width: width)
        
        if let height = textHeight {
            return cellPadding + height + cellPadding
        } else {
            return CGFloat.leastNonzeroMagnitude
        }
        
    }
    
    
}


extension UILabel{
    
    func requiredHeight(width: CGFloat) -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRect(x:0, y:0, width:width, height:CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.font = self.font
        label.text = self.text
        
        label.sizeToFit()
        
        print("Label required Height: \(label.frame.height)")
        
        return label.frame.height
    }
    
    func requiredHeight() -> CGFloat{
        
        
        return requiredHeight(width: self.frame.width)
    }
}
