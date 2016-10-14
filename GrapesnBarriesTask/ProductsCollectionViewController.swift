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
    
    // reusable header view
    @IBOutlet weak var headerView: UIView!
    
    // MARK: Global Constants
    let patchCount = 3
    let headerReuseIdentifier = "HeaderView"
    
    // MARK: Global Variables
    var labelFont: UIFont!
    var scrollViewReachedBottom = false
    var userIsScrolling = false
    var getNextThreeProducts: (() -> Void)!
    var products: [Product]? {
        didSet {
            //clear cache layout to calculate new layout for the new data
            (collectionView?.collectionViewLayout as? ProductsLayout)?.clearLayout()
            updateUI()
        }
    }
    
    // update collection view cells and layout
    @objc private func updateUI() {
        
        DispatchQueue.main.async {
            print("Update UI")
            self.collectionView?.reloadData()
        }
    }
    
    func updateCell(notification: NSNotification) {
        
        let sender = notification.object
        
        if let product = sender as? Product {
            let index = product.id
            let indexPath = IndexPath(item: index, section: 0)
            
            DispatchQueue.main.async {
                let validIndices = self.collectionView?.visibleCells.map { self.collectionView!.indexPath(for: $0)! }
                if let exists = validIndices?.contains(where: { $0 == indexPath  }) , exists, self.userIsScrolling {
                    print("Cell \(indexPath.item) exists")
                    self.collectionView?.reloadItems(at: [indexPath])
                    
                    print("Updating Cell \(indexPath.item)")
                }
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //set custom layout delegate
        if let layout = collectionView?.collectionViewLayout as? ProductsLayout {
            layout.delegate = self
        }
        
        // set view visual look
        if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
        collectionView!.backgroundColor = UIColor.clear
        collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        
        collectionView?.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        
        //register for notification that product images finished downloading in the backgroud
        NotificationCenter.default.addObserver(self, selector: #selector(updateCell(notification:)), name: Notification.Name(rawValue: imageDataDidFinishedDownloadingNotification), object: nil)
        
        // get products fetcher
        getNextThreeProducts = makeProductsFetcher()
        
        getNextThreeProducts()
        getNextThreeProducts()

    }

    // MARK: scrollView Delegate Methods
    
    // when scroll ends add new cells
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if collectionView?.window == nil { return }
        
        let offsetTolerance = CGFloat(30)
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height + offsetTolerance, !scrollViewReachedBottom {
            print("scroll ended")
            getNextThreeProducts()
            scrollViewReachedBottom = true
        } else if offsetY < contentHeight - scrollView.frame.size.height - offsetTolerance {
            scrollViewReachedBottom = false
        }

    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        userIsScrolling = true
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        userIsScrolling = true
    }
    
    func fetchProducts(fromID startID:Int, count patchCount:Int) {
        
        GnBClient.sharedInstance().getProducts(fromID: startID , count: patchCount, products: { (productsArray) in
            
            guard self.products != nil || productsArray != nil else { return }
            self.products = (self.products ?? [Product]()) + (productsArray ?? [Product]())
            self.reorderProducts()
            print("\(patchCount) Products fetched starting from ID: \(startID)")
            
        })
    }
    
    func reorderProducts() {
        
        products?.sort { $0.id < $1.id }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        

        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! HeaderReusableView
        
        headerView.frame = reusableView.bounds
        reusableView.addSubview(headerView)
        
        return reusableView        
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (products?.count) ?? 2
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductsCollectionViewCell
    
        // Configure the cell
        
        //clear cache for reusable cells to clean cached images
        cell.clearCache()
        
        cell.product = products?[indexPath.item]
        
        //need font to calculate label height at runtime
        labelFont = cell.productDescription.font
        
        return cell
    }

}


extension ProductsCollectionViewController : ProductsLayoutDelegate {
    
    //get height of product's image for given width maintaining aspect ratio
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
    
    // get height for description text for a given font
    func heightForDescriptionAtIndexPath(indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
    
        let cellPadding = CGFloat(4)
        let textHeight = products?[indexPath.item].heightForDescription(font: labelFont, width: width)
        
        if let height = textHeight {
            return cellPadding + height + cellPadding
        } else {
            return CGFloat.leastNonzeroMagnitude
        }
        
    }
    
    // return fetcher function to fetch products
    func makeProductsFetcher() -> () -> Void {
        
        var startID = 0
        
        func fetchNextPatch() {
            
            fetchProducts(fromID: startID, count: patchCount)
            
            startID += patchCount
        }
        
        return fetchNextPatch
    }
    
}
