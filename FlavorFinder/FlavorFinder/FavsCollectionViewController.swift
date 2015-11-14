////
////  FavsCollectionViewController.swift
////  FlavorFinder
////
////  Created by Jaki Kimball on 11/12/15.
////  Copyright © 2015 TeamFive. All rights reserved.
////
//
//import UIKit
//
//class FavsCollectionViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//    
//    @IBOutlet var collectionView: UICollectionView?
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
//        layout.itemSize = CGSize(width: 90, height: 90)
//        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
//        collectionView!.dataSource = self
//        collectionView!.delegate = self
//        collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
//        collectionView!.backgroundColor = UIColor.whiteColor()
//        self.view.addSubview(collectionView!)
//    }
//    
//    
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 20
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as CollectionViewCell
//        cell.backgroundColor = UIColor.blackColor()
//        cell.textLabel?.text = "\(indexPath.section):\(indexPath.row)"
//        cell.imageView?.image = UIImage(named: "circle")
//        return cell
//    }
//
//}
