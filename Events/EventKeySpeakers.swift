//
//  EventKeySpeakers.swift
//  Events
//
//  Created by Bhaskar Ghosh on 25/03/16.
//  Copyright © 2016 Bhaskar Ghosh. All rights reserved.
//

import UIKit

class Person {
    
    var personImageFilePath: String?
    var personImageUrl: String!
    var personName: String!
    var personDesignation: String!
    var personDetail: String!
}

class EventKeySpeakers: NSObject {
    
    var header: EventSegmentHeader!
    
    var persons: NSArray!
    var departments: NSArray!
    
    override init() {
        
        super.init()
        
        self.header = EventSegmentHeader()
    }

}
