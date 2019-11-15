//
//  ScreenRecordViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/11/6.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import ReplayKit
import AVKit

let window = UIApplication.shared.keyWindow as! FXWindow
class ScreenRecordViewController: UIViewController, RPPreviewViewControllerDelegate {
    let recorder = RPScreenRecorder.shared()
    @IBOutlet weak var animationView: PinchView!
    private var isRecording = false
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var micToggle: UISwitch!
    @IBOutlet weak var recordButton: UIButton!
    let  tmpFileURL = URL(fileURLWithPath: "\(NSTemporaryDirectory())tmp\(arc4random()).mp4")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RPScreenRecorder.shared().delegate = self
        recordButton.layer.cornerRadius = 32.5
        window.addPannel()
        startRecordingw()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        window.removePannel()
    }
    
    func viewReset() {
        micToggle.isEnabled = true
        statusLabel.text = "Ready to Record"
        statusLabel.textColor = UIColor.black
        recordButton.backgroundColor = UIColor.green
    }
      
    @IBAction func recordButtonTapped() {
        if !isRecording {
            window.startShowDot()
            startRecording()
        } else {
            window.dismiss()
            stopRecording()
        }
    }
      
    fileprivate func startRecording() {
        guard recorder.isAvailable else {
          print("Recording is not available at this time.")
          return
        }
        if micToggle.isOn {
          recorder.isMicrophoneEnabled = true
        } else {
          recorder.isMicrophoneEnabled = false
        }
        if #available(iOS 11.0, *) {
            recorder.startCapture(handler: { (buffer, type, _) in
                self.isRecording = true
                switch type {
                case .audioApp:
                    print("audioApp")
                case .audioMic:
                    print("audioMic")
                case .video:
                    print("video")
                    if let assetWriter = self.assetWriter {
                           if assetWriter.status != .writing && assetWriter.status != .unknown {
                               return
                           }
                       }
                    if let assetWriter = self.assetWriter,  assetWriter.status == .unknown {
                           assetWriter.startWriting()
                            assetWriter.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(buffer))
                    } else {
                        self.videoWriterInput!.append(buffer)
                    }
                }
            }, completionHandler: { error in
                if error != nil {
                    
                }
            })
        } else {
            debugPrint("录屏仅支持iOS11以上的系统")
        }
    }
      
     fileprivate func stopRecording() {
        if #available(iOS 11.0, *) {
            recorder.stopCapture { (error) in
                self.isRecording = false
                  print("Stopped recording")
                self.assetWriter?.finishWriting {
                    print("finishWriting")
                    print("tmpFileURL:\(self.tmpFileURL)")
                    let vc = AVPlayerViewController()
                    let player = AVPlayer(url: self.tmpFileURL)
                    vc.player = player
                    DispatchQueue.main.async {
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
      
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true)
        
    }
  
    
    var assetWriter: AVAssetWriter?
    var videoWriterInput: AVAssetWriterInput?
    let videoSetting: [String : Any] = [
        AVVideoCodecKey: AVVideoCodecH264,
        AVVideoWidthKey: UIScreen.main.bounds.width,
        AVVideoHeightKey: UIScreen.main.bounds.height,
        AVVideoCompressionPropertiesKey: [
            AVVideoPixelAspectRatioKey: [
                AVVideoPixelAspectRatioHorizontalSpacingKey: 1,
                AVVideoPixelAspectRatioVerticalSpacingKey: 1
            ],
            AVVideoMaxKeyFrameIntervalKey: 1,
            AVVideoAverageBitRateKey: 1280000
        ]
    ]
    func startRecordingw() {
       
        do {
            assetWriter = try AVAssetWriter(url: tmpFileURL, fileType: .mp4)
            videoWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: self.videoSetting)
            videoWriterInput!.expectsMediaDataInRealTime = true
            if assetWriter!.canAdd(videoWriterInput!) {
                assetWriter!.add(videoWriterInput!)
            }
        } catch {
            
        }
    }

}

extension ScreenRecordViewController: RPScreenRecorderDelegate {
    
    func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWith previewViewController: RPPreviewViewController?, error: Error?) {
        
    }
}
