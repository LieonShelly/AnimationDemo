//
//  ScreenRecordViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/11/6.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import ReplayKit

class ScreenRecordViewController: UIViewController, RPPreviewViewControllerDelegate {
    let recorder = RPScreenRecorder.shared()
    @IBOutlet weak var animationView: TouchRecordView!
    private var isRecording = false
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var micToggle: UISwitch!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RPScreenRecorder.shared().delegate = self
        recordButton.layer.cornerRadius = 32.5
      }
      
      func viewReset() {
          micToggle.isEnabled = true
          statusLabel.text = "Ready to Record"
          statusLabel.textColor = UIColor.black
          recordButton.backgroundColor = UIColor.green
      }
      
    @IBAction func recordButtonTapped() {
          if !isRecording {
              startRecording()
          } else {
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
          recorder.startRecording{ [unowned self] (error) in
              guard error == nil else {
                  print("There was an error starting the recording.")
                  return
              }
              print("Started Recording Successfully")
              self.micToggle.isEnabled = false
              self.recordButton.backgroundColor = UIColor.red
              self.statusLabel.text = "Recording..."
              self.statusLabel.textColor = UIColor.red
              self.isRecording = true

          }
      }
      
     fileprivate func stopRecording() {
          recorder.stopRecording { [unowned self] (preview, error) in
              print("Stopped recording")
              guard preview != nil else {
                  print("Preview controller is not available.")
                  return
              }
              let alert = UIAlertController(title: "Recording Finished", message: "Would you like to edit or delete your recording?", preferredStyle: .alert)
              let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction) in
                  self.recorder.discardRecording(handler: { () -> Void in
                      print("Recording suffessfully deleted.")
                  })
              })
              let editAction = UIAlertAction(title: "Edit", style: .default, handler: { (action: UIAlertAction) -> Void in
                  preview?.previewControllerDelegate = self
                  self.present(preview!, animated: true, completion: nil)
              })
              alert.addAction(editAction)
              alert.addAction(deleteAction)
              self.present(alert, animated: true, completion: nil)
              self.isRecording = false
              self.viewReset()
          }
      }
      
      func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
          dismiss(animated: true)
      }

}

extension ScreenRecordViewController: RPScreenRecorderDelegate {
    
    func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWith previewViewController: RPPreviewViewController?, error: Error?) {
        previewViewController?.value(forKey: "movieURL")
    }
}
