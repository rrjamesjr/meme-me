//
//  ViewController.swift
//  Meme Me
//
//  Created by Rudy James Jr on 5/18/20.
//  Copyright © 2020 James Consutling LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    private var topEdited: Bool = false
    private var bottomEdited: Bool = false
    private var bottomFieldActive: Bool = false
    private var createdMemes: [Meme] = [Meme]()
    
    private let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -4.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTextField(textField: topTextField)
        setupTextField(textField: bottomTextField)
        reset()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    fileprivate func setupTextField(textField: UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textColor = .white
        textField.tintColor = .white
        textField.textAlignment = .center
        textField.delegate = self
    }

    fileprivate func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: UIBarButtonItem) {
        openImagePicker(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_sender: Any) {
        openImagePicker(sourceType: .camera)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func reset() {
        imagePickerView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        bottomEdited = false
        topEdited = false
        shareButton.isEnabled = false
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        controller.completionWithItemsHandler = {
          (activity, success, items, error) in
            if(success && error == nil){
                //Do Work
                self.saveMeme(memedImage: items?[0] as! UIImage)
            }
            else if (error != nil){
                //log the error
            }
        };
        present(controller, animated: true)
        
    }
    
    fileprivate func saveMeme(memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        createdMemes.append(meme)
    }
    
    @IBAction func reset(_ sender: Any) {
        reset()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
            imagePickerView.contentMode = .scaleAspectFit
        }
        
        dismiss(animated: true, completion: nil)
        shareButton.isEnabled = true
    }
    
    @IBAction func editingDidBegin(_ sender: UITextField) {
        if !topEdited && sender.tag == 0 {
            topEdited = true
            sender.text = ""
        }
        else if !bottomEdited && sender.tag == 1 {
            bottomEdited = true
            sender.text = ""
            bottomFieldActive = true
        }
    }
    
    @IBAction func editingDidEnd(_ sender: UITextField) {
        if sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            if sender.tag == 0 {
                sender.text = "TOP"
                topEdited = false
            } else {
                sender.text = "BOTTOM"
                bottomEdited = false
            }
        }
        
        bottomFieldActive = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomFieldActive {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomFieldActive {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func generateMemedImage() -> UIImage {
        bottomToolbar.isHidden = true
        topToolBar.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        bottomToolbar.isHidden = false
        topToolBar.isHidden = false

        return memedImage
    }
}

