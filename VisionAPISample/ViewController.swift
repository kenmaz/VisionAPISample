//
//  ViewController.swift
//  VisionAPISample
//
//  Created by Kentaro Matsumae on 2017/06/12.
//  Copyright © 2017年 kenmaz.net. All rights reserved.
//

import UIKit
import Vision
import ImageIO

class ViewController: UIViewController {

    @IBOutlet weak var faceImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detectStart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonDidTap(_ sender: Any) {
        detectStart()
    }
    
    func detectStart() {
        guard
            let uiImage = faceImage.image,
            let ciImage = CIImage(image: uiImage)
            else {
                return
        }
        let orientation = uiImage.imageOrientation
        
        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: Int32(orientation.rawValue))
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([self.faceRequest])
            } catch {
                print(error)
            }
        }
    }
    
    /// MARK : Face Detect
    
    lazy var faceRequest: VNDetectFaceLandmarksRequest = {
        return VNDetectFaceLandmarksRequest(completionHandler: self.handleFaceLandmarks)
    }()
    
    func handleFaceLandmarks(request: VNRequest, error: Error?) {
        guard let req = request as? VNDetectFaceLandmarksRequest else {
            return
        }
        guard let results = req.results as? [VNFaceObservation] else {
            return
        }
        guard let result = results.first else {
            return
        }
        guard let lmk = result.landmarks, let face = lmk.allPoints else {
            return
        }
        let cnt = face.pointCount
        for i in 0..<cnt {
            let pt = face.point(at: i)
            print(pt)
        }
    }
}

