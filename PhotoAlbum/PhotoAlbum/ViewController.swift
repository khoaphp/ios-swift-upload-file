//
//  ViewController.swift
//  PhotoAlbum
//
//  Created by Khoa Phạm on 25/03/2022.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imgv_Photo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func choosePhoto(_ sender: Any) {
        let image = UIImagePickerController();
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage{
            imgv_Photo.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadPhoto(_ sender: Any) {
        uploadPhoto(paramName: "avatar", fileName: "myavatar.png", image: imgv_Photo.image!)
    }
    
    func uploadPhoto(paramName:String, fileName:String, image:UIImage){
        let url = URL(string: "http://localhost:3000/uploadFile")
        let boundary = UUID().uuidString
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        URLSession.shared.uploadTask(with: urlRequest, from: data) { data, urlReponse, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                print(jsonData)
            }
        }.resume()
    }
}

