//
//  EventsViewController+PrivateMethods.swift
//  Events
//
//  Created by Bhaskar Ghosh on 27/03/16.
//  Copyright © 2016 Bhaskar Ghosh. All rights reserved.
//

import Foundation
import UIKit

extension EventsViewController {
    
    func getEventsListFromJson() -> NSArray {
        
        let eventsJsonArray = EventsUtility.parseJsonFromUrl(url: self.eventsListUrl) as! NSArray
        
        let eventsList = NSMutableArray()
        
        for eventDict in eventsJsonArray {
            
            let event = Event()
            
            event.name = self.getEventNameFromDictionary(eventDictionary: eventDict as! NSDictionary)
            event.location = self.getEventLocationFromDictionary(eventDictionary: eventDict as! NSDictionary)
            
            //get event start and end dates
            let startDateText = eventDict.valueForKey(jsonStartDateKey) as! String
            let startDate = EventsUtility.getDateFromString(dateString: startDateText)
            
            let endDateText = eventDict.valueForKey(jsonEndDateKey) as! String
            let endDate = EventsUtility.getDateFromString(dateString: endDateText)
            
            event.statusText = self.getEventStatusFromDictionary(eventDictionary: eventDict as! NSDictionary, date: startDate)
            
            event.dateRangeText = self.getDateRangeText(eventDictionary: eventDict as! NSDictionary, startingDate: startDate, endingDate: endDate)
            
            event.imageUrl = self.getImageUrlFromDictionary(eventDictionary: eventDict as! NSDictionary)
            
            eventsList.addObject(event)
        }
        
        return eventsList
    }
    
    func loadImageInCell(cell eventCell : EventsTableViewCell, forRow row : NSInteger, url: String, path: String!) {
        
        eventCell.imageLoadingIndicator.hidden = false
        eventCell.imageLoadingIndicator.startAnimating()
        
        self.downloadImageForIndex(index : row, cell : eventCell, url: url, path: path)
    }
    
    //MARK: - Private methods -
    
    private func getEventNameFromDictionary(eventDictionary dict : NSDictionary) -> String {
        
        let eventName = dict.valueForKey(jsonNameKey) as! String
        
        return eventName
    }

    
    private func getEventLocationFromDictionary(eventDictionary dict : NSDictionary) -> String {
        
        let eventLocationDict = dict.objectForKey(jsonLocationKey) as! NSDictionary
        let eventAddress = eventLocationDict.valueForKey(jsonFullAddressKey) as! String
        
        return eventAddress
    }
    
    private func getEventStatusFromDictionary(eventDictionary dict : NSDictionary, date : NSDate) -> String {
        
        let result = date.compare(NSDate())
        
        var statusText = ""
        
        if result == NSComparisonResult.OrderedAscending {
            
            statusText = eventStatusLabelExpiredText
            
        }
        else {
            
            let dateFormatterForWeekday = NSDateFormatter()
            dateFormatterForWeekday.dateFormat = "EEEE"
            
            let weekday = dateFormatterForWeekday.stringFromDate(date) as String
            
            statusText = weekday
            
        }
        
        return statusText
    }
    
    private func getDateRangeText(eventDictionary dict : NSDictionary, startingDate : NSDate, endingDate : NSDate) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM-dd-YYYY"
        
        let displayStartDateText = dateFormatter.stringFromDate(startingDate)
        
        let displayEndDateText = dateFormatter.stringFromDate(endingDate)
        
        let dateRange = displayStartDateText + " to " + displayEndDateText
        
        return dateRange
    }
    
    private func getImageUrlFromDictionary(eventDictionary dict: NSDictionary) -> String {
        
        let bannerDictionary = dict.objectForKey(jsonBannerKey) as! NSDictionary
        
        let urlAddress = bannerDictionary.valueForKey(jsonOriginalKey) as! String
        
        return urlAddress
    }
    
    private func downloadImageForIndex(index index : Int, cell : EventsTableViewCell, url: String, path: String) {
        
        let queue = NSOperationQueue()
        
        let imageDownloadOperation = NSBlockOperation(block: {
            
            if let eventImage = ImageDownloader.downloadImageWithURL(url) {
                
                let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
                
                let documentsDirectory = paths.objectAtIndex(0)
                let imagePath = documentsDirectory.stringByAppendingPathComponent(path)
                
                let imageData = UIImagePNGRepresentation(eventImage)
                imageData?.writeToFile(imagePath, atomically: false)
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    
                    cell.imageLoadingIndicator.stopAnimating()
                    cell.alpha = 1
                    cell.eventImageView?.image = eventImage
                })
            }
            
        })
        
        queue.addOperation(imageDownloadOperation)
        
    }

    
}
