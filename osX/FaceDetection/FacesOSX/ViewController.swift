//
//  ViewController.swift
//  FacesOSX
//
//  Created by Sheila Gonzalez on 2019-10-21.
//  Copyright © 2019 Sheila Gonzalez. All rights reserved.
//

import Cocoa
import Vision


class ViewController: NSViewController {
    // We need two views:
    // imageView will display the frames from the camera
    // graphicsView will display the detection rects (custom view)
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var graphicsView: GraphicsView!
    
    var videoCapture : VideoCapture!
    let context = CIContext()
    
    // The face detection is slooooow, so it will be performed
    // once every "maxFrames"
    var frameCount = 0
    let maxFrames = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Start video capture, set this class as delegate
        // and choose the resolution of the camera
        // If the resolution is bigger, the time processing
        // frace detection will also increase
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.resolution = .vga640x480
    }

    override var representedObject: Any? {
        didSet {
        
        }
    }

    // If the app window dissapears, stop the camera
    override func viewWillDisappear() {
        videoCapture.stopCamera()
    }
    
    
    // Face detection using Vision framework
    func detectFaces(pixelBuffer : CVPixelBuffer) {
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do {
            try handler.perform([request])
        } catch let reqErr {
            print("Failed to perform request:", reqErr)
        }
    }
    
    // Vision framework request, with completion handler.
    // Every time the handler.perform (line 57) is called,
    // the code inside this completion handler will be called.
    lazy var request = VNDetectFaceRectanglesRequest { (req, error) in
        // If no faces could be detected
        if let error = error {
            print("Failed to detect faces:", error)
            return
        }
        
        // Put every detected face's bounding box inside an array
        var rects = [NSRect]()
        req.results?.forEach({ (res) in
            guard let faceObservation = res as? VNFaceObservation
                else { return }
            rects.append(faceObservation.boundingBox)
        })
        
        // For main trhead
        DispatchQueue.main.async{
            // Put the bounding boxes inside the graphics view
            self.graphicsView.rects = rects
            // Repaint!
            self.graphicsView.setNeedsDisplay(self.view.frame)
        }
    }
}


extension ViewController : VideoCaptureOSXDelegate {
    func captured(pixelBuffer: CVPixelBuffer) {
        // -----> DISPLAY ON IMAGE VIEW
        // Convert cvPixelBuffer to NSImage to display output
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
            else { return }
        let imageSize = NSSize(width: cgImage.width, height: cgImage.height)
        let image = NSImage(cgImage: cgImage, size: imageSize)
        
        // Display to output image view
        self.imageView.image = image
        
        // -----> PROCESS FACE DETECTION
        frameCount += 1
        if frameCount == maxFrames {
            frameCount = 0
            // Send vision request to utility thread,
            // Utility thread is for tasks that take a while to be done
            DispatchQueue.global(qos: .utility).async {
                self.detectFaces(pixelBuffer: pixelBuffer)
            }
        }
    }
}
