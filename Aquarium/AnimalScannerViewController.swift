//
//  AnimalScannerViewController.swift
//  Aquarium
//
//  Created by TLPAAdmin on 7/25/18.
//  Copyright © 2018 Forrest Syrett. All rights reserved.
//

import UIKit
import CoreML
import AVFoundation
import Vision

class AnimalScannerViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var CameraView: UIView!
    @IBOutlet weak var outputContainerView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    
    var requests = [VNRequest]()
    
    var cameraLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    var captureSession: AVCaptureSession {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.photo
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
        let input = try? AVCaptureDeviceInput(device: backCamera)
            else { return session }
        session.addInput(input)
        return session
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.CameraView.layer.addSublayer(self.cameraLayer)
        let videoOut = AVCaptureVideoDataOutput()
        videoOut.setSampleBufferDelegate(self, queue: DispatchQueue(label: "ClassifierQueue"))
        self.captureSession.addOutput(videoOut)
        self.captureSession.startRunning()
        
        setupVision()
        
    }
    
    
    func setupVision() {
        
        guard let visionModel = try? VNCoreMLModel(for: AnimalClassifier().model)
            else { fatalError("Error loading CoreML model")}
        let classifierRequest = VNCoreMLRequest(model: visionModel, completionHandler: handleClassifications)
        classifierRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop
        self.requests = [classifierRequest]
        
        
    }
    
    func handleClassifications(request: VNRequest, error: Error?)
    {
        guard let observations = request.results
            else {
                print("No results: \(error!)"); return
        }
        
        let classification = observations[0...1]
            .flatMap({ $0 as? VNClassificationObservation})
        .filter({ $0.confidence > 0.3})
            .map {
                (prediction: VNClassificationObservation) -> String in
                return "\(round(prediction.confidence * 100 * 100)/100)%: \(prediction.identifier)"
        }
        
        DispatchQueue.main.async {
            print(classification.joined(separator: "###"))
            self.resultLabel.text = classification.joined(separator: "\n")
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        var requestOptions:[VNImageOption : Any] = [:]
        if let cameraIntrinsicData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
            requestOptions = [.cameraIntrinsics:cameraIntrinsicData]
        }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: 1, options: requestOptions)
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
    
    

}
