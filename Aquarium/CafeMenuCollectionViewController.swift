//
//  CafeMenuCollectionViewController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 7/29/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//

import UIKit
import Foundation


class CafeMenuCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
  
    let menus = [#imageLiteral(resourceName: "Reef cafe Menu1"), #imageLiteral(resourceName: "Reef cafe Menu2"), #imageLiteral(resourceName: "Reef cafe Menu3"), #imageLiteral(resourceName: "Reef cafe Menu4")]
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
   
    @IBOutlet weak var bottomTrayView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomTrayView.backgroundColor = aquaLight
        view.backgroundColor = aquaLight
    }


    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menus.count
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageWidth = self.collectionView.frame.size.width
        pageControl.currentPage = Int(self.collectionView.contentOffset.x / pageWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuCollectionViewCell
        
        cell.menuImage.image = menus[indexPath.row]
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
