//
//  DetailsVC.swift
//  MicrosoftChallenge
//
//  Created by Jason Piao on 2017-03-19.
//  Copyright © 2017 Jason Piao. All rights reserved.
//

import UIKit
import CoreData

class DetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var titleTextField: CustomTextField!
    
    @IBOutlet weak var locationTextField: CustomTextField!
    
    @IBOutlet weak var DescTextField: CustomTextField!

    @IBOutlet weak var datePicker: UIDatePicker!
   
    @IBOutlet weak var tagPicker: UIPickerView!
    
    private var _tags = ["Meeting", "Breakfast/Lunch/Dinner", "Appointment", "Other"]
    
    var tags: [String] {
        return _tags
    }
    
    var eventToEdit: Event?
    
    var imgPicker: UIImagePickerController!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        locationTextField.delegate = self
        DescTextField.delegate = self
        
        tagPicker.delegate = self
        tagPicker.dataSource = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, YYYY H:mm a"
        
        if eventToEdit != nil {
            loadEventData()
        }

        imgPicker = UIImagePickerController()
        imgPicker.delegate = self
 
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let tag = _tags[row]
        return tag
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _tags.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        
        var event: Event! //guarenteed to have Event
        let pic = Image(context: context)
        pic.image = image.image
        
        //Whether we edit an event if it exists, or create a new one
        if eventToEdit == nil {
            event = Event(context: context)
        } else {
            event = eventToEdit
        }
        
        if let title = titleTextField.text {
            event.title = title
        }
        
        if let location = locationTextField.text {
            event.location = location
        }
        
        if let desc = DescTextField.text {
            event.detail = desc
        }
        
        event.toImage = pic

        event.tag = _tags[tagPicker.selectedRow(inComponent: 0)]
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, YYYY HH:mm"
        event.fullDate = datePicker.date as NSDate?
        
        
        dateFormatter.dateFormat = "MMMM dd, YYYY"
        event.date = dateFormatter.string(from: datePicker.date)
        
        dateFormatter.dateFormat = "hh:mm a"
        event.time = dateFormatter.string(from: datePicker.date)
        
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func loadEventData() {
        
        if let event = eventToEdit {
            titleTextField.text = event.title
            locationTextField.text = event.location
            DescTextField.text = event.detail
            image.image = event.toImage?.image as? UIImage
            
            if let tag = event.tag {
                //setting picker to previously chosen tag
                var i = 0
                repeat {
                    
                    let t = _tags[i]
                    if t == tag {
                        tagPicker.selectRow(i, inComponent: 0, animated: false)
                    }
                    
                    i += 1
                } while (i < _tags.count)
            }
            
        }
        
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIBarButtonItem) {
        
        if eventToEdit != nil {
            context.delete(eventToEdit!)
            ad.saveContext()
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func imgBtnPressed(_ sender: UIButton) {
        present(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image.image = img
        }
        imgPicker.dismiss(animated: true, completion: nil)
    }
    
    //Below are for dismissing keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        titleTextField.resignFirstResponder()
        locationTextField.resignFirstResponder()
        DescTextField.resignFirstResponder()
        
        return true
    }

}
