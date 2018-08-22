//
//  EditEventViewController.swift
//  LetsTeamApp
//
//  Created by admin on 8/1/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class EditEventViewController: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource ,UITextFieldDelegate{
   
    
    
    var refEvents: DatabaseReference!
    var isEditingMode: Bool = false
    var isDateSelected: Bool = false
    var selectedTxtField:UITextField?
    @IBOutlet weak var pickersView: UIView!
    @IBOutlet weak var btnSavepicker: UIButton!
    @IBOutlet weak var btnSaveEvent: UIButton!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtEventStartDate: UITextField!
    @IBOutlet weak var txtEventEndDate: UITextField!
    @IBOutlet weak var dpEventDates: UIDatePicker!
    @IBOutlet weak var txtEventType: UITextField!
    @IBOutlet weak var dpEndDate: UIDatePicker!
    @IBOutlet weak var dpStartDate: UIDatePicker!
    @IBOutlet weak var lstEventType: UIPickerView!
    @IBOutlet weak var txtEventName: UITextField!
    @IBOutlet weak var txtEventDescription: UITextView!
    
    @IBOutlet weak var switchIsActive: UISwitch!
    var viewModal:EventListViewModal = EventListViewModal.shared
    var selectedValue: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lstEventType.delegate = self
        self.lstEventType.dataSource = self
        self.txtEventEndDate.delegate = self
        self.txtEventType.delegate = self
        self.txtEventStartDate.delegate = self
        self.refEvents = Database.database().reference().child("Events")
        if isEditingMode {
            self.txtLocation.text = self.viewModal.selectedEvent?.EventLocation ?? "Not Set"
            self.txtEventName.text = self.viewModal.selectedEvent?.EventName ?? "Not Set"
            self.txtEventDescription.text = self.viewModal.selectedEvent?.EventDesc ?? "Not Set"
           /* self.dpStartDate.date = (self.viewModal.selectedEvent?.EventStartDate)!
            self.dpEndDate.date = (self.viewModal.selectedEvent?.EventEndDate)!*/
            if self.viewModal.selectedEvent?.Active == 1 {
                self.switchIsActive.isOn = true
            } else {
                self.switchIsActive.isOn = false
            }
        }
        
       // self.lstEventType.a
        //getAllEventTypes()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        //getAllEventTypes()
    }
    
    /*func getAllEventTypes() {
       
        refEvents = Database.database().reference().child("EventTypes");
        refEvents
            .observeSingleEvent(of: .value, with: { (snapshot) in
                //if the reference have some values
                if snapshot.childrenCount > 0 {
                    if self.viewModal.ETypes.count > 0 {
                        //self.viewModal.ETypes.removeAll()
                    }
                    //iterating through all the values
                    for eventType in snapshot.children.allObjects as! [DataSnapshot] {
                        //getting values
                        let eventObject = eventType.value as? [String: AnyObject]
                        let typeName = eventObject?["type"] as! String                         let typeId = eventObject?["id"] as! Int
                        let typeBckImg = eventObject?["background_img_name"] as! String
                        let typeImgName = eventObject?["img_name"] as! String
                        
                        let e1 =  EventTypes(type: typeName, id: String(typeId), background_img_name: typeBckImg, img_name: typeImgName)
                        
                        self.viewModal.ETypes.append( e1)
                    }
                }
            })
        
        self.lstEventType.delegate = self
        self.lstEventType.dataSource = self
        
    }*/
    @IBAction func pickerSaveAction(_ sender: Any) {
        self.pickersView.isHidden  =  true
        self.dpEventDates.isHidden = true
        self.lstEventType.isHidden  = true
        if self.isDateSelected {
            //need to handel datepicker
        } else {
            //need to handle type picker
        }
        self.isDateSelected = false
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
        
        switch textField.accessibilityIdentifier {
        case "StartDate":
            self.pickersView.isHidden   = false
            self.dpEventDates.isHidden = false
            self.lstEventType.isHidden = true
            self.selectedTxtField = self.txtEventStartDate
            self.isDateSelected = true
           
        case "EndDate":
            self.pickersView.isHidden   = false
            self.dpEventDates.isHidden = false
            self.lstEventType.isHidden = true
            self.selectedTxtField = self.txtEventStartDate
            self.isDateSelected = true
        case "EvenType":
            self.pickersView.isHidden   = false
            self.lstEventType.isHidden = false
            self.dpEventDates.isHidden = true
            self.isDateSelected = false
        default: break
            
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModal.ETypes.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.viewModal.ETypes[row].type
    }
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        selectedValue = self.viewModal.ETypes[lstEventType.selectedRow(inComponent: 0)].type
    }
    
    func getDateSelected(datePicker: UIDatePicker) -> String? {
        let dateFormatter = DateFormatter()
        // Now we specify the display format, e.g. "27/08/2018
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
        // Now we get the date from the UIDatePicker and convert it to a string
        
        
        return dateFormatter.string(from: datePicker.date)
    }
    
    func UpdateEvent(){
        var eventId = self.viewModal.selectedEvent?.Id ?? ""
        
        if !self.isEditingMode {
            eventId = refEvents.childByAutoId().key
        }
        
            
     
        
        let event = ["id":eventId,
                     "EventName":txtEventName.text as String?,
                     "EventDesc":txtEventDescription.text as String?,
                     "EventLocation":txtLocation.text as String?,
                     "EventType":self.selectedValue as String? ?? "other",
                     "EventStartDate":Utills.shared.dateToString(date: self.dpStartDate.date) as String?,
                     "EventEndDate":Utills.shared.dateToString(date: self.dpEndDate.date) as String?,
                     "CreatorId":self.viewModal.userid,
                     "Active":self.switchIsActive.isOn ? 1 : 0
            ] as [String : Any]
        
        if self.isEditingMode {
            self.viewModal.selectedEvent?.EventDesc = txtEventDescription.text as String?
            self.viewModal.selectedEvent?.EventName = txtEventName.text as String?
            self.viewModal.selectedEvent?.EventType = self.selectedValue as String? ?? "other"
            self.viewModal.selectedEvent?.EventLocation = txtLocation.text as String?
            self.viewModal.selectedEvent?.Active = self.switchIsActive.isOn ? 1 : 0
            
        }
        
        refEvents.child(eventId).updateChildValues(event)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
 
    @IBAction func saveEvent(_ sender: Any) {
        self.btnSaveEvent.isHidden = true
        
        //self.btnSaveEvent.loadingIndicator(show: true)
        
        self.UpdateEvent()
        
       // if !isEditingMode {
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
       // }
        //self.btnSaveEvent.loadingIndicator(show: false)
        self.btnSaveEvent.isHidden = false
    }
       
}
