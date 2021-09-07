//
//  ViewController.swift
//  SystemViewControllers2
//
//  Created by Александр on 26.04.21.
//

import UIKit
// Нужно чтобы подключить функционал браузера
import SafariServices
// для возможности отпарки электронного письма
import MessageUI

// Делегаты нужны чтобы использовать UIImagePickerController (получить доступ к камере и выбрать изображение), затем для отправки почты? последнее для сообщений
class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        let activityContriller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        // строка ниже нужна для айпадов
        activityContriller.popoverPresentationController?.sourceView = sender
        present(activityContriller, animated: true, completion: nil)
    }
    
    @IBAction func safariButtonTapped(_ sender: UIButton) {
        if let url = URL(string: "http://www.apple.com") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        // доступ к камере (выбор изображений)
        let imagePiker = UIImagePickerController()
        imagePiker.delegate = self
        
        let alertController = UIAlertController(title: "Chose Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
            imagePiker.sourceType = .camera
            self.present(imagePiker, animated: true, completion: nil)
        })
        alertController.addAction(cameraAction)
    }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            imagePiker.sourceType = .photoLibrary
            self.present(imagePiker, animated: true, completion: nil)
        })
            alertController.addAction(photoLibraryAction)
        }
        
        alertController.popoverPresentationController?.sourceView = sender
        
        present(alertController, animated: true, completion: nil)
        
    }
    // метод позволяет заменять начальое фото на фото из библиотеки
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else { print("Can not send mail")
            return }
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        // настройка функций отправляемого письма
        mailComposer.setToRecipients(["endemol@tut.by"])
        mailComposer.setSubject("Look at this")
        mailComposer.setMessageBody("Hello, this is an email from the app I made", isHTML: false)
        
        if let image = imageView.image, let jpegData = image.jpegData(compressionQuality: 0.9) {
            mailComposer.addAttachmentData(jpegData, mimeType: "image/jpeg", fileName: "photo.jpg")
        }
        present(mailComposer, animated: true, completion: nil)
    }
    // после отправки письма метод отключает контроллер и возвращается в приложение
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func messegeComposeController(_ sender: UIButton) {
        guard MFMessageComposeViewController.canSendText() else { return }
        let messegeCompose = MFMessageComposeViewController()
        messegeCompose.messageComposeDelegate = self
        // Configure the fields of the interface
        messegeCompose.recipients = ["0123456789"]
        messegeCompose.body = "Hello from Belarus"
        // present the view controller modally
        self.present(messegeCompose, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

