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


class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, SFSafariViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
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
    
    var animals: [AnimalTest] = []
    var organizedAnimals: [AnimalTest] = []
    
    var QRViewIsVisible = false
    var firebaseReference: FIRDatabaseReference!
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var scanType = "qr"
    var result = ""
    var dataType = AVMetadataObjectTypeQRCode
    
    
    func configureVideoCapture() {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        //    var error: NSError?
        let input: AnyObject!
        
        
        do {
            input = try AVCaptureDeviceInput(device: captureDevice) as AVCaptureDeviceInput
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
            captureSession?.addInput(input as? AVCaptureInput)
        }
        
        let objCaptureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(objCaptureMetadataOutput)
        objCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code]
    }
    
    
    func addVideoPreviewLayer() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
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
        self.view.addSubview(alignQRCodeLabel)
        self.view.addSubview(self.QRAnimalView)
        self.view.addSubview(self.dismissView)
        //        self.view.addSubview(scanButton)
        self.view.addSubview(barcodeViewFinder)
    }
    
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        let objMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if objMetadataMachineReadableCodeObject.type == self.dataType {
            let objBarCode = videoPreviewLayer?.transformedMetadataObject(for: objMetadataMachineReadableCodeObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = objBarCode.bounds;
            if objMetadataMachineReadableCodeObject.stringValue != nil {
                result = objMetadataMachineReadableCodeObject.stringValue
                
            }
        }
        
        let qrResult = result
        
        if qrResult != "" && self.scanType == "barCode" {
            print("Barcode result: \(qrResult).")
            self.performSegue(withIdentifier: "unwindToAddNewMembership", sender: nil)
            captureSession?.stopRunning()
        } else if qrResult != "" {
            
            // Do something with specific QR information. (Show exhibit animals)
            self.result = "\(qrResult)"
            if self.result != "" && self.QRViewIsVisible == false {
                self.alertWithExhibit()
                self.collectionView.reloadData()
                print(self.result)
                print(self.animals.count)
                print(self.organizedAnimals.count)
            }
        }
        
    }
    
    @IBAction func scanButtonTapped(_ sender: AnyObject) {
        
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
            configureVideoCapture()
            addVideoPreviewLayer()
            initializeQRView()
        }}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firebaseReference = FIRDatabase.database().reference()
        
        getAnimals()
        self.dismissView.layer.cornerRadius = 5.0
        self.dismissView.clipsToBounds = true
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.QRAnimalViewYConstraint.constant = UIScreen.main.bounds.height - UIScreen.main.bounds.height - self.QRAnimalView.frame.height - self.dismissView.frame.height
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
            self.QRScannerLabel.text = "QR Code Scanner"
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
            alignQRCodeLabel.isHidden = true
        }
    }
    
    
    func cameraCheck() {
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch authStatus {
        case .authorized:
            qrOn(true)
            QRModalView.isHidden = true
            alignQRCodeLabel.isHidden = false
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
            alignQRCodeLabel.isHidden = true
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
        self.photoFrameImage.isHidden = false
        
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
        
        let animal = self.organizedAnimals[indexPath.row]
        
        // Download image from Firebase storage
        let reference = FIRStorageReference().child(animal.animalImage ?? "")
        cell.animalImage.sd_setImage(with: reference, placeholderImage: #imageLiteral(resourceName: "fishFilled"))
        
        cell.animalNameLabel.text = animal.animalName ?? ""
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 5.0
        cell.animalImage.layer.cornerRadius = 5.0
        cell.animalNameLabel.layer.cornerRadius = 5.0
        
        
        return cell
    }

    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        animateDown()
    }
    
    
    func alertWithExhibit() {
        
        // Sort animals into exhibits based on QR result
        
        switch self.result {
        case QRExhibits.coralReef.rawValue: self.sortForExhibit(exhibit: QRExhibits.coralReef.rawValue)
            self.animateUp()
        case QRExhibits.floodedForest.rawValue: self.sortForExhibit(exhibit: QRExhibits.floodedForest.rawValue)
            self.animateUp()
        case QRExhibits.giants.rawValue: self.sortForExhibit(exhibit: QRExhibits.giants.rawValue)
            self.animateUp()
        case QRExhibits.jsaBirds.rawValue: self.sortForExhibit(exhibit: QRExhibits.jsaBirds.rawValue)
            self.animateUp()
        case QRExhibits.reefPredators.rawValue: self.sortForExhibit(exhibit: QRExhibits.reefPredators.rawValue)
            self.animateUp()
        case QRExhibits.sharkTank.rawValue: self.sortForExhibit(exhibit: QRExhibits.sharkTank.rawValue)
            self.animateUp()
        case QRExhibits.poisonDartFrogs.rawValue: self.sortForExhibit(exhibit: QRExhibits.poisonDartFrogs.rawValue)
            self.animateUp()
            
        default: alertForUnrecognizedQR()
    }
        
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
    
    func animateUp() {
        self.QRAnimalViewYConstraint.constant = UIScreen.main.bounds.height - UIScreen.main.bounds.height + 55
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .allowUserInteraction, animations: {
            self.view.layoutIfNeeded()
            self.scanButton.alpha = 0.0
            self.alignQRCodeLabel.isHidden = true
            self.photoFrameImage.isHidden = true
        }, completion: nil)
        self.QRViewIsVisible = true
        self.collectionView.reloadData()
    }
    
    
    func animateDown() {
        self.QRAnimalViewYConstraint.constant = UIScreen.main.bounds.height - UIScreen.main.bounds.height - self.QRAnimalView.frame.height - self.dismissView.frame.height
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .allowUserInteraction, animations: {
            self.view.layoutIfNeeded()
            self.scanButton.alpha = 1.0
            self.alignQRCodeLabel.isHidden = true
            self.photoFrameImage?.isHidden = true
        }, completion: nil)
        self.QRViewIsVisible = false
        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "unwindToAddNewMembership" {
            
            let destination = segue.destination as! AddNewMembershipViewController
            
            destination.membershipIDTextField.text = self.result
        }
        
        if segue.identifier == "toAnimalDetail" {
            
            if let destinationViewController = segue.destination as? AnimalDetailViewController {
                
                let indexPath = self.collectionView.indexPath(for: (sender as! UICollectionViewCell))
                
                if let selectedItem = (indexPath as NSIndexPath?)?.row {
                    
                    let animal = self.organizedAnimals[selectedItem]
                    print(selectedItem)
                    destinationViewController.updateInfo(animal: animal)
                    destinationViewController.animal = animal.animalName ?? ""
                }
            }
        }

    }
    
}



