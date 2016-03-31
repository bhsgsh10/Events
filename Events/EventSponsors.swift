//
//  EventSponsors.swift
//  Events
//
//  Created by Bhaskar Ghosh on 26/03/16.
//  Copyright © 2016 Bhaskar Ghosh. All rights reserved.
//

import UIKit

class Team {
    
    var teamName: String!
    var teamDetail: String!
    var teamSubHeader: EventSegmentSubHeader!
}

class Company {
    
    var companyName: String!
    var companyDetail: String!
    var companyImageUrl: String!
}

class EventSponsors: NSObject {
    
    //MARK:- properties declaration -
    var header: EventSegmentHeader!
    var teams: NSArray!
    var companies: NSArray!
    
    //MARK: - inititlizers -
    override init() {
        
        super.init()
        
        self.header = EventSegmentHeader()
    }
}
