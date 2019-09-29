//
//  FrameCaptureOSX.swift
//  VideoCapture
//
//  Created by Sheila Gonzalez on 2019-09-24.
//  Copyright © 2019 Sheila Gonzalez. All rights reserved.
//

import Cocoa
import AVFoundation

protocol FrameCaptureOSXDelegate : class {
    func captured(image: CIImage)
}

class FrameCaptureOSX: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate
{
    weak var delegate: FrameCaptureOSXDelegate?
    
    // The session coordinates the flow of data from the input to the output
    private let captureSession = AVCaptureSession()
    
    // Create a serial queue that will handle the work related to the session
    private let sessionQueue = DispatchQueue(label: "session queue")
    
    // Image quality
    private let quality = AVCaptureSession.Preset.medium
    
    let context = CIContext()
    
    func stopCamera()
    {
        self.captureSession.stopRunning()
    }
    
    
    // Constructor
    override init(){
        super.init()
        
        // Add async configuration on the session queue
        sessionQueue.async {
            [unowned self] in
            self.configureSession()
            self.captureSession.startRunning()
        }
    }
    
    private func configureSession(){
        self.captureSession.beginConfiguration()
        
        // Find a valid device
        guard let captureDevice = selectCaptureDevice() else { return }
        
        // Create an AVCaptureDeviceInput
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        // Check if the capture device input can be added to the session, and add it
        guard captureSession.canAddInput(captureDeviceInput) else { return }
        captureSession.addInput(captureDeviceInput)
        
        // To intercept each frame, create an instance of AVCaptureVideoDataOutput
        let videoOutput = AVCaptureVideoDataOutput()
        
        // Set FrameExtractor as delegate
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer"))
        
        guard captureSession.canAddOutput(videoOutput) else { return }
        self.captureSession.sessionPreset = quality
        captureSession.addOutput(videoOutput)
        
        self.captureSession.commitConfiguration()
    }
    
    
    private func selectCaptureDevice() -> AVCaptureDevice?{
        // Select only the targeted capture device.
        // For every device in the array of devices, checkif it's a video recording device
        let device = AVCaptureDevice.devices(for: .video)
        return device.first
    }
    
    
    func ciImageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CIImage? {
        // 1. Transform the sample buffer to a CVImageBuffer
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        
        // 2. Create a CIImage from the image buffer
        return CIImage(cvPixelBuffer: imageBuffer)
    }
    
    
    // This method is called every time a new frame is available
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let image = self.ciImageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
        
        DispatchQueue.main.async {
            [unowned self] in
            self.delegate?.captured(image: image)
        }
    }
}
