//
//  EventCell.swift
//  MicrosoftChallenge
//
//  Created by Jason Piao on 2017-03-19.
//  Copyright © 2017 Jason Piao. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    @IBOutlet weak var eventTime: UILabel!
    
    @IBOutlet weak var timeUntilEvent: UILabel!
    
    @IBOutlet weak var thumbImg: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var tagColour: RoundCornerView!
    
    @IBOutlet weak var location: UILabel!

    func configureCell(event: Event) {
        
        //specifying units and arguments to calculate time between current date and event date
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.allowedUnits = [.year,.month,.weekOfYear,.day,.hour,.minute,.second]
        
        dateComponentsFormatter.maximumUnitCount = 1
        dateComponentsFormatter.unitsStyle = .full

        if let date: Date = event.fullDate as Date? {
            timeUntilEvent.text = dateComponentsFormatter.string(from: Date(), to: date)
        } else {
            timeUntilEvent.text = event.date!
        }
        
        //Different tags have different colours
        if event.tag == "Meeting" {
            tagColour.backgroundColor = UIColor.blue
            
        } else if event.tag == "Breakfast/Lunch/Dinner" {
          tagColour.backgroundColor = UIColor.yellow
            
        } else if event.tag == "Appointment" {
            tagColour.backgroundColor = UIColor.orange
            
        } else {
            tagColour.backgroundColor = UIColor.purple
        }
        
        title.text = event.title
        
        eventTime.text = event.time
        
        location.text = event.location
        
        thumbImg.image = event.toImage?.image as? UIImage
        
    }

}
