//
//  ViewController_Job_CAM.swift
//  Socal_2106
//
//  Created by Long Bui on 6/24/21.
//

import UIKit
import AVFoundation

protocol TrackingNo_SendingDelegateProtocol {
    func send_TrackingNo_ToFirstViewController(myData: String)
}

class ViewController_Job_CAM: UIViewController {
    
    var delegate: TrackingNo_SendingDelegateProtocol? = nil
        
        public var TrackNo : String = ""  // to pass data
        
        var avCaptureSession: AVCaptureSession!
        var avPreviewLayer: AVCaptureVideoPreviewLayer!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        LoadCamera()
                //Swipe from Left to Right to TurnOff Camera
                let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
                        swipeLeft.direction = UISwipeGestureRecognizer.Direction.right
                        self.view.addGestureRecognizer(swipeLeft)
                        view.isUserInteractionEnabled = true
                
    }
    
    @objc func swipe(){
                    self.dismiss(animated: true, completion: nil)
    }
    
    func LoadCamera()
        {
            avCaptureSession = AVCaptureSession()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
                    self.failed()
                    return
                }
                let avVideoInput: AVCaptureDeviceInput
                
                do {
                    avVideoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
                } catch {
                    self.failed()
                    return
                }
                
                if (self.avCaptureSession.canAddInput(avVideoInput)) {
                    self.avCaptureSession.addInput(avVideoInput)
                } else {
                    self.failed()
                    return
                }
                
                let metadataOutput = AVCaptureMetadataOutput()
                
                if (self.avCaptureSession.canAddOutput(metadataOutput)) {
                    self.avCaptureSession.addOutput(metadataOutput)
                    
                    metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417, .upce, .code128, .code39, .code39Mod43, .code93, .interleaved2of5, .itf14, .upce]
                    
                    
                    
                } else {
                    self.failed()
                    return
                }
                
                
                self.avPreviewLayer = AVCaptureVideoPreviewLayer(session: self.avCaptureSession)
                self.avPreviewLayer.frame = self.view.layer.bounds
                self.avPreviewLayer.videoGravity = .resizeAspectFill
                self.view.layer.addSublayer(self.avPreviewLayer)
            
    //          Draw a rectangle FOCUS
                let rectangle: UIBezierPath = UIBezierPath(rect: CGRect(x: UIScreen.main.bounds.size.width/4, y: UIScreen.main.bounds.size.height/2.5, width: UIScreen.main.bounds.size.width/2, height: UIScreen.main.bounds.size.height/8))
                UIColor.clear.setFill()
                        rectangle.fill()
                UIColor.white.setStroke()
                        rectangle.lineWidth = 2
                        rectangle.stroke()
                rectangle.usesEvenOddFillRule = true

                        let boundingLayer: CAShapeLayer = CAShapeLayer.init()
                boundingLayer.path = rectangle.cgPath
                boundingLayer.fillColor = UIColor.clear.cgColor
                boundingLayer.strokeColor = UIColor.white.cgColor
                self.view.layer.addSublayer(boundingLayer)
        
                self.avCaptureSession.startRunning()
                
                
            }
        }
        

        
        func failed() {
            let ac = UIAlertController(title: "Scanner not supported", message: "Please use a device with a camera. Because this device does not support scanning a code", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            avCaptureSession = nil
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            if (avCaptureSession?.isRunning == false) {
                avCaptureSession.startRunning()
            }
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            if (avCaptureSession?.isRunning == true) {
                avCaptureSession.stopRunning()
                
            }
        }
        
        override var prefersStatusBarHidden: Bool {
            return true
        }
        
        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .portrait
        }

        
    }
        extension ViewController_Job_CAM : AVCaptureMetadataOutputObjectsDelegate {
            func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
                avCaptureSession.stopRunning()
                
                if let metadataObject = metadataObjects.first {
                    guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                    guard let stringValue = readableObject.stringValue else { return }
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    found(code: stringValue)
                    
                }
                
                let dataToBeSent = self.TrackNo
                self.delegate?.send_TrackingNo_ToFirstViewController(myData: dataToBeSent)
                
                //Return to previous View Controller (Gage Update)
                dismiss(animated: true, completion: nil)
            }
            
            func found(code: String) {
                print(code)
                TrackNo = code
            }
            
        }
