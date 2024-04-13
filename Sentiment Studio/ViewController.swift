//
//  ViewController.swift
//  Sentiment Studio
//
//  Created by Ethan Xu on 2024-04-07.
//

import Cocoa
import AVFoundation


class ViewController: NSViewController, AVCapturePhotoCaptureDelegate {
    
    var imageView: NSImageView!
    var button: NSButton!
    var cameraView: NSView!
    
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var stillImageOutput: AVCapturePhotoOutput!
    var captureDevice: AVCaptureDevice?

    override func viewDidLoad() {
        super.viewDidLoad()

        cameraView = NSView()
        cameraView.wantsLayer = true
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cameraView)
        
        imageView = NSImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        
        button = NSButton(title: "Capture Photo", target: self, action: #selector(capturePhoto(_:)))
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        
        cameraView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        cameraView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        cameraView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: cameraView.trailingAnchor, constant: 100),
            imageView.topAnchor.constraint(equalTo: cameraView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        
        setupCamera()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @objc func capturePhoto(_ sender: NSButton) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                let settings = AVCapturePhotoSettings()
                self.stillImageOutput.capturePhoto(with: settings, delegate: self)
            } else {
                debugPrint("Camera cannot accessed")
            }
        }
    }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
        if discoverySession.devices.count > 0 {
            captureDevice = discoverySession.devices.first
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession.addInput(input)
            
            stillImageOutput = AVCapturePhotoOutput()
            captureSession.addOutput(stillImageOutput)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = .resizeAspectFill
            videoPreviewLayer.connection?.videoRotationAngle = 0
            videoPreviewLayer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            cameraView.layer?.addSublayer(videoPreviewLayer)
            
            captureSession.startRunning()
        } catch {
            print(error)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            if let image = NSImage(data: imageData) {
                imageView.image = image
                sendImageData(imageData: imageData)
            }
        }
    }
    
    func sendImageData(imageData: Data) {
        let urlString = "https://sentiment-studio-api.loca.lt/video_feed"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let base64Image = "data:image/png;base64," + imageData.base64EncodedString()
        let json: [String: Any] = ["image": base64Image]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
        } catch {
            print(error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Server returned an error: \(httpResponse.statusCode)")
            } else if let data = data {
                print("Received data: \(data)")
                
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let json = jsonObject as? [String: Any] else {
                        print("Failed to cast JSON object to [String: Any]")
                        return
                    }
                    
                    guard let base64StringWithPrefix = json["image"] as? String else {
                        print("Failed to get 'image' from JSON")
                        return
                    }
                    
                    let base64Prefix = "data:image/jpeg;base64,"
                    guard base64StringWithPrefix.hasPrefix(base64Prefix) else {
                        print("Base64 string does not have expected prefix")
                        return
                    }
                    
                    let base64String = String(base64StringWithPrefix.dropFirst(base64Prefix.count))
                    guard let imageData = Data(base64Encoded: base64String) else {
                        print("Failed to decode base64 string into Data")
                        return
                    }
                    
                    guard let receivedImage = NSImage(data: imageData) else {
                        print("Failed to create NSImage from Data")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        let targetSize = NSSize(width: 1000, height: 1000)
                        let sourceRect = NSRect(x: (receivedImage.size.width - targetSize.width) / 2,
                                                y: (receivedImage.size.height - targetSize.height) / 2,
                                                width: targetSize.width,
                                                height: targetSize.height)

                        let newImage = NSImage(size: targetSize)
                        newImage.lockFocus()
                        receivedImage.draw(in: NSRect(origin: .zero, size: targetSize),
                                           from: sourceRect,
                                           operation: .copy,
                                           fraction: 1.0)
                        newImage.unlockFocus()

                        self.imageView.image = newImage
                    }
                } catch {
                    print("Failed to parse received data into JSON: \(error)")
                }
            }
        }
        task.resume()
    }
}

#Preview {
    let vc = ViewController()
    
    return vc
}
