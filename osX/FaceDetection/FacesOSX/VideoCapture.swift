//
//  VideoCapture.swift
//  FacesOSX
//
//  Created by Sheila Gonzalez on 2019-10-21.
//  Copyright © 2019 Sheila Gonzalez. All rights reserved.
//

import Cocoa
import AVFoundation


protocol VideoCaptureOSXDelegate : class {
    func captured(pixelBuffer : CVPixelBuffer)
}


class VideoCapture: NSObject {
    weak var delegate : VideoCaptureOSXDelegate?
    public var resolution = AVCaptureSession.Preset.vga640x480
    
    private let captureSession = AVCaptureSession()
    // Create a serial queue that will handle the work related to the session
    private let sessionQueue = DispatchQueue(label: "session queue")
    
    
    func stopCamera(){
        captureSession.stopRunning()
    }
    
    
    override init() {
        super.init()
        
        sessionQueue.async {
            [unowned self] in
            self.configCapture()
            self.captureSession.startRunning()
        }
    }
    

    private func configCapture() {
        // Start configuration
        captureSession.beginConfiguration()
            // ==================================================
            // -----> INPUT
            let device = AVCaptureDevice.devices(for: .video)
            let videoDevice = device.first
            //let videoDevice = AVCaptureDevice.default(for: .video)
            guard
                let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
                captureSession.canAddInput(videoDeviceInput)
                else { return }
            captureSession.addInput(videoDeviceInput)
        
            // -----> OUTPUT
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer"))
            guard captureSession.canAddOutput(videoOutput)
                else { return }
            captureSession.sessionPreset = resolution
            captureSession.addOutput(videoOutput)
            // ==================================================
        // Finis configuration
        captureSession.commitConfiguration()
    }
}


extension VideoCapture : AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        // Convert to pixelBuffer -- good option for CoreML
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // Dispatch pixel buffer to delegate
        DispatchQueue.main.async {
            [unowned self] in
            self.delegate?.captured(pixelBuffer: imageBuffer)
        }
    }
}
