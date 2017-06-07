//
//  PhotoCaptureDelegate.swift
//  SelfieAppStarterProject
//
//  Created by James Rochabrun on 6/7/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit


class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    
    private(set) var requestedPhotoSettings: AVCapturePhotoSettings
    private let completed: (PhotoCaptureDelegate) -> ()
    private let capturedPhoto: (CGImage) -> ()
    
    
    init(with requestedPhotoSettings: AVCapturePhotoSettings,
         capturedPhoto: @escaping (CGImage) -> (),
         completed: @escaping (PhotoCaptureDelegate) -> ()) {
        
        self.requestedPhotoSettings = requestedPhotoSettings
        self.completed = completed
        self.capturedPhoto = capturedPhoto
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print(error)
            
        }
        
        guard let sampleBuffer = photoSampleBuffer,
            let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: nil),
            let dataProvider = CGDataProvider(data: dataImage as CFData),
            let cgImageRef = CGImage.init(jpegDataProviderSource: dataProvider, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent) else {
                print("Error on captureOutput")
                return
        }
        capturedPhoto(cgImageRef)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishCaptureForResolvedSettings resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        completed(self)
    }
}















