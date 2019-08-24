//
//  ViewController.swift
//  SeeFood
//
//  Created by Destiny Sopha on 8/23/2019.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var CameraButton: UIBarButtonItem!
  @IBOutlet weak var photosButton: UIBarButtonItem!
  
  let imagePicker = UIImagePickerController()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    imagePicker.delegate = self
    
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      
      imageView.image = image
      
      imagePicker.dismiss(animated: true, completion: nil)
      
    } else {
      print("There was an error picking the image.")
    }
    
  }
  

  @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
    
//    imagePicker.sourceType = .camera
    imagePicker.sourceType = .savedPhotosAlbum // using this because simulator does not have a camera
    imagePicker.allowsEditing = false
    
    present(imagePicker, animated: true, completion: nil)

  }

  
  
  @IBAction func photosButtonTapped(_ sender: UIBarButtonItem) {
    
//    imagePicker.sourceType = .savedPhotosAlbum // use this if .photoLibrary does not work on the simulator
    imagePicker.sourceType = .photoLibrary
    imagePicker.allowsEditing = false

    present(imagePicker, animated: true, completion: nil)

  }
  
  
}

