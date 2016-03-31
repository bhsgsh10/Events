//
//  ClearWaterBeachViewController+PrivateMethods.swift
//  Events
//
//  Created by Bhaskar Ghosh on 24/03/16.
//  Copyright © 2016 Bhaskar Ghosh. All rights reserved.
//

import Foundation
import UIKit

 extension ClearWaterBeachViewController {
    
    func getEntityKeyForDictionary(entityDictionary dict: NSDictionary, titleValue: String) -> String {
        
        let sectionsCollection = dict.allKeys as NSArray
        
        var entityKey: String = ""
        
        for (var nIndex = 0; nIndex < sectionsCollection.count; nIndex++) {
            
            let key = sectionsCollection.objectAtIndex(nIndex) as! String
            
            let dictForKey = dict.objectForKey(key) as! NSDictionary
            
            let titleText = dictForKey.valueForKey("title") as! String
            
            if titleText == titleValue {
                
                entityKey = key
            }
            
        }
        
        return entityKey
    }
    
    func loadSpeakerView() {
        
        
        let nibCollection = NSBundle.mainBundle().loadNibNamed(eventSpeakerViewXibName, owner: nil, options: nil) as NSArray
        
        let speakerView = nibCollection.objectAtIndex(0) as! EventSpeakerView
        
        speakerView.frame = self.containerView.bounds
        
        //get Key speakers structure for speakerView
        let keySpeakers = self.getKeySpeakersFromJsonDictionary(jsonDict: self.eventJsonDictionary)
        
        //set the key speakers property
        speakerView.keySpeakers = keySpeakers
        
        self.eventSpeakerView = speakerView
        
        //add the speaker view to the container view
        self.containerView.addSubview(speakerView)
    }
    
    func loadDescriptionsView() {
        
        //load EventDescriptionsView from nib
        let nibCollection = NSBundle.mainBundle().loadNibNamed(eventDescriptionsViewXibName, owner: nil, options: nil) as NSArray
        
        let descriptionsView = nibCollection.objectAtIndex(0) as! EventDescriptionsView
        
        descriptionsView.frame = self.containerView.bounds
        
        //get event descriptions structure from the dictionary
        let eventDescriptions = self.getDescriptionsFromJsonDictionary(jsonDict: self.eventJsonDictionary)
        
        descriptionsView.eventDescriptions = eventDescriptions
        
        self.eventDescriptionsView = descriptionsView
        
        //add the descriptions view to the container view
        self.containerView.addSubview(descriptionsView)
    }
    
    func loadSponsorsView() {
        
        //load EventSponsorsView from nib
        let nibCollection = NSBundle.mainBundle().loadNibNamed(eventSponsorsViewXibName, owner: nil, options: nil) as NSArray
        
        let sponsorsView = nibCollection.objectAtIndex(0) as! EventSponsorsView
        
        sponsorsView.frame = self.containerView.bounds
        
        //get the event sponsors structure
        let eventSponsors = self.getSponsorsListFromJsonDictionary(jsonDict: self.eventJsonDictionary)
        
        sponsorsView.eventSponsors = eventSponsors
        
        self.eventSponsorsView = sponsorsView
        
        //add the sponsors view to the container view
        self.containerView.addSubview(sponsorsView)
        
    }
    
    func loadTimelineView() {
    
        //load EventTimelineView from nib
        let nibCollection = NSBundle.mainBundle().loadNibNamed(eventTimelineViewXibName, owner: nil, options: nil) as NSArray
        
        let timelineView = nibCollection.objectAtIndex(0) as! EventTimelineView
        
        timelineView.frame = self.containerView.bounds
        
        //get the event timeline structure
        let eventTimeline = self.getTimelineFromJsonDictionary(jsonDict: self.eventJsonDictionary)
        
        timelineView.eventTimeline = eventTimeline
        
        self.eventTimelineView = timelineView
        
        //add the timeline view to the container view
        self.containerView.addSubview(timelineView)
    }
    

}