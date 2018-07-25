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
import CoreML

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, SFSafariViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, QRAnimalCollectionViewDelegate {
    
    
    @IBOutlet weak var QRModalView: UIView!
    @IBOutlet weak var qrWelcomeTextField: UITextView!
    @IBOutlet weak var getStartedButtonLabel: UIButton!
    @IBOutlet weak var qrCodeResult: UILabel!
    @IBOutlet weak var photoFrameImage: UIImageView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var barcodeViewFinder: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dismissCollectionView: UIButton!
    @IBOutlet weak var aquaWave: UIImageView!
    @IBOutlet weak var QRScannerLabel: UILabel!
    
    @IBOutlet weak var QRAnimalViewYConstraint: NSLayoutConstraint!
    @IBOutlet weak var QRAnimalView: UIView!
    @IBOutlet weak var containerViewForDismiss: UIView!
    
    @IBOutlet weak var dismissBarcodeScanner: UIButton!
    
    @IBOutlet weak var qrCodeLabel: RQShineLabel!
    @IBOutlet weak var foundAnimalsview: UIView!
    @IBOutlet weak var foundAnimalsViewXConstraint: NSLayoutConstraint!
    @IBOutlet weak var foundAnimalsViewWidth: NSLayoutConstraint!

    @IBOutlet weak var exhibitNameLabel: RQShineLabel!
    
    var animals: [AnimalTest] = []
    var organizedAnimals: [AnimalTest] = []
    var foundAnimal = 0
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
    var dataType = AVMetadataObject.ObjectType.qr
    var resetExhibit = false
    var oneScan = false
    
    var time = 0
    var timer = Timer()
    var isBubbling = false
    
    func configureVideoCapture() {
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        //    var error: NSError?
        let input: AnyObject!
        
        
        do {
            input = try AVCaptureDeviceInput(device: captureDevice!) as AVCaptureDeviceInput
        }
        catch _ as NSError {
            //      error = error1
            input = nil
        }
        //        if (error != nil) {
        //            let alertController = UIAlertController(title: "Device Error", message: "Device not supported for this Application", preferredStyle: .Alert)
        //
        //            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        //            alertController.addAction(cancelAction)
        //        }
        
        
        captureSession = AVCaptureSession()
        if captureDevice == nil {
            
            return
            
        } else {
            captureSession?.addInput((input as? AVCaptureInput)!)
        }
        
        let objCaptureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(objCaptureMetadataOutput)
        objCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr, AVMetadataObject.ObjectType.code128]
    }
    
    
    func addVideoPreviewLayer() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        self.view.layer.addSublayer(videoPreviewLayer!)
        captureSession?.startRunning()
    }
    
    func initializeQRView() {
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.blue.cgColor
        qrCodeFrameView?.layer.borderWidth = 5
        self.view.addSubview(aquaWave)
        self.view.addSubview(QRScannerLabel)
        self.view.addSubview(qrCodeFrameView!)
        self.view.addSubview(photoFrameImage)
        self.view.addSubview(self.QRAnimalView)
        self.view.addSubview(self.dismissBarcodeScanner)
        self.view.addSubview(self.foundAnimalsview)
        self.view.addSubview(self.containerViewForDismiss)
        self.view.addSubview(barcodeViewFinder)
        self.view.addSubview(qrCodeLabel)
        

    }
    
    
    
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        let objMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if objMetadataMachineReadableCodeObject.type == self.dataType {
            let objBarCode = videoPreviewLayer?.transformedMetadataObject(for: objMetadataMachineReadableCodeObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = objBarCode.bounds;
            if objMetadataMachineReadableCodeObject.stringValue != nil {
                result = objMetadataMachineReadableCodeObject.stringValue!
                
            }
        }
        
        let qrResult = result
        
        if qrResult != "" && self.scanType == "barCode" {
            print("Barcode result: \(qrResult).")
            self.performSegue(withIdentifier: "unwindToAddNewMembership", sender: nil)
            captureSession?.stopRunning()
            
            // QR Code Scanned
        } else if qrResult != "" {
            // Do something with specific QR information. (Show exhibit animals)
            self.result = "\(qrResult)"
            
            if self.QRViewIsVisible == false {
        
            self.organizeAndShowAnimals()
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
            safariViewController.preferredBarTintColor = UIColor(red:0.20, green:0.35, blue:0.54, alpha:1.00)
            safariViewController.preferredControlTintColor = .white
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        } else { return }
    }
    
    
    
    func qrOn(_ isOn: Bool = false) {
        if isOn {
            configureVideoCapture()
            addVideoPreviewLayer()
            initializeQRView()
        }}
    
    
    // MARK: - View LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.exhibitNameLabel.adjustsFontSizeToFitWidth = true

        self.firebaseReference = FIRDatabase.database().reference()
        
        self.collectionViewLocation = UIScreen.main.bounds.height - UIScreen.main.bounds.height - self.QRAnimalView.frame.height - self.containerViewForDismiss.frame.height
        self.QRAnimalViewYConstraint.constant = self.collectionViewLocation
        
        self.foundAnimalsViewLocation = UIScreen.main.bounds.width - UIScreen.main.bounds.width - self.foundAnimalsview.frame.width - self.containerViewForDismiss.frame.width - 12
        print("STARTING LOCATION \(foundAnimalsViewLocation)")
        self.foundAnimalsViewXConstraint.constant = self.foundAnimalsViewLocation
        
        self.foundAnimalsViewWidth.constant = UIScreen.main.bounds.width - self.containerViewForDismiss.frame.width - 12
        
        self.qrCodeLabel.shineDuration = 0.5
        self.qrCodeLabel.shine()
        self.qrCodeLabel.text = "Align QR Code in Frame"
        
        getAnimals()
        self.containerViewForDismiss.layer.cornerRadius = 5.0
        self.containerViewForDismiss.clipsToBounds = true
        self.foundAnimalsview.layer.cornerRadius = 5.0
        self.foundAnimalsview.clipsToBounds = true
        self.QRAnimalView.layer.cornerRadius = 5.0
        self.QRAnimalView.clipsToBounds = true
        QRAnimalView.backgroundColor = aquaLightTransparent
        foundAnimalsview.backgroundColor = aquaLightTransparent
        containerViewForDismiss.backgroundColor = aquaLightTransparent
        
        
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
        timer.invalidate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.QRAnimalViewYConstraint.constant = self.collectionViewLocation
        self.foundAnimalsViewXConstraint.constant = self.foundAnimalsViewLocation
        
        self.QRViewIsVisible = false
        
        
        // Barcode Scanner Mode
        if self.scanType == "barCode" {
            self.dataType = AVMetadataObject.ObjectType.code128
            self.barcodeViewFinder.isHidden = false
            self.qrCodeLabel.text = "Align barcode in frame"
            self.photoFrameImage.isHidden = true
            self.QRScannerLabel.text = "Membership Card Scanner"
            self.dismissBarcodeScanner.isHidden = false
            cameraCheck()
            
            // QR Scanner Mode
        } else {
            self.dataType = AVMetadataObject.ObjectType.qr
            self.barcodeViewFinder.isHidden = true
            self.qrCodeLabel.text = "Align QR code in frame"
            self.scanButton.isHidden = false
            self.photoFrameImage.isHidden = false
            self.QRScannerLabel.text = "Exhibit Scanner"
            self.dismissBarcodeScanner.isHidden = true
            IndexController.shared.index = (self.tabBarController?.selectedIndex)!
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
            qrCodeLabel.alpha = 0.0
        }
    }
    
    func startBubbles() {
        
        if self.isBubbling == false {
        print("start bubbles")
        // time interval controls amount of bubbles generated
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(QRScannerViewController.bubbles), userInfo: nil, repeats: true)
        timer.fire()
        }
    }
    
    
    @objc func bubbles() {
        
        self.isBubbling = true
        
        time += 1
        print("Time \(time)")
        
         if self.time == 250 {
            timer.invalidate()
            print("Time \(time)")
            self.time = 0
            self.isBubbling = false
        }
        
        let size = randomNumber(low: 8, high: 15)
        print("SIZE: \(size)")
        let xLocation = randomNumber(low: 8, high: 370)
        print("X LOCATION: \(xLocation)")
        
        let bubbleImageView = UIImageView(image: UIImage(named: "Bubble"))
        bubbleImageView.frame = CGRect(x: xLocation, y: collectionView.center.y + 300, width: size, height: size)
        view.addSubview(bubbleImageView)
        view.bringSubview(toFront: bubbleImageView)
        
        let zigzagPath = UIBezierPath()
        let originX: CGFloat = xLocation
        // Set bubble starting location to bottom of screen
        let originY: CGFloat = self.view.frame.height
        let eX: CGFloat = originX
        
        // set vertical distance travelled before popping
        let eY: CGFloat = originY - randomNumber(low: Int(self.view.frame.height) - 30, high: Int(self.view.frame.height))
        //t = horizontal displacement
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
        pathAnimation.duration = 2.9
        pathAnimation.path = zigzagPath.cgPath
        // remains visible in it's final state when animation is finished
        // in conjunction with removedOnCompletion
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.isRemovedOnCompletion = false
        bubbleImageView.layer.add(pathAnimation, forKey: "movingAnimation")
        
        CATransaction.commit()
        
    }
    
    func cameraCheck() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized:
            qrOn(true)
            self.photoFrameImage.isHidden = false
            QRModalView.isHidden = true
            qrCodeLabel.alpha = 1.0
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
            qrCodeLabel.alpha = 0.0
            scanButton.isHidden = true
            photoFrameImage.isHidden = true
            
        case .notDetermined:
            
           // AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: nil)
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (true) in
                print("Access Granted")
            }
            
            
            
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
        cell.animalImage.sd_setShowActivityIndicatorView(true)
        cell.animalImage.sd_setImage(with: reference)
        
        cell.animalNameLabel.text = animal.animalName ?? ""
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 5.0
        cell.animalImage.layer.cornerRadius = 5.0
        cell.animalNameLabel.layer.cornerRadius = 5.0
        
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1.0
        
        print(animal.found)
        
        if animal.found == true {
            cell.animalCheckedButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        } else {
            cell.animalCheckedButton.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        }
        
        cell.animalImage.hero.id = "animalImage: \(indexPath.row)"
        cell.animalNameLabel.hero.id = "animalName: \(indexPath.row)"
        
        
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
        if self.result.range(of: "http") != nil {
            self.openURL()
        } else {
        
        let alert = UIAlertController(title: "Scan Unsuccessful", message: "We didn't recognize this QR code.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
            self.QRViewIsVisible = false
        }
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    }

    
    // MARK: - Animations
    
    func animateUp() {
        
        
        self.collectionViewLocation = UIScreen.main.bounds.height - UIScreen.main.bounds.height + 55
        self.QRAnimalViewYConstraint.constant = self.collectionViewLocation
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .allowUserInteraction, animations: {
            self.scanButton.alpha = 0.0
          //  self.alignQRCodeLabel.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { (true) in
                self.animateRight()
                self.initialScan = false
            })
        self.QRViewIsVisible = true
        self.collectionView.reloadData()
    }
    
    
    func animateDown() {
        
        self.collectionViewLocation = UIScreen.main.bounds.height - UIScreen.main.bounds.height - self.QRAnimalView.frame.height - self.containerViewForDismiss.frame.height
        self.QRAnimalViewYConstraint.constant = self.collectionViewLocation
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .allowUserInteraction, animations: {
            self.scanButton.alpha = 1.0
        //    self.alignQRCodeLabel.alpha = 1.0
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
        self.exhibitNameLabel.shineDuration = 0.5
        self.exhibitNameLabel.shine()
        self.exhibitNameLabel.text = "Welcome to the \(self.result) exhibit!"
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .allowUserInteraction, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (true) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
            if self.getFoundAnimals() == 0 {
                self.animateLabel(label: self.exhibitNameLabel, with: "Check off the animals you find in the list below!", fadeOutDuration: 0.5, shineDuration: 0.5)
                }
            })

        })
    }

    
    func animateLeft() {
        
        self.foundAnimalsViewLocation = UIScreen.main.bounds.width - UIScreen.main.bounds.width - self.foundAnimalsview.frame.width - self.containerViewForDismiss.frame.width - 12
        self.foundAnimalsViewIsShown = false
        self.foundAnimalsViewXConstraint.constant = self.foundAnimalsViewLocation
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .allowUserInteraction, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (true) in
            self.animateDown()
        })
        self.exhibitNameLabel.fadeoutDuration = 0.5
        self.exhibitNameLabel.fadeOut()
        
    }
    

    func animateLabel(label: RQShineLabel, with newString: String, fadeOutDuration: CFTimeInterval, shineDuration: CFTimeInterval) {
        label.shineDuration = shineDuration
        label.fadeoutDuration = fadeOutDuration
        label.fadeOut {
            label.text = newString
            label.shine()
        }
    }
    
    
    func getFoundAnimals() -> Int {
        
        var foundAnimals = 0
        
        for animal in self.organizedAnimals {
            if animal.found == true {
            foundAnimals += 1
        }
        }
        
        return foundAnimals
    }
    
    
    @IBAction func showFoundAnimalsButton(_ sender: Any) {
        self.performSegue(withIdentifier: "foundAnimals", sender: nil)
    }
    
    // MARK: - Delegate Method
    
    func animalFound(_ cell: ARCollectionViewCell) {
        print("delegate found")
        
        let indexPath = self.collectionView.indexPath(for: cell)
        
        let animal = self.organizedAnimals[(indexPath?.row)!]
        
        if animal.found == false {
            print("checked!")
        cell.animalCheckedButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        animal.found = true
            self.foundAnimal += 1
        
    } else {
            print("unchecked!")
            cell.animalCheckedButton.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            animal.found = false
            self.foundAnimal -= 1
        }
        
        let animalCount = self.getFoundAnimals()
        
        
        // User found all animals, start bubble animation
        if animalCount == self.organizedAnimals.count {
            startBubbles()
            
            self.animateLabel(label: self.qrCodeLabel, with: "You found all the animals in this exhibit!", fadeOutDuration: 0.3, shineDuration: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                self.qrCodeLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            })
            
            
             DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                self.animateLabel(label: self.qrCodeLabel, with: "Align QR Code in Frame", fadeOutDuration: 0.5, shineDuration: 0.5)
                self.qrCodeLabel.font = self.qrCodeLabel.font.withSize(18)
                UIView.animate(withDuration: 0.3, animations: {
                    self.qrCodeLabel.transform = CGAffineTransform.identity
                })
            })
        }
        
        
        if animalCount != 0 {
            
            //Change grammar (Add/Remove "s" in "animals")
            if animalCount == 1 {
                self.animateLabel(label: self.exhibitNameLabel, with: "You've found \(animalCount) animal.", fadeOutDuration: 0.2, shineDuration: 0.2)
            } else {
                self.animateLabel(label: self.exhibitNameLabel, with: "You've found \(animalCount) animals.", fadeOutDuration: 0.2, shineDuration: 0.2)
            }
        } else {
            self.animateLabel(label: self.exhibitNameLabel, with: "Check off the animals you find in the list below!", fadeOutDuration: 0.2, shineDuration: 0.2)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "unwindToAddNewMembership" {
            
            let destination = segue.destination as! AddNewMembershipViewController
            
            destination.membershipIDTextField.text = self.result
        }
        
        if segue.identifier == "toAnimalDetail" {
            
            if let destinationViewController = segue.destination as? AnimalDetailViewController {
                
                let indexPath = self.collectionView.indexPath(for: (sender as! UICollectionViewCell))
                guard let newIndexPath = indexPath else { return }
                
                if let selectedItem = (indexPath as NSIndexPath?)?.row {
                    
                    let animal = self.organizedAnimals[selectedItem]
                    print(selectedItem)
                    destinationViewController.updateInfo(animal: animal)
                    destinationViewController.animal = animal.animalName ?? ""
                    destinationViewController.imageHeroID = "animalImage: \(newIndexPath.row)"
                    destinationViewController.titleLabelHeroID = "animalName: \(newIndexPath.row)"
                    
                }
            }
        }

    }
    
}



