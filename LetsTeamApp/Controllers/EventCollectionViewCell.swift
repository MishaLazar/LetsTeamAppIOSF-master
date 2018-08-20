//
//  EventCollectionViewCell.swift
//  LetsTeamApp
//
//  Created by admin on 7/30/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    var EventTypeImg:UIImage?
    var EventName:String?
    
    @IBOutlet weak var EventTypeListImg: UIImageView!
    
    @IBOutlet weak var EventNameListLable: UILabel!
    
    func configureCell(EventName:String, EventTypeImg:String){
        
        self.EventTypeImg = UIImage(named: EventTypeImg)
        self.EventName = EventName
        
        EventTypeListImg.image = self.EventTypeImg
        EventNameListLable.text = self.EventName
    }
    
   
    override func prepareForReuse() {
        
        super.prepareForReuse()
        EventTypeListImg.image = nil
        EventNameListLable.text = nil
        
    }
}
