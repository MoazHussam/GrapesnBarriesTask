//
//  ProductsCollectionViewController.swift
//  GrapesnBarriesTask
//
//  Created by Moaz Ahmed on 10/11/16.
//  Copyright © 2016 Moaz Ahmed. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ProductsCell"

class ProductsCollectionViewController: UICollectionViewController {
    
    var products: [Product]? {
        didSet {
//            DispatchQueue.main.async {
//                self.collectionView!.reloadData()
//            }
            updateUI()
        }
    }
    
    @objc private func updateUI() {
        
        DispatchQueue.main.async {
            self.collectionView!.reloadData()
        }
    }
    
    private let leftAndRightPaddings: CGFloat = 24.0
    private let numberOfItemsPerRow: CGFloat = 2.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        let width = (collectionView!.frame.width - leftAndRightPaddings) / numberOfItemsPerRow
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width * 3.5)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name(rawValue: imageDataHasFinishedDownloadingNotification), object: nil)
        
        GnBClient.sharedInstance().getProducts(fromID: 0, count: 14, products: { (productsArray) in
            
            self.products = productsArray!
            print(self.products)
            
        })


        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        updateUI()
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
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
