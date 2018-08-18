//
//  GalleryPhotoViewController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 8/3/18.
//  Copyright © 2018 Forrest Syrett. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI
import SDWebImage
import Hero
import AnimatedCollectionViewLayout

class GalleryPhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var changeScrollTypebutton: UIButton!
    
    var images = [UIImage]()
    var selectedIndex = Int()
    var references = [FIRStorageReference]()
    var heroID = ""
    var scrollType = 1
    var layout = AnimatedCollectionViewLayout()
    
    var tapCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeScrollTypebutton.titleLabel?.text = "\(tapCount)"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.layout.animator = ParallaxAttributesAnimator()
       layoutCollectionView(layoutType: self.layout)
   
        let index = IndexPath(row: selectedIndex, section: 0)
        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
        self.collectionView.reloadData()
        
    }
    
    
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func scrollType(_ sender: Any) {
        
        tapCount += 1
        changeScrollTypebutton.titleLabel?.text = "\(tapCount)"
    
        if scrollType >= 7 {
            scrollType = 0
        }
        
        if tapCount == 3 {
        scrollType += 1
        switch scrollType {
        case 1: self.layout.animator = ParallaxAttributesAnimator()
        case 2: self.layout.animator = ZoomInOutAttributesAnimator()
        case 3: self.layout.animator = RotateInOutAttributesAnimator()
        case 4: self.layout.animator = LinearCardAttributesAnimator()
        case 5: self.layout.animator = CrossFadeAttributesAnimator()
        case 6: self.layout.animator = CubeAttributesAnimator()
        case 7: self.layout.animator = PageAttributesAnimator()
        default: break
        }
        
        layoutCollectionView(layoutType: self.layout)
        self.collectionView.reloadData()
            tapCount = 0
        }
        
    }
    
    func layoutCollectionView(layoutType: AnimatedCollectionViewLayout) {
        
        let layout = AnimatedCollectionViewLayout()
        layout.animator = layoutType.animator
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
    }
    
    func scrollToStart() {
        
      //  Could reset collectionView to beginning when changing the scroll type
        
    }
    
    
    
    
    // MARK: - Collection View Methods
    
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return references.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoViewerCollectionViewCell
        let index = indexPath.row

        cell.photoImage.hero.modifiers = [.fade]
        cell.photoImage.hero.id = "photo: \(index)"
        
        cell.photoImage.sd_setImage(with: references[index])
        return cell
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionView.frame.width - 10.0), height: collectionView.frame.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        // Get CollectionView height and center the cell vertically.
        let cellWidth = self.collectionView.frame.width - 10.0
        let cellHeight = cellWidth / 3
        let topInset = (collectionView.frame.height - cellHeight) / 2
        let bottomInset = topInset
        
        return UIEdgeInsets.init(top: topInset, left: 5.0, bottom: bottomInset, right: 5.0)
    }
    
    

}
