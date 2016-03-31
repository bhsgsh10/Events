//
//  EventTimeline.swift
//  Events
//
//  Created by Bhaskar Ghosh on 26/03/16.
//  Copyright © 2016 Bhaskar Ghosh. All rights reserved.
//

import UIKit

class TimelineSession: NSObject {
    
    var sessionsName: String!
    var sessionsDetail: String!
    
    private var sessionsCollectionInternal: NSMutableArray?
    
    override init() {
        
        super.init()
        
        self.sessionsCollectionInternal = NSMutableArray()
    }
    
    var sessionsCollection: NSArray? {
        
        return self.sessionsCollectionInternal
    }
    
    func addSessionToSessionsCollection(session: Session) {
        
        self.sessionsCollectionInternal!.addObject(session)
    }
}

class Session: NSObject {
    
    var sessionName: String!
    var sessionStartTime: String!
}

class EventTimeline: NSObject {
    
    //MARK: - properties declaration -
    var header: EventSegmentHeader!
    var timelineSessions: NSArray!
    
    //MARK: - initializers -
    override init() {
        
        super.init()
        
        self.header = EventSegmentHeader()
    }
    

}
