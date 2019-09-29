//
//  ViewController.swift
//  PhotoBooth
//
//  Created by Sheila Gonzalez on 2019-09-28.
//  Copyright © 2019 Sheila Gonzalez. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {
    enum ColorFilter {
        case color
        case grayscale
        case sepia
    }
    
    enum EffectFilter {
        case none
        case gloom
        case sharpen
    }
    
    
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var radioColor: NSButton!
    @IBOutlet weak var radioGray: NSButton!
    @IBOutlet weak var radioSepia: NSButton!
    @IBOutlet weak var radioGloom: NSButton!
    @IBOutlet weak var radioSharpen: NSButton!
    @IBOutlet weak var radioNoEffect: NSButton!
    
    
    var frameCapture : FrameCaptureOSX!
    let context = CIContext()
    var colorFilter = ColorFilter.color
    var effectFilter = EffectFilter.none
    
    @IBAction func radioButtonChanged(_ sender: AnyObject) {
        if radioColor.state == .on {
            colorFilter = ColorFilter.color
        } else if radioGray.state == .on {
            colorFilter = ColorFilter.grayscale
        } else {
            colorFilter = ColorFilter.sepia
        }
    }
    
    @IBAction func effectRadioButtonChanged(_ sender: AnyObject) {
        if radioNoEffect.state == .on {
            effectFilter = EffectFilter.none
        } else if radioGloom.state == .on {
            effectFilter = EffectFilter.gloom
        } else {
            effectFilter = EffectFilter.sharpen
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        frameCapture = FrameCaptureOSX()
        frameCapture.delegate = self
        
        radioColor.state = .on
        radioNoEffect.state = .on
    }

    override var representedObject: Any? {
        didSet {
        }
    }

    override func viewWillDisappear() {
        frameCapture.stopCamera()
    }
}


extension ViewController : FrameCaptureOSXDelegate {
    func captured(image: CIImage) {
        var colorImage : CIImage!
        var effectImage : CIImage!
        
        // COLOR FILTER
        switch colorFilter {
        case ColorFilter.color:
            colorImage = image
        case ColorFilter.grayscale:
            guard let processed = image.toGrayscale(context: self.context) else {
                colorImage = image
                break
            }
            colorImage = processed
        case ColorFilter.sepia:
            guard let processed = image.toSepia(context: self.context) else {
                colorImage = image
                break
            }
            colorImage = processed
        }
        
        // EFFECT FILTER
        switch effectFilter {
        case EffectFilter.none:
            effectImage = colorImage
        case EffectFilter.gloom:
            guard let processed = colorImage.highlight(context: self.context) else {
                effectImage = colorImage
                break
            }
            effectImage = processed
        case EffectFilter.sharpen:
            guard let processed = colorImage.sharpen(context: self.context) else {
                effectImage = colorImage
                break
            }
            effectImage = processed
        }
        
        self.imageView.image = effectImage.toNSImage(context: self.context)
    }
}
