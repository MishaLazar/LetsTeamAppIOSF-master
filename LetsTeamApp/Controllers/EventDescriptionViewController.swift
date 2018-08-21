//
//  EventDescriptionViewController.swift
//  LetsTeamApp
//
//  Created by admin on 8/4/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleMaps

class EventDescriptionViewController: UIViewController {

   
   
    @IBOutlet weak var EventImageView: UIImageView!
    @IBOutlet weak var EventNameLbl: UILabel!
    
    @IBOutlet weak var EventDescTxtView: UITextView!
    
    
   
    let EventTypePrefix:String = "bck_"
    var selectedEvent:Event = EventListViewModal.shared.selectedEvent!
    
    @IBOutlet weak var btnEventFavorite: UIButton!
    @IBOutlet weak var btnEventLocation: UIButton!
    @IBOutlet weak var btnChatRoom: UIButton!
    
    var EventIdSelected:String = ""
    var isListed:Bool = false
    var viewModal:EventListViewModal = EventListViewModal.shared
    
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //enableEditIfMyEvent()
        

        /*self.EventDescTxtView.text = self.selectedEvent.EventDesc
        self.EventNameLbl.text = self.selectedEvent.EventName
        self.EventImageView.image = UIImage(named: EventTypePrefix + self.selectedEvent.EventType!)
        */
        ref = Database.database().reference().child("ListedEvents").child(self.viewModal.userid!);
       // reloadStar()
        
        
        // Do any additional setup after loading the view.
    }
  
    override func viewWillAppear(_ animated: Bool) {
        enableEditIfMyEvent()
        self.EventDescTxtView.text = self.selectedEvent.EventDesc
        self.EventNameLbl.text = self.selectedEvent.EventName
        self.EventImageView.image = UIImage(named: EventTypePrefix + self.selectedEvent.EventType!)
        reloadStar()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToChatRoom(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController{
            
          self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func addEditButton (){
        let edit = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        self.navigationItem.rightBarButtonItems = [edit]

    }
    @objc func editTapped(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "EditEventViewController") as? EditEventViewController{
            
            vc.isEditingMode = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func enableEditIfMyEvent(){
        
        if self.viewModal.selectedEvent?.EventCreatorUserId == self.viewModal.userid {

            addEditButton ()
        }
        
        
    }
    @IBAction func onListInToEvent(_ sender: Any) {
        
        let listInEventUpdate = [//"EventId": self.viewModal.selectedEvent!.Id as? String,
                                 "isListed": self.isListed ? 0 : 1
            ] as [String : Any]
        
        self.isListed = self.isListed ? false : true
        reloadStar()
        ref.child((self.viewModal.selectedEvent?.Id)!).updateChildValues(listInEventUpdate)
    }
    @IBAction func goToEventLocation(_ sender: Any) {
        
        let geocoder = CLGeocoder()
        //let address =
        geocoder.geocodeAddressString((self.viewModal.selectedEvent?.EventLocation!)!, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error ?? "")
            }
            if let placemark = placemarks?.first {
                self.viewModal.selectedEventLat = placemark.location?.coordinate.latitude
                self.viewModal.selectedEventLong = placemark.location?.coordinate.longitude
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "MapLocationViewController") as? MapLocationViewController{
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
           
            
        })
        
    }
    
    
   
    @IBAction func onEditEvent(_ sender: Any) {
    }
    
    
    func reloadStar() {
        if self.isListed {
            self.btnEventFavorite.setImage(UIImage(named: "gold-Star.svg"),for: .normal)
        } else {
            self.btnEventFavorite.setImage(UIImage(named: "Empty-Star"),for: .normal)
        }
        
    }
}
