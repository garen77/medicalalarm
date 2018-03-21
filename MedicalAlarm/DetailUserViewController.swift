//
//  InsertUserViewController.swift
//  MedicalAlarm
//
//  Created by Crescenzo Garofalo on 25/02/18.
//  Copyright © 2018 Crescenzo Garofalo. All rights reserved.
//

import UIKit
import Foundation

class DetailUserViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var labelCaption: UILabel!
    

    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var textName: UITextField!
    
    @IBOutlet weak var labelAge: UILabel!
    
    @IBOutlet weak var textAge: UITextField!
    
    @IBOutlet weak var labelSex: UILabel!
    
    @IBOutlet weak var pickerSex: UIPickerView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var currentImage: String?
    
    var pickerSexDataSource = ["M","F"]
    
    var selectedSex = "M"
    
    var choicePhoto = false
    var frontCameraPhoto = false
    
    var user : Users?
    
    @IBOutlet weak var buttonInsertOutlet: UIButton!
    
    @IBAction func takePicture(_ sender: UITapGestureRecognizer) {

        // creiamo la ActionSheet ed installiamo i button
        let myActionSheet = UIAlertController(title: NSLocalizedString("ACTION_IMAGE_TITLE", comment: ""),
                                              message: NSLocalizedString("ACTION_IMAGE_TEXT", comment: ""),
                                              preferredStyle: UIAlertControllerStyle.actionSheet)
        
        myActionSheet.addAction( UIAlertAction(title: NSLocalizedString("BUTTON_LIBRARY", comment: ""),
                                               style: UIAlertActionStyle.default,
                                               handler: { (action) in
                                                // codice eseguito quando viene premuto questo button
                                                // invochiamo cameramanager e gli diciamo che vogliamo una foto dalla libreria
                                                CameraManager.shared.newImageLibrary(controller: self, sourceIfPad: nil, editing: false) { (image) in
                                                    // mettiamo l'immagine che arriva a video
                                                    self.imageView.image = image
                                                    self.choicePhoto = true
                                                }
        }))
        
        myActionSheet.addAction( UIAlertAction(title: NSLocalizedString("BUTTON_SHOOT", comment: ""),
                                               style: UIAlertActionStyle.destructive,
                                               handler: { (action) in
                                                // creiamo un overlay da mettere sopra alla fotocamera
                                                let circle = UIImageView(frame: UIScreen.main.bounds)
                                                circle.image = UIImage(named: "overlay")
                                                
                                                // invochiamo cameramanager e gli diciamo che vogliamo scattare una foto
                                                CameraManager.shared.newImageShootCameraType(controller: self, sourceIfPad: nil, editing: false, overlay: circle) { (image,cameraType) in
                                                    // mettiamo l'immagine che arriva a video
                                                    if cameraType == UIImagePickerControllerCameraDevice.front {
                                                        self.frontCameraPhoto = true
                                                    }
                                                    self.imageView.image = image
                                                    self.choicePhoto = true
                                                    
                                                }
        }) )
        
        // inseriamo il button Annulla
        myActionSheet.addAction( UIAlertAction(title: NSLocalizedString("BUTTON_CANCEL", comment: ""),
                                               style: UIAlertActionStyle.cancel,
                                               handler: nil) )
        
        // presentiamo l'ActionSheet
        present(myActionSheet, animated: true, completion: nil)
    }
    
    /*@IBAction func buttonInsert(_ sender: Any) {
        
        DatabaseManager.sharedInstance?.save(userModel: Users( id: 0, name: textName.text!, age: textAge.text!, sex: selectedSex))
        DatabaseManager.sharedInstance?.load()
        
        DatabaseManager.sharedInstance?.listController?.tableView.reloadData()

    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = String.localized(key: "lbl_caption")
        
        labelName.text! = String.localized(key: "lbl_name")
        
        labelAge.text! = String.localized(key: "lbl_age")
        
        labelSex.text! = String.localized(key: "lbl_sex")
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        DatabaseManager.initInstance(appDelegate: appDelegate)
        
        if user != nil {
            
            self.textAge.text! = (user?.getAge()!)!
            self.textAge.isUserInteractionEnabled = false
            
            self.textName.text! = (user?.getName()!)!
            self.textName.isUserInteractionEnabled = false
            
            self.pickerSex.selectRow(user?.getSex() == "M" ? 0 : 1, inComponent: 0, animated: false)
            
            self.imageView.contentMode = .scaleAspectFill
            self.imageView.clipsToBounds = true
            
            /*if (user?.getHasPhoto())! {
                self.imageView.setRounded()
            } else {
                self.imageView.resetRounded()
            }*/
            
            self.imageView.image = (user?.getHasPhoto())! ? FilesManager.sharedInstance.loadImage(imageName: (user?.getPhoto())!) : UIImage(named: (user?.getPhoto())!)
            
            let newBackButton = UIBarButtonItem(title: "Back",
                                                style: UIBarButtonItemStyle.plain, target: self, action: #selector(backAction))
            self.navigationItem.leftBarButtonItems?.removeAll()
            self.navigationItem.rightBarButtonItems?.removeAll()
            self.navigationItem.leftBarButtonItems?.append(newBackButton)
            
        }
    
        
        self.pickerSex.delegate = self
        self.pickerSex.dataSource = self
        
        self.textAge.delegate = self
        self.textName.delegate = self
        
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 44))
        keyboardToolbar.barStyle = UIBarStyle.blackTranslucent
        keyboardToolbar.backgroundColor = UIColor.red
        keyboardToolbar.tintColor = UIColor.white
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                   target: nil,                                   action: nil)
        let save = UIBarButtonItem(title: NSLocalizedString("ADD_CONT_DONEBUTTON", comment: ""),
                                   style: .done,
                                   target: self,
                                   action: #selector(doneBarButtonAction))
        keyboardToolbar.setItems([flex, save], animated: false)
        self.textAge.inputAccessoryView = keyboardToolbar
        
        
    }

    @objc func backAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerSexDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerSexDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSex = pickerSexDataSource[row]
        if !choicePhoto {
            debugPrint("text age : \(textAge.text!)")
            calculateDefaultImage()
        }
    }
    
    @objc func doneBarButtonAction() {
        self.textAge.resignFirstResponder()
        calculateDefaultImage()
    }
    
    func calculateDefaultImage() {
        if !choicePhoto {
            
            debugPrint("text age : \(textAge.text!)")
            if selectedSex == "M"  && ((textAge.text?.isEmpty)! || Int(textAge.text!)! <= 35 ) {
                imageView.image = #imageLiteral(resourceName: "youngMan")
                currentImage = "youngMan"
            } else if selectedSex == "M"  && ((textAge.text?.isEmpty)! || Int(textAge.text!)! > 35 ) {
                imageView.image = #imageLiteral(resourceName: "matureMan")
                currentImage = "matureMan"
            } else if selectedSex == "F"  && ((textAge.text?.isEmpty)! || Int(textAge.text!)! <= 35 ) {
                imageView.image = #imageLiteral(resourceName: "youngWoman")
                currentImage = "youngWoman"
            } else if selectedSex == "F"  && ((textAge.text?.isEmpty)! || Int(textAge.text!)! > 35 ) {
                imageView.image = #imageLiteral(resourceName: "matureWoman")
                currentImage = "matureWoman"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        calculateDefaultImage()
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textName || textField == textAge {
            animateViewMoving(up: true, moveValue: 100)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textName || textField == textAge {
            animateViewMoving(up: false, moveValue: 100)
        }
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        
        self.view.frame = self.view.frame.offsetBy(dx:0, dy:movement)
        UIView.commitAnimations()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button == saveButton else {
            debugPrint("error")
            return
        }
        
        var photo = ""
        
        if choicePhoto {
            
            photo =  "\(Int64(NSDate().timeIntervalSince1970 * 1000)).png"
            
            FilesManager.sharedInstance.saveImage(imageName: photo, image: self.imageView.image!, frontCamera: frontCameraPhoto)
            
        } else {
            photo = currentImage!
        }
    
        DatabaseManager.sharedInstance?.save(userModel: Users( id: 0, name: textName.text!, age: textAge.text!, sex: selectedSex, photo: photo, hasPhoto: choicePhoto))

    }
    

}
