//
//  EventDescriptions.swift
//  Events
//
//  Created by Bhaskar Ghosh on 25/03/16.
//  Copyright © 2016 Bhaskar Ghosh. All rights reserved.
//

import UIKit

class EventDescriptions: NSObject {
    
    //MARK: - properties declaration -
    var header: EventSegmentHeader!
    var subHeaders: NSArray!
    
    var sectionIds: NSMutableArray!
    
    //MARK: - initializers -
    override init() {
        
        super.init()
        
        self.header = EventSegmentHeader()
        
        self.sectionIds = NSMutableArray()
    }

}
