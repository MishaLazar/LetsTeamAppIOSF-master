//
//  EventTypes.swift
//  LetsTeamApp
//
//  Created by admin on 8/15/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit

class EventTypes{
    
    var type: String
    var id: String
    var background_img_name: String
    var img_name: String
    
    
    init(type:String , id:String, background_img_name:String,img_name:String){
        self.type = type
        self.id = id
        self.background_img_name = background_img_name
        self.img_name = img_name
    }
}
