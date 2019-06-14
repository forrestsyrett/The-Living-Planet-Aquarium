//
//  AnimalScannerViewController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 7/25/18.
//  Copyright © 2018 Forrest Syrett. All rights reserved.
//

import UIKit
import CoreML
import AVFoundation
import Vision
import NVActivityIndicatorView

class AnimalScannerViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var timer = Timer()
    var seconds = 5
    var timerIsRunning = false
    var noAnimalsFound = false;
    var limitResultLabel = false
    var animalFound = false
    
    var roundedValue: Float = 0.5
    var zoomFactor: CGFloat = 0.0
    
    @IBOutlet weak var CameraView: UIView!
    @IBOutlet weak var outputContainerView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var accuracySlider: UISlider!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    
    var scan = false
    lazy var cameraLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    var requests = [VNRequest]()
    
    var captureSession = AVCaptureSession()
    let captureDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInDualCamera , for: .video, position: .back)

    override func viewDidLoad() {
        startSession()
        cameraLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        super.viewDidLoad()
        self.CameraView.layer.addSublayer(self.cameraLayer)
        let videoOut = AVCaptureVideoDataOutput()
        videoOut.alwaysDiscardsLateVideoFrames = true
        videoOut.setSampleBufferDelegate(self, queue: DispatchQueue(label: "ClassifierQueue"))
        self.captureSession.addOutput(videoOut)
        self.captureSession.startRunning()
        setupVision()
        
       roundedCorners(outputContainerView, cornerRadius: 5.0)
        roundCornerButtons(scanButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.cameraLayer.frame = self.view.frame
        self.CameraView.contentMode = .scaleToFill
    }
    
    func startSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        let input = try? AVCaptureDeviceInput(device: captureDevice!)
        captureSession.addInput(input!)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        IndexController.shared.index = (self.tabBarController?.selectedIndex)!
        captureSession.startRunning()
        self.loadingView.alpha = 0.0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        captureSession.stopRunning()
    }
    
    
    func setupVision() {
        
        guard let visionModel = try? VNCoreMLModel(for: AnimalClassifier().model)
            else { fatalError("Error loading CoreML model")}
        let classifierRequest = VNCoreMLRequest(model: visionModel, completionHandler: handleClassifications)
        classifierRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.scaleFill
        self.requests = [classifierRequest]
        
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        roundedValue = round(accuracySlider.value / 0.1) * 0.1
        accuracySlider.setValue(roundedValue, animated: true)
        accuracyLabel.text = "Desired Accuracy: \(roundedValue)"
    }
    
    
    @IBAction func pinchToZoom(_ sender: Any) {
        
        guard let device = captureDevice else { return }
        
        if (sender as AnyObject).state == .changed {
            
            let maxZoomFactor: CGFloat = 5.0
            let pinchVelocityDividerFactor: CGFloat = 5.0
            
            do {
                
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                
                let desiredZoomFactor = device.videoZoomFactor + atan2((sender as AnyObject).velocity, pinchVelocityDividerFactor)
                device.videoZoomFactor = max(1.0, min(desiredZoomFactor, maxZoomFactor))
                print(desiredZoomFactor)
                zoomFactor = desiredZoomFactor
                
            } catch {
                print(error)
            }
        }
    }
    
    
    func handleClassifications(request: VNRequest, error: Error?)
    {
        guard let observations = request.results
            else {
                print("No results: \(error!)"); return
        }
        
        
        let classification = observations[0...3]
            .compactMap({ $0 as? VNClassificationObservation})
        .filter({ $0.confidence > 0.3})
            .map {
                (prediction: VNClassificationObservation) -> String in
                
                // Timer is running, but if we get an accurate scan we stop processing frames and reset the timer for the next scan.
                if prediction.confidence >= roundedValue {
                    self.resetTimer()
                    self.animalFound = true
                    return "You found a \(prediction.identifier)!"
                    
                } else {
                return "Scanning..."
                }
        }

        // UI changes must be executed on the main thread
        DispatchQueue.main.async {
            
            // Allow scanner to run for 5 seconds to try and get the best scan possible.
            if self.seconds == 0 {
                self.resetTimer()
                self.noAnimalsFound = true
                self.fadeOutLoadingView()
            }
            
            if self.noAnimalsFound {
                self.resultLabel.text = "We couldn't find any animals! Sometimes they are shy, please try again."
                self.noAnimalsFound = false
            }
            
            if self.limitResultLabel && self.animalFound {
                self.animalFound = false
                self.limitResultLabel = false
            self.resultLabel.text = classification.first
                self.fadeOutLoadingView()
            }
    }
}
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        self.fadeInLoadingView()
        self.resultLabel.text = "Scanning..."
        limitResultLabel = true
    }
    
    @objc func updateTimer() {
        seconds -= 1
    }
    
    func resetTimer() {
        timer.invalidate()
        seconds = 5
        scan = false
    }
    
    @IBAction func scanButtonTouchDown(_ sender: Any) {
        //scan = true
    }
    
    @IBAction func ScanButtonTouchUp(_ sender: Any) {
        resetTimer()
        startTimer()
        scan = true
    }
    
    
    func fadeInLoadingView() {
        
        self.loadingView.startAnimating()
        UIView.animate(withDuration: 0.5) {
            self.loadingView.alpha = 1.0
        }
        
    }
    
    func fadeOutLoadingView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.loadingView.alpha = 0.0
        }) { (true) in
            self.loadingView.stopAnimating()
        }
    }
    
   
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        if self.scan {
        var requestOptions:[VNImageOption : Any] = [:]
        if let cameraIntrinsicData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
            requestOptions = [.cameraIntrinsics:cameraIntrinsicData]
        }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: requestOptions)
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
}
    
    // Tap to focus
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first as! UITouch
        let point = touchPoint.location(in: CameraView)
        let focusPoint = CGPoint(x: point.x, y: point.y)
        
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
                if device.isFocusPointOfInterestSupported {
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = .autoFocus
                    print("focusing camera")
                }
                if device.isExposurePointOfInterestSupported {
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = .autoExpose
                }
                device.unlockForConfiguration()
            } catch {
                print("Error in tap to focus")
            }
        }
    }
    
    
    

}
