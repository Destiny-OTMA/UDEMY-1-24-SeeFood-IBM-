//
//  ViewController.swift
//  SeeFood
//
//  Created by Destiny Sopha on 8/23/2019.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import SVProgressHUD
import Social

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  let apiKey = "Nj5TLCcUF_a9rU34eywwhiud7cMNbVxjyT-KEdq9zuTS" // the API key from my IBM Bluemix Dashboard (found under services: Watson)
  let version = "2019-8-27"
  
  //  @IBOutlet weak var shareButton: UIButton!
  //  @IBOutlet weak var topBarImageView: UIImageView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var CameraButton: UIBarButtonItem!
  @IBOutlet weak var photosButton: UIBarButtonItem!
  
  
  let imagePicker = UIImagePickerController()
  var classificationResults : [String] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    shareButton.isHidden = true
    
    imagePicker.delegate = self
  }
  
  func imagePickerController(_ picker:UIImagePickerController, didfFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    CameraButton.isEnabled = false
    SVProgressHUD.show()
    
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      
      // Show the full sized chosen image on our Image View
      imageView.image = image

      imagePicker.dismiss(animated: true, completion: nil)
      
      let visualRecognition = VisualRecognition(version: version, apiKey: apiKey)
      
      // Compress the chosen image. Scale the size down to 1% of its original size.
      let imageData = image.jpegData(compressionQuality: 0.01)
      
      // Get the URL for our Documents directory
      // Results: file:///Users/destinysApple/Documents/
      let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
      
      
      // Create a file URL by adding a file name to the end of the Documents URL
      // Results: file:///Users/destinysApple/Documents/tempImage.jpg
      let fileURL = documentsURL.appendingPathComponent("tempImage.jpg")
      
      try? imageData?.write(to: fileURL, options: [])

      
      visualRecognition.classify(imageFile: fileURL, success: { (classifiedImages) in
        let classes = classifiedImages.images.first!.classifiers.first!.classes

        self.classificationResults = []

        for index in 0..<classes.count {
          self.classificationResults.append(classes[index].classification)
        }
        print(classifiedImages)

        DispatchQueue.main.async {
          self.cameraButton.isEnabled = true
          SVProgressHUD.dismiss()
          self.shareButton.isHidden = false
        }

        if self.classificationResults.contains("hotdog") {
          DispatchQueue.main.async {
            self.navigationItem.title = "Hotdog!"
            self.navigationController?.navigationBar.barTintColor = UIColor.green
            self.navigationController?.navigationBar.isTranslucent = false
            self.topBarImageView.image = UIImage(named:"hotdog")

          }
        }

        else {
          DispatchQueue.main.async {
            self.navigationItem.title = "Not Hotdog!"
            self.navigationController?.navigationBar.barTintColor = UIColor.red
            self.navigationController?.navigationBar.isTranslucent = false
            self.topBarImageView.image = UIImage(named:"not-hotdog")
          }

        }

      })


    } else {
      print("There was an error picking the image")
    }

  }

  
  
  
  
//
// These lines can all be deleted after the remaining error is resolved
//      visualRecognition.classify(success: { (classifiedImages) in
//  if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//
//    imageView.image = image
//
//    imagePicker.dismiss(animated: true, completion: nil)
//
//    let visualRecognition = VisualRecognition(version: version, apiKey: apiKey)
//
//    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//
//    let imageData = image.jpegData(compressionQuality: 0.5)
//
//    let imageURL = documentsURL.appendingPathComponent("tempImage.jpg")
//
//    try? imageData?.write(to: imageURL, options: [])
//
//    visualRecognition.classify(imagesFile: imageURL) { response, error in
//      if let error = error {
//        print(error)
//      }
//      guard let classifiedImages = response?.result else {
//        print("Failed to classify the image")
//        return
//      }
//      let classes = classifiedImages.images.first!.classifiers.first!.classes
//
//      for index in 0..<classes.count{
//        self.classificationResults.append(classes[index].className)
//      }
//
//      print(self.classificationResults)
//
//      if self.classificationResults.contains("hotdog"){
//        DispatchQueue.main.async {
//          self.navigationItem.title = "Hotdog!"
//        }
//      }
//      else{
//        DispatchQueue.main.async {
//          self.navigationItem.title = "Not Hotdog!"
//        }
//      }
//    }
//  }
//}
  
  
  
  //
  // In this new replacement version of the the didFinishPickingMediaWithInfo function,
  // we create a resized version of the image (smallImage), Tom picked a 10% compression
  // factor, which is about the sweet spot.
  //
  //  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
  //    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
  //      imageView.image = image
  //
  //      imagePicker.dismiss(animated: true, completion: nil)
  //
  //      let visualRecognition = VisualRecognition(version: version, apiKey: apiKey)
  //
  //      guard let smallImage = image.resized(withPercentage: 0.1) else { fatalError("Couldn't create small image")}
  //
  //      visualRecognition.classify(image: smallImage) { response, error in
  //        if let error = error {
  //          print(error)
  //        }
  //        guard let classifiedImages = response?.result else {
  //          print("Failed to classify the image")
  //          return
  //        }
  //        print(classifiedImages)
  //      }
  //
  //    } else {
  //      print("Error")
  //    }
  //  }
  //
  
  
  
  
  @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
    
    imagePicker.sourceType = .savedPhotosAlbum // using this because simulator does not have a camera
    //  imagePicker.sourceType = .camera // (delete the livePhotosAlbum on the line above after app is finished)
    imagePicker.allowsEditing = false
    
    present(imagePicker, animated: true, completion: nil)
    
  }
  
  
  @IBAction func photosButtonTapped(_ sender: UIBarButtonItem) {
    
    //    imagePicker.sourceType = .savedPhotosAlbum // use this if .photoLibrary does not work on the simulator
    imagePicker.sourceType = .photoLibrary
    imagePicker.allowsEditing = false
    
    present(imagePicker, animated: true, completion: nil)
    
  }
  
  
  @IBAction func shareTapped(_ sender: UIButton) {
    
    if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
      let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
      vc?.setInitialText("My food is \(navigationItem.title!)")
      vc?.add(#imageLiteral(resourceName: "hotdogBackground"))
      present(vc!, animated: true, completion: nil)
      
    } else {
      self.navigationItem.title = "Please log in to Twitter"
    }
    
  }
  
}


//
// There was a problem with the original code due to deprecation from older
// versions of Swift. In this solution, we send through a UIImage, so we
// don't need to set imageData, documentsURL, url etc. However, IBM will
// reject requests that have too big a file size, so we need to resize the
// UIImage before we send the classify request.
//
// This extension will handle the image resizing.
//
//
//extension UIImage {
//  func resized(withPercentage percentage: CGFloat) -> UIImage? {
//    let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
//    return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
//      _ in draw(in: CGRect(origin: .zero, size: canvas))
//    }
//  }
//  func resized(toWidth width: CGFloat) -> UIImage? {
//    let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
//    return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
//      _ in draw(in: CGRect(origin: .zero, size: canvas))
//    }
//  }
//}
