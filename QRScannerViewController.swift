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



class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, SFSafariViewControllerDelegate {
    
    
    @IBOutlet weak var QRModalView: UIView!
    @IBOutlet weak var qrWelcomeTextField: UITextView!
    @IBOutlet weak var getStartedButtonLabel: UIButton!
    @IBOutlet weak var qrCodeResult: UILabel!
    @IBOutlet weak var photoFrameImage: UIImageView!
    @IBOutlet weak var alignQRCodeLabel: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var barcodeViewFinder: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    
    
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
        self.view.addSubview(qrCodeFrameView!)
        self.view.addSubview(dismissButton)
        self.view.addSubview(photoFrameImage)
        self.view.addSubview(alignQRCodeLabel)
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
             print(qrResult)
            if self.result != "" {
                self.alertWithExhibit()
                self.captureSession?.stopRunning()
            }
        //    openURL()
        }
        
    }
    
    @IBAction func scanButtonTapped(_ sender: AnyObject) {
        

    }
    
    func alertWithExhibit() {
        let alert = UIAlertController(title: "You found the \(self.result)!", message: "You can scroll through the list below to learn more about the animals in this exhibit!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Awesome!", style: .default) { (action) in
            self.captureSession?.startRunning()
        }
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
            configureVideoCapture()
            addVideoPreviewLayer()
            initializeQRView()
        }}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        roundCornerButtons(QRModalView)
        roundCornerButtons(getStartedButtonLabel)
        roundCornerButtons(scanButton)
        roundCornerButtons(blurView)
        self.dismissButton.layer.cornerRadius = 17.0
        self.dismissButton.clipsToBounds = true
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
        
        // Barcode Scanner Mode
        if self.scanType == "barCode" {
            self.dataType = AVMetadataObjectTypeCode128Code
            self.barcodeViewFinder.isHidden = false
            self.alignQRCodeLabel.text = "Align barcode in frame"
            self.photoFrameImage.isHidden = true
            
            cameraCheck()
            
            // QR Scanner Mode
        } else {
            self.dataType = AVMetadataObjectTypeQRCode
            self.barcodeViewFinder.isHidden = true
            self.alignQRCodeLabel.text = "Align QR code in frame"
            self.scanButton.isHidden = false
            self.photoFrameImage.isHidden = false
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
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func getStartedButtonTapped(_ sender: AnyObject) {
        
        cameraCheck()
        self.photoFrameImage.isHidden = false
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "unwindToAddNewMembership" {
            
            let destination = segue.destination as! AddNewMembershipViewController
            
            destination.membershipIDTextField.text = self.result
        }
    }
    
}



