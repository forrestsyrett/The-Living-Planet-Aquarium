//
//  AnimalDetailViewController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 11/26/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import UIKit
import QuartzCore
import FirebaseStorageUI
import Hero


class AnimalDetailViewController: UIViewController, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var animalNameLabel: UILabel!
    
    @IBOutlet weak var animalImage: UIImageView!
    
    @IBOutlet weak var animalInfo: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var ThreeDView: UIButton!
    
    //@IBOutlet weak var conservationStatusImage: UIImageView!
    
    @IBOutlet weak var animalFactSheet: UIImageView!
    
    @IBOutlet weak var factSheetHeight: NSLayoutConstraint!
    
    @IBOutlet weak var animalNewsButton: UIButton!

    @IBOutlet weak var animalNewsBUttonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var panView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    var name = ""
    var image = UIImageView()
    var info = ""
    var imageReference = ""
    var animal = "none"
    var status = "none"
    var imageType = "animal"
    var animalUpdates = ""
    var imageHeroID = ""
    var titleLabelHeroID = ""
    var dismissButtonHeroID = ""
    var factSheetString = ""
    var updateImage = ""
    var infoImageHeroID = ""
    var timer = Timer()
    var time = 0
    
    var images: [UIImage] = []
    var imageID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient(self.view)
        dismissButton.layer.cornerRadius = 19.5
        ThreeDView.layer.cornerRadius = 5.0
          collectionView.isHidden = true
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetViewController.panGesture))
        
        panView.addGestureRecognizer(gesture)
        
        gesture.delegate = self
        
        let sharkImage = UIImage(named: "Shark")!
        let orangeFish = UIImage(named: "OrangeFish")!
        images = [sharkImage, orangeFish]
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    
        self.infoButton.alpha = 0.0
        self.animalNewsBUttonHeight.constant = 0.0
        self.view.layoutIfNeeded()
        
        let reference = FIRStorageReference().child(self.imageReference)
        let factSheetReference = FIRStorageReference().child("factSheets/\(self.factSheetString)")
        let galleryReference = FIRStorageReference().child("GalleryImages/\(name)/\(imageID)")

        self.animalImage.sd_setShowActivityIndicatorView(true)
        self.animalFactSheet.sd_setShowActivityIndicatorView(true)
        self.animalImage.sd_setImage(with: reference)
        self.animalFactSheet.sd_setImage(with: factSheetReference)
        self.animalNameLabel.text = name
        self.animalInfo.text = info
        animalImage.layer.cornerRadius = 5.0
        animalImage.clipsToBounds = true
        
        if self.factSheetString == "" {
            self.factSheetHeight.constant = 0.0
        }
        
        self.animalImage.hero.id = self.imageHeroID
        self.animalNameLabel.hero.id = self.titleLabelHeroID
        self.dismissButton.hero.id = self.dismissButtonHeroID
        self.infoButton.hero.id = self.infoImageHeroID
        
        // Added to test 3D model functionality. Will hide button if no 3D Model is available.
      //  if self.name == "Blacktip Reef Shark" {
        //    self.ThreeDView.isHidden = false
            
       // } else {
            self.ThreeDView.isHidden = true
        // }
        
   /*
        switch self.status {
        case "Least Concern": conservationStatusImage.image = #imageLiteral(resourceName: "LeastConcern")
        case "Near Threatened": conservationStatusImage.image = #imageLiteral(resourceName: "NearThreatened")
        case "Vulnerable": conservationStatusImage.image = #imageLiteral(resourceName: "Vulnerable")
        case "Endangered": conservationStatusImage.image = #imageLiteral(resourceName: "Endangered")
        case "Critically Endangered": conservationStatusImage.image = #imageLiteral(resourceName: "CriticallyEndangered")
        case "Extinct in the Wild": conservationStatusImage.image = #imageLiteral(resourceName: "Extinct_In_Wild")
        default: conservationStatusImage.image = #imageLiteral(resourceName: "Unknown")
        }
 */
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        animateRibbon()
    
    }
    
    func randomNumber(low: Int, high: Int) -> CGFloat {
        let random = CGFloat(arc4random_uniform(UInt32(high)) + UInt32(low))
        return random
    }
    
    
    @IBAction func segmentedControlTapped(_ sender: Any) {
        
        
        switch segmentedControl.selectedSegmentIndex {
            
        case 0: scrollView.isHidden = false
            collectionView.isHidden = true
            
        case 1: scrollView.isHidden = true
            collectionView.isHidden = false
            collectionView.reloadData()
            print(collectionView.numberOfItems(inSection: 0))
            
        default: break
        }
        
        
    }
    
    
    

    @objc func bubbles() {
        
        time += 1
   //     print("Time \(time)")
        if self.time == 2 {
            UIView.animate(withDuration: 0.3, animations: {
                self.infoButton.alpha = 1.0
                self.infoButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.infoButton.transform = CGAffineTransform.identity
            })
        }
        
        else if self.time == 10 {
            timer.invalidate()
      //      print("Time \(time)")
            self.time = 0
        }
        
        let size = randomNumber(low: 8, high: 15)
     //   print("SIZE: \(size)")
        let xLocation = randomNumber(low: 19, high: 45)
    //    print("X LOCATION: \(xLocation)")
        
        let bubbleImageView = UIImageView(image: UIImage(named: "Bubble"))
        bubbleImageView.frame = CGRect(x: xLocation, y: infoButton.center.y + 50, width: size, height: size)
        view.addSubview(bubbleImageView)
        view.bringSubview(toFront: bubbleImageView)
        
        let zigzagPath = UIBezierPath()
        let originX: CGFloat = xLocation
        let originY: CGFloat = infoButton.center.y + 20
        let eX: CGFloat = originX
        let eY: CGFloat = originY - randomNumber(low: 50, high: 30)
        let t: CGFloat = randomNumber(low: 20, high: 100)
        var startPoint = CGPoint(x: originX - t, y: ((originY + eY) / 2))
        var endPoint = CGPoint(x: originX + t, y: startPoint.y)
        
        let r: Int = Int(arc4random() % 2)
        if r == 1 {
            let temp: CGPoint = startPoint
            startPoint = endPoint
            endPoint = temp
        }
        // the moveToPoint method sets the starting point of the line
        zigzagPath.move(to: CGPoint(x: originX, y: originY))
        // add the end point and the control points
        zigzagPath.addCurve(to: CGPoint(x: eX, y: eY), controlPoint1: startPoint, controlPoint2: endPoint)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({() -> Void in
            
            UIView.transition(with: bubbleImageView, duration: 0.1, options: .transitionCrossDissolve, animations: {() -> Void in
                bubbleImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: {(_ finished: Bool) -> Void in
                bubbleImageView.removeFromSuperview()
            })
        })
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.duration = 1.5
        pathAnimation.path = zigzagPath.cgPath
        // remains visible in it's final state when animation is finished
        // in conjunction with removedOnCompletion
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.isRemovedOnCompletion = false
        bubbleImageView.layer.add(pathAnimation, forKey: "movingAnimation")
        
        CATransaction.commit()
        
    }
    
    @IBAction func toModelButtonTapped(_ sender: Any) {
        
        if self.name == "Blacktip Reef Shark" {
            self.performSegue(withIdentifier: "toModel", sender: self)
        }
    }
    

    @IBAction func dismissButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissOutside(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func animalNewsButtonTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "animalNotification", sender: nil)
    }
    @IBAction func animalNotificationButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "animalNotification", sender: nil)
    }
    
    func animateRibbon() {
        if self.animalUpdates == "none" {
            self.animalNewsBUttonHeight.constant = 0.0
            self.infoButton.alpha = 0.0
            self.view.layoutIfNeeded()
        } else {
            
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(AnimalDetailViewController.bubbles), userInfo: nil, repeats: true)
            timer.fire()
            
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
                self.animalNewsBUttonHeight.constant = 78.0
                self.view.layoutIfNeeded()
            }, completion: nil)

        }
    }
    
    
    func updateInfo(animal: AnimalTest) {
        self.name = animal.animalName ?? ""
        self.info = animal.animalInfo ?? ""
        self.status = animal.conservationStatus ?? ""
        self.imageReference = animal.animalImage ?? ""
        self.factSheetString = animal.factSheet ?? ""
        self.animalUpdates = animal.animalUpdates ?? ""
        self.updateImage = animal.updateImage ?? ""
    }
    
    
    // Mark: - CollectionView Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return images.count
        
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath) as! GalleryCollectionViewCell
        let index = indexPath.row
        
       let thumbnail = self.images[index]
        
        cell.thumbnailImage.image = thumbnail
        
        
        
        //Get odd numbers (right column)
        if indexPath.row % 2 == 1 {
            cell.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0.0)
        } else {
            //Left column
            cell.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0.0)
        }

        // Show cascade animation on first load
        
        var delay = 0.05 * Double(index) / 2
        if cell.didAnimate == false {
            delay = 0.05 * Double(index) / 2
            
            UIView.animate(withDuration: 0.85, delay: delay, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.1, options: .allowUserInteraction, animations: {
                cell.transform = CGAffineTransform.identity
                cell.layoutIfNeeded()
                cell.didAnimate = true
            }, completion: nil)
        } else {
            cell.transform = CGAffineTransform.identity
        }
        
        cell.layer.cornerRadius = 5.0
        
        return cell
        
        
    }

    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((self.collectionView.frame.width / 2) - 12), height: collectionView.frame.height / 3.75)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    
    
    
    
    

    
    
 @objc func panGesture(recognizer: UIPanGestureRecognizer) {
    
    
    let translation = recognizer.translation(in: self.panView)
    let progress = translation.y / 2 / self.panView.bounds.height
    switch recognizer.state {
    case .began:
        Hero.shared.defaultAnimation = .fade
        hero.dismissViewController()
    case .changed:
        Hero.shared.update(progress)
        
    default:
        if progress + recognizer.velocity(in: nil).y / self.panView.bounds.height > 0.3 {
            Hero.shared.finish()
        } else {
            Hero.shared.cancel()
        }
    }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? AnimalNotificationsViewController {
            
            destination.updateInfo = self.animalUpdates
            destination.imageReference = self.updateImage
            
            
        }
    }
    
    
}


extension UIPanGestureRecognizer {
    
    func isUp(view: UIView) -> Bool {
        
        let direction: CGPoint = velocity(in: view)
        if direction.y < 0 {
            // Panning up
           
            return true
        } else {
            // Panning Down
          
            return false
        }
    }
}
