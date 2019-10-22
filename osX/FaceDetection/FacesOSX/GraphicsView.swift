//
//  GraphicsView.swift
//  FacesOSX
//
//  Created by Sheila Gonzalez on 2019-10-22.
//  Copyright © 2019 Sheila Gonzalez. All rights reserved.
//

import Cocoa

class GraphicsView: NSView {
    public var rects = [NSRect]()
    private let color = NSColor(calibratedRed: 1, green: 1, blue: 1, alpha: 0.6)

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        if rects.isEmpty {
            return
        }
        
        color.setFill()
        for rect in rects {
            let x = rect.origin.x * dirtyRect.width
            let y = dirtyRect.height * rect.origin.y
            let width = rect.width * dirtyRect.width
            let height = rect.height * dirtyRect.height
            __NSRectFill(NSRect(x: x, y: y, width: width, height: height))
        }
    }
}
