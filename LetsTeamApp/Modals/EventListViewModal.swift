//
//  EventListViewModal.swift
//  LetsTeamApp
//
//  Created by admin on 7/30/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation


class EventListViewModal {
    
    static let shared = EventListViewModal()
    var userid = AppUser.currentUser.uid
    var userName = AppUser.currentUser.name
    var selectedEvent:Event?
    var selectedEventLong:Double?
    var selectedEventLat:Double?
    var Events = [Event]()
    var ETypes = [EventTypes]()
    var AllEvents = [Event]()

//    private var dbRef = Database.database().reference()
    /*init(Events:[Event]){
        self.Events = Events
    }*/
    
    
    func setEvents(Events:[Event]){
        self.Events = Events
    }
    
    func setSelectedEvent(event:Event){
        self.selectedEvent = event
        
    }
    func removeSelectedEvent(){
        self.selectedEvent = nil
    }
    
    func refreshEventsData(){
       
    }
    
    func refreshLookUpData(){
        
    }
    
    
}
