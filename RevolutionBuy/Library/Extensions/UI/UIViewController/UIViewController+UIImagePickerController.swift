//
//  UIViewController+UIImagePickerController.swift
//
//  Created by Arvind Singh on 19/05/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import AVFoundation
import MobileCoreServices
import Photos

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func captureImageFromDevice(camera fromCamera: Bool, useFrontCam: Bool = true, returnDelegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? = nil) {

        if fromCamera == true {
            self.checkCameraPermission(useFrontCam: useFrontCam, delegate: returnDelegate)
        } else {
            self.checkPhotoLibraryPermission(useFrontCam: useFrontCam, delegate: returnDelegate)
        }
    }

    private func checkCameraPermission(useFrontCam: Bool, delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?) {

        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)

        if (authStatus == AVAuthorizationStatus.authorized) {
            self.openImagePicker(useFrontCam: useFrontCam, source: UIImagePickerControllerSourceType.camera, delegate: delegate)
        } else if (authStatus == AVAuthorizationStatus.notDetermined) {

            LogManager.logDebug("Camera access not determined. Ask for permission.")

            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted: Bool) in
                if granted == true {
                    LogManager.logDebug("Got Access")
                    self.openImagePicker(useFrontCam: useFrontCam, source: UIImagePickerControllerSourceType.camera, delegate: delegate)
                } else {
                    LogManager.logDebug("User denied the permission")
                }
            })
        } else if (authStatus == AVAuthorizationStatus.restricted) {
            RBAlert.showWarningAlert(message: "You have restricted permissions for this. Please go to settings and enable restrictions for photo library", completion: nil)
        } else {
            RBAlert.showWarningAlert(message: "You do not have permissions enabled for this. Please go to settings and enable permissions for photo library", completion: nil)
        }
    }


    private func checkPhotoLibraryPermission(useFrontCam: Bool, delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?) {

        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
        case .authorized:
            self.openImagePicker(useFrontCam: useFrontCam, source: UIImagePickerControllerSourceType.photoLibrary, delegate: delegate)

        case .denied :
            RBAlert.showWarningAlert(message: "You do not have permissions enabled for this. Please go to settings and enable permissions for photo library", completion: nil)

        case .restricted :
            RBAlert.showWarningAlert(message: "You have restricted permissions for this. Please go to settings and enable restrictions for photo library", completion: nil)

        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                    self.openImagePicker(useFrontCam: useFrontCam, source: UIImagePickerControllerSourceType.photoLibrary, delegate: delegate)

                case .denied :
                    RBAlert.showWarningAlert(message: "You do not have permissions enabled for this. Please go to settings and enable permissions for photo library", completion: nil)

                case .restricted :
                    RBAlert.showWarningAlert(message: "You have restricted permissions for this. Please go to settings and enable restrictions for photo library", completion: nil)

                case .notDetermined:
                    // won't happen but still
                    break
                }
            }
        }
    }

    private func openImagePicker(useFrontCam: Bool, source: UIImagePickerControllerSourceType, delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?) {

        var isFromViewController = true
        var theDelegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate = self
        if delegate != nil {
            theDelegate = delegate!
            isFromViewController = false
        }

        if UIImagePickerController.isSourceTypeAvailable(source) {

            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.allowsEditing = isFromViewController
                picker.sourceType = source
                if source == .camera {
                    picker.cameraCaptureMode = .photo

                    if useFrontCam {
                        picker.cameraDevice = UIImagePickerControllerCameraDevice.front
                    } else {
                        picker.cameraDevice = UIImagePickerControllerCameraDevice.rear
                    }
                }
                picker.delegate = theDelegate
                self.present(picker, animated: true, completion: nil)
            }

        } else {
            DispatchQueue.main.async {
                RBAlert.showWarningAlert(message: "Source type hasn't found the device", completion: nil)
            }
        }
    }

    //MARK: - UIImagePickerControllerDelegate
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Cancelled
        picker.dismiss(animated: true, completion: nil)
    }
}
