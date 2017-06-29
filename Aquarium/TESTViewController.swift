//
//  QRScannerViewController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 6/17/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import UIKit
import AVFoundation
import SafariServices
import Firebase
import FirebaseStorage
import FirebaseStorageUI
import RQShineLabel

class TESTViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, SFSafariViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, QRAnimalCollectionViewDelegate {
    
    
    @IBOutlet weak var QRModalView: UIView!
    @IBOutlet weak var qrWelcomeTextField: UITextView!
    @IBOutlet weak var getStartedButtonLabel: UIButton!
    @IBOutlet weak var qrCodeResult: UILabel!
    @IBOutlet weak var photoFrameImage: UIImageView!
    @IBOutlet weak var alignQRCodeLabel: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var barcodeViewFinder: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dismissCollectionView: UIButton!
    @IBOutlet weak var dismissView: UIVisualEffectView!
    @IBOutlet weak var aquaWave: UIImageView!
    @IBOutlet weak var QRScannerLabel: UILabel!
    
    @IBOutlet weak var QRAnimalViewYConstraint: NSLayoutConstraint!
    @IBOutlet weak var QRAnimalView: UIView!
    @IBOutlet weak var containerViewForDismiss: UIView!
    
    @IBOutlet weak var dismissBarcodeScanner: UIButton!
    
    @IBOutlet weak var foundAnimalsview: UIView!
    @IBOutlet weak var foundAnimalsViewXConstraint: NSLayoutConstraint!
    @IBOutlet weak var foundAnimalsViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var exhibitNameLabel: RQShineLabel!
    
    var animals: [AnimalTest] = []
    var organizedAnimals: [AnimalTest] = []
    var foundAnimals: [AnimalTest] = []
    var foundAnimalsViewIsShown = false
    var resetFoundAnimals = false
    var initialScan = true
    
    
    var collectionViewLocation: CGFloat = 0.0
    var foundAnimalsViewLocation: CGFloat = 0.0
    var QRViewIsVisible = false
    var firebaseReference: FIRDatabaseReference!
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var scanType = "qr"
    var result = ""
    var previousResult = ""
    var dataType = AVMetadataObjectTypeQRCode
    var resetExhibit = false
    var oneScan = false
    
    
    
        func initializeQRView() {
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.blue.cgColor
        qrCodeFrameView?.layer.borderWidth = 5
        self.view.addSubview(aquaWave)
        self.view.addSubview(QRScannerLabel)
        self.view.addSubview(qrCodeFrameView!)
        self.view.addSubview(photoFrameImage)
        self.view.addSubview(alignQRCodeLabel)
        self.view.addSubview(self.QRAnimalView)
        self.view.addSubview(self.dismissView)
        self.view.addSubview(self.dismissBarcodeScanner)
        self.view.addSubview(self.foundAnimalsview)
        self.view.addSubview(barcodeViewFinder)
    }
    
    
    
    
        let qrResult = "Coral Reef"
    
    func testCapture() {
        if qrResult != "" && self.scanType == "barCode" {
            print("Barcode result: \(qrResult).")
            self.performSegue(withIdentifier: "unwindToAddNewMembership", sender: nil)
            captureSession?.stopRunning()
            
            // QR Code Scanned
        } else if qrResult != "" {
            // Do something with specific QR information. (Show exhibit animals)
            self.result = "\(qrResult)"
            
            if self.initialScan == true {
                self.organizeAndShowAnimals()
                self.previousResult = result
            } else {
                
                if self.QRViewIsVisible == false {
                    
                    if self.previousResult != result {
                        if self.oneScan == false {
                            self.scannedNewExhibitAlert()
                        }
                        
                        
                    } else {
                        self.organizeAndShowAnimals()
                    }
                }
            }
        }
    }
    
    @IBAction func scanButtonTapped(_ sender: AnyObject) {
        
    }
    
    
    
    
    func organizeAndShowAnimals() {
        
        self.alertWithExhibit(completion: { (true) in
            
            // check if CollectionView is already up and animals array isn't empty
            if self.QRViewIsVisible == false && self.organizedAnimals.count != 0 {
                self.animateUp()
                self.exhibitNameLabel.text = "Welcome to the \(self.result) exhibit!"
            } else if self.organizedAnimals.count == 0 {
                print("No animals yet, animation will be delayed")
            }
        })
    }
    
    
    func scannedNewExhibitAlert() {
        self.oneScan = true
        let alert = UIAlertController(title: "Start searching a new exhibit?", message: "If you scan a new exhibit your previously found animals will be cleared.", preferredStyle: .alert)
        let clearAction = UIAlertAction(title: "Search", style: .destructive, handler: { (action) in
            
            self.QRViewIsVisible = false
            self.foundAnimals = []
            self.previousResult = "New Exhibit"
            self.organizeAndShowAnimals()
            self.previousResult = self.result
            self.resetFoundAnimals = true
            self.oneScan = false
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            self.oneScan = false
        })
        alert.addAction(cancelAction)
        alert.addAction(clearAction)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func failedScanAlert() {
        let alert = UIAlertController(title: "Scan failed", message: "Please try again.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func openURL() {
        
        let qrResult = result
        guard let url = URL(string: qrResult) else {
            return
        }
        
        if ["http", "https"].contains(url.scheme!.lowercased()) {
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true, completion: nil)
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        } else { return }
    }
    
    
    
    func qrOn(_ isOn: Bool = false) {
        if isOn {

            initializeQRView()
        }}
    
    
    // MARK: - View LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.exhibitNameLabel.adjustsFontSizeToFitWidth = true
        
        self.firebaseReference = FIRDatabase.database().reference()
        
        self.collectionViewLocation = UIScreen.main.bounds.height - UIScreen.main.bounds.height - self.QRAnimalView.frame.height - self.dismissView.frame.height
        self.QRAnimalViewYConstraint.constant = self.collectionViewLocation
        
        self.foundAnimalsViewLocation = UIScreen.main.bounds.width - UIScreen.main.bounds.width - self.foundAnimalsview.frame.width - self.dismissView.frame.width - 12
        print("STARTING LOCATION \(foundAnimalsViewLocation)")
        self.foundAnimalsViewXConstraint.constant = self.foundAnimalsViewLocation
        
        self.foundAnimalsViewWidth.constant = UIScreen.main.bounds.width - self.dismissView.frame.width - 12
        
        
        getAnimals()
        self.dismissView.layer.cornerRadius = 5.0
        self.dismissView.clipsToBounds = true
        self.foundAnimalsview.layer.cornerRadius = 5.0
        self.foundAnimalsview.clipsToBounds = true
        self.QRAnimalView.layer.cornerRadius = 5.0
        self.QRAnimalView.clipsToBounds = true
        
        roundCornerButtons(QRModalView)
        roundCornerButtons(getStartedButtonLabel)
        roundCornerButtons(scanButton)
        roundCornerButtons(blurView)
        
        gradient(self.view)
        
        tabBarTint(view: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
            captureSession!.stopRunning()
        }
        self.scanType = "qr"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.QRAnimalViewYConstraint.constant = self.collectionViewLocation
        self.foundAnimalsViewXConstraint.constant = self.foundAnimalsViewLocation
        
        self.QRViewIsVisible = false
        
        
        // Barcode Scanner Mode
        if self.scanType == "barCode" {
            self.dataType = AVMetadataObjectTypeCode128Code
            self.barcodeViewFinder.isHidden = false
            self.alignQRCodeLabel.text = "Align barcode in frame"
            self.photoFrameImage.isHidden = true
            self.QRScannerLabel.text = "Membership Card Scanner"
            self.dismissBarcodeScanner.isHidden = false
            cameraCheck()
            
            // QR Scanner Mode
        } else {
            self.dataType = AVMetadataObjectTypeQRCode
            self.barcodeViewFinder.isHidden = true
            self.alignQRCodeLabel.text = "Align QR code in frame"
            self.scanButton.isHidden = false
            self.photoFrameImage.isHidden = false
            self.QRScannerLabel.text = "Exhibit Scanner"
            self.dismissBarcodeScanner.isHidden = true
       
        }
        
        if QRModalView.isHidden == false {
            scanButton.isHidden = true
            photoFrameImage.isHidden = true
            
        } else if QRModalView.isHidden && self.scanType == "barCode" {
            photoFrameImage.isHidden = true
            print(self.scanType)
            
        } else {
            print(self.scanType)
            scanButton.isHidden = false
            photoFrameImage.isHidden = false
        }
        
        captureSession?.stopRunning()
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.removeFromSuperview()
        }
        
        qrCodeFrameView = nil
        
        initializeQRView()
        if (captureSession?.isRunning == false) {
            self.captureSession!.startRunning()
        }
        
        if QRModalView.isHidden == false {
            alignQRCodeLabel.alpha = 0.0
        }
    }
    
    
    func cameraCheck() {
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch authStatus {
        case .authorized:
            qrOn(true)
            self.photoFrameImage.isHidden = false
            QRModalView.isHidden = true
            alignQRCodeLabel.alpha = 1.0
            scanButton.isHidden = false
            
        case .denied:
            let cameraAlert = UIAlertController(title: "No Camera Access", message: "Please Allow Access To The Camera", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { (cameraAlert) in
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            cameraAlert.addAction(cancelAction)
            cameraAlert.addAction(settingsAction)
            
            self.present(cameraAlert, animated: true, completion: nil)
            
            
            QRModalView.isHidden = false
            alignQRCodeLabel.alpha = 0.0
            scanButton.isHidden = true
            photoFrameImage.isHidden = true
            
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: nil)
            
            
            
        default: break
            
        }
        
    }
    
    
    @IBAction func dismissBarcodeScannerButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func getStartedButtonTapped(_ sender: AnyObject) {
        
        cameraCheck()
        
    }
    
    
    // MARK: - Firebase Query
    
    func getAnimals() {
        
        let query =  self.firebaseReference.child("Animals")
        
        query.observe(.value, with: { (snapshot) in
            self.animals = []
            
            self.organizedAnimals = []
            
            for item in snapshot.children {
                guard let animal = AnimalTest(snapshot: item as! FIRDataSnapshot) else { continue }
                self.animals.append(animal)
            }
            if self.animals != [] {
                self.collectionView.layoutIfNeeded()
                self.collectionView.reloadData()
                
                
                self.animals = self.animals.sorted { $0.animalName ?? "" < $1.animalName ?? "" }
                
            }
        }
        )}
    
    
    func sortForExhibit(exhibit: String) {
        
        self.organizedAnimals = []
        
        for animal in self.animals {
            if animal.exhibit == exhibit && !self.organizedAnimals.contains(animal){
                self.organizedAnimals.append(animal)
            }
        }
    }
    
    // MARK: - CollectionView Methods
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.organizedAnimals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ARCollectionViewCell
        
        
        cell.delegate = self
        let animal = self.organizedAnimals[indexPath.row]
        
        // Download image from Firebase storage
        let reference = FIRStorageReference().child(animal.animalImage ?? "")
        cell.animalImage.sd_setImage(with: reference, placeholderImage: #imageLiteral(resourceName: "fishFilled"))
        
        cell.animalNameLabel.text = animal.animalName ?? ""
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 5.0
        cell.animalImage.layer.cornerRadius = 5.0
        cell.animalNameLabel.layer.cornerRadius = 5.0
        
        if self.resetFoundAnimals == true {
            cell.animalFound = false
            cell.animalCheckedButton.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        }
        
        cell.animalImage.heroID = "animalImage: \(indexPath.row)"
        cell.animalNameLabel.heroID = "animalName: \(indexPath.row)"
        
        
        return cell
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        animateLeft()
    }
    
    
    func alertWithExhibit(completion: @escaping (Bool) -> Void) {
        
        // Sort animals into exhibits based on QR result
        
        switch self.result {
        case QRExhibits.coralReef.rawValue: self.sortForExhibit(exhibit: QRExhibits.coralReef.rawValue)
        case QRExhibits.floodedForest.rawValue: self.sortForExhibit(exhibit: QRExhibits.floodedForest.rawValue)
        case QRExhibits.giants.rawValue: self.sortForExhibit(exhibit: QRExhibits.giants.rawValue)
        case QRExhibits.jsaBirds.rawValue: self.sortForExhibit(exhibit: QRExhibits.jsaBirds.rawValue)
        case QRExhibits.reefPredators.rawValue: self.sortForExhibit(exhibit: QRExhibits.reefPredators.rawValue)
        case QRExhibits.sharkTank.rawValue: self.sortForExhibit(exhibit: QRExhibits.sharkTank.rawValue)
        case QRExhibits.poisonDartFrogs.rawValue: self.sortForExhibit(exhibit: QRExhibits.poisonDartFrogs.rawValue)
            
        default: alertForUnrecognizedQR()
        }
        completion(true)
    }
    
    
    func alertForUnrecognizedQR() {
        
        self.QRViewIsVisible = true
        let alert = UIAlertController(title: "Scan Unsuccessful", message: "We didn't recognize this QR Code.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
            self.QRViewIsVisible = false
        }
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Animations
    
    func animateUp() {
        
        
        self.collectionViewLocation = UIScreen.main.bounds.height - UIScreen.main.bounds.height + 55
        self.QRAnimalViewYConstraint.constant = self.collectionViewLocation
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .allowUserInteraction, animations: {
            self.scanButton.alpha = 0.0
            self.alignQRCodeLabel.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { (true) in
            self.animateRight()
            self.initialScan = false
        })
        self.QRViewIsVisible = true
        self.collectionView.reloadData()
    }
    
    
    func animateDown() {
        
        self.collectionViewLocation = UIScreen.main.bounds.height - UIScreen.main.bounds.height - self.QRAnimalView.frame.height - self.dismissView.frame.height
        self.QRAnimalViewYConstraint.constant = self.collectionViewLocation
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .allowUserInteraction, animations: {
            self.scanButton.alpha = 1.0
            self.alignQRCodeLabel.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: { (true) in
            self.QRViewIsVisible = false
            // Reset found animal checkmarks if the user scans a different exhibit
            self.resetFoundAnimals = false
        })
        
        
    }
    
    
    func animateRight() {
        self.foundAnimalsViewLocation = 4
        self.foundAnimalsViewXConstraint.constant = self.foundAnimalsViewLocation
        self.foundAnimalsViewIsShown = true
        self.exhibitNameLabel.shine()
        self.exhibitNameLabel.text = "Welcome to the \(self.result) exhibit!"
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .allowUserInteraction, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (true) in
            
            if self.foundAnimals.count == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.2, execute: {
                    self.animateLabel(with: "Check off the animals you find in the list below!")
                })
            } else {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.2, execute: {
                    
                    //Change grammar (Add/Remove "s" in "animals")
                    if self.foundAnimals.count == 1 {
                        self.animateLabel(with: "You've found \(self.foundAnimals.count) animal.")
                    } else {
                        self.animateLabel(with: "You've found \(self.foundAnimals.count) animals.")
                    }
                })
            }
        })
        
        
    }
    
    func animateLeft() {
        
        self.foundAnimalsViewLocation = UIScreen.main.bounds.width - UIScreen.main.bounds.width - self.foundAnimalsview.frame.width - self.dismissView.frame.width - 12
        self.foundAnimalsViewIsShown = false
        self.foundAnimalsViewXConstraint.constant = self.foundAnimalsViewLocation
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .allowUserInteraction, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (true) in
            self.animateDown()
        })
        self.exhibitNameLabel.fadeOut()
        self.exhibitNameLabel.fadeoutDuration = 0.0
        
        
    }

    // MARK: - Delegate Method
    
    func animalFound(_ cell: ARCollectionViewCell) {
        print("delegate found")
        
        let indexPath = self.collectionView.indexPath(for: cell)
        
        let foundAnimal = self.animals[(indexPath?.row)!]
        if cell.animalFound == false {
            cell.animalCheckedButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            
            if self.foundAnimals.contains(foundAnimal) {
                print("animal already found!")
            } else {
                self.foundAnimals.append(foundAnimal)
            }
            cell.animalFound = true
        } else {
            guard let index = self.foundAnimals.index(of: foundAnimal) else { return }
            self.foundAnimals.remove(at: index)
            cell.animalCheckedButton.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            cell.animalFound = false
        }
        
        if self.foundAnimals.count != 0 {
            
            //Change grammar (Add/Remove "s" in "animals")
            if self.foundAnimals.count == 1 {
                self.animateLabel(with: "You've found \(self.foundAnimals.count) animal.")
            } else {
                self.animateLabel(with: "You've found \(self.foundAnimals.count) animals.")
            }
        } else {
           self.animateLabel(with: "Check off the animals you find in the list below!")
        }
        
    }
    
    func animateLabel(with newString: String) {
        self.exhibitNameLabel.fadeOut { 
            self.exhibitNameLabel.text = newString
            self.exhibitNameLabel.shine()
        }
    }

    @IBAction func animateButtonTapped(_ sender: Any) {
        
        if self.QRViewIsVisible == false {
            self.animateUp()
        } else {
            self.animateLeft()
        }
    }
    
}