//
//  ImagePicker.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/31/23.
//

import SwiftUI

struct ImageUploader {
//    static func uploadImage(with image: Data, completion: @escaping(String) -> Void) {
//        let imageData = image
//        let fileName = UUID().uuidString
//        let storageRef = Storage.storage().reference(withPath: "/profile_images/\(fileName)")
//        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
//            if let error = error {
//                print("Error uploading image to Firebase: \(error.localizedDescription)")
//                return
//            }
//            print("Image successfully uploaded to Firebase!")
//        }
//
//        storageRef.downloadURL { url, error in
//            guard let imageUrl = url?.absoluteString else { return }
//            completion(imageUrl)
//        }
//    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
//                if let data = image.pngData() {
//                    ImageUploader.uploadImage(with: data) { string in
//
//                    }
//                }
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}
