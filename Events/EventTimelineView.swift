//
//  EventTimelineView.swift
//  Events
//
//  Created by Bhaskar Ghosh on 26/03/16.
//  Copyright © 2016 Bhaskar Ghosh. All rights reserved.
//

import UIKit

class EventTimelineView: UIView, UITableViewDelegate, UITableViewDataSource {

    //MARK: - constants -
    let FIRST_SESSIONS_TABLE_VIEW_TAG: NSInteger = 1000
    let SECOND_SESSIONS_TABLE_VIEW_TAG: NSInteger = 1001
    let TABLEVIEW_CELL_HEIGHT:CGFloat = 60
    
    //MARK: - IBOutlets -
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var introductionText: UITextView!
    
    @IBOutlet weak var firstSessionsTitle: UILabel!
    @IBOutlet weak var firstSessionsDetail: UITextView!
    @IBOutlet weak var firstSessionsTableView: UITableView!
    
    @IBOutlet weak var secondSessionsTitle: UILabel!
    @IBOutlet weak var secondSessionsDetail: UITextView!
    @IBOutlet weak var secondSessionsTableView: UITableView!
    
    @IBOutlet weak var thirdSessionsTitle: UILabel!
    @IBOutlet weak var thirdSessionsDetail: UITextView!
    
    //MARK: - properties declaration -
    var eventTimeline: EventTimeline!
    var isFirstTime: Bool = true
    
    //MARK: - UIView overridden methods -
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if self.isFirstTime == true {
            
            self.configureSubviewsContent()
            
            self.isFirstTime = false
        }
        
        self.firstSessionsDetail.scrollRangeToVisible(NSMakeRange(0, 0))
        self.secondSessionsDetail.scrollRangeToVisible(NSMakeRange(0, 0))
        self.thirdSessionsDetail.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    //MARK: - table view data source methods -
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return TABLEVIEW_CELL_HEIGHT
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let firstSessions = self.eventTimeline.timelineSessions.objectAtIndex(0) as! TimelineSession
        
        let secondSessions = self.eventTimeline.timelineSessions.objectAtIndex(1) as! TimelineSession
        
        var nCount = 0
        
        if tableView.tag == FIRST_SESSIONS_TABLE_VIEW_TAG {
            
            nCount = firstSessions.sessionsCollection!.count
        }
        else {
            
            nCount = secondSessions.sessionsCollection!.count
        }
        
        return nCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cellIdentifier"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if cell == nil {
            
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        var timelineSession = TimelineSession()
        
        //load the appropriate timeline session as per the table view
        if tableView.tag == FIRST_SESSIONS_TABLE_VIEW_TAG {
            
            timelineSession = self.eventTimeline.timelineSessions.objectAtIndex(0) as! TimelineSession
            
        }
        else {
            
            timelineSession = self.eventTimeline.timelineSessions.objectAtIndex(1) as! TimelineSession
            
        }
        
        let sessionsInTimelineSession = timelineSession.sessionsCollection
        
        let currentSession = sessionsInTimelineSession!.objectAtIndex(indexPath.row) as! Session
        
        cell?.textLabel?.text = currentSession.sessionName
        cell?.textLabel?.font = cell?.textLabel?.font.fontWithSize(14)
        cell?.textLabel?.textColor = UIColor.darkGrayColor()
        
        
        cell?.detailTextLabel?.text = currentSession.sessionStartTime
        cell?.detailTextLabel?.textColor = UIColor.lightGrayColor()
        
        return cell!
    }
    
    //MARK: - private methods -
    private func configureSubviewsContent() {
        
        self.title.text = self.eventTimeline.header.titleText
        self.introductionText.text = self.eventTimeline.header.introductionText
        
        let timelineSessions = self.eventTimeline.timelineSessions
        
        for var nIndex = 0; nIndex < timelineSessions.count; nIndex++ {
            
            let timelineSession = timelineSessions.objectAtIndex(nIndex) as! TimelineSession
            
            switch(nIndex) {
                
            case 0:
                self.firstSessionsTitle.text = timelineSession.sessionsName
                self.firstSessionsDetail.text = timelineSession.sessionsDetail
                break
                
            case 1:
                self.secondSessionsTitle.text = timelineSession.sessionsName
                self.secondSessionsDetail.text = timelineSession.sessionsDetail
                break
                
            case 2:
                self.thirdSessionsTitle.text = timelineSession.sessionsName
                self.thirdSessionsDetail.text = timelineSession.sessionsDetail
                break
                
            default:
                break
            }
        }
    }
    
}
