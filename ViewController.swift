//
//  ViewController.swift
//  Trash.ai
//
//  Created by Saloni Agshiker on 12/17/24.
//

import UIKit
import AVFoundation
import CoreML
import Vision

class ObjectDetector {
    private var visionModel: VNCoreMLModel
    
    init() {
        do {
            // Load the Core ML model
            let modelURL = Bundle.main.url(forResource: "best", withExtension: "mlmodel")!
            visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
        } catch {
            fatalError("Failed to load Core ML model: \(error)")
        }
    }
    
    func detectObjects(in image: CGImage, completion: @escaping ([VNRecognizedObjectObservation]) -> Void) {
        let request = VNCoreMLRequest(model: visionModel) { request, error in
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                completion([])
                return
            }
            completion(results)
        }
        
        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform detection: \(error)")
            completion([])
        }
    }
}


