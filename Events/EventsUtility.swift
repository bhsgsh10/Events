//
//  EventsUtility.swift
//  Events
//
//  Created by Bhaskar Ghosh on 20/03/16.
//  Copyright © 2016 Bhaskar Ghosh. All rights reserved.
//

//Methods required by mutiple classes are defined here.

import UIKit

class EventsUtility: NSObject {
    
    
    
    //this function detects date given in the string and returns the result as NSDate. This method can be utilised if the date format is not known
    class func getDateFromString(dateString dateStr : String)->NSDate {
        
        var detectedDate : NSDate?
        
        let detector = try! NSDataDetector(types: NSTextCheckingType.Date.rawValue)
        
        detector.enumerateMatchesInString(dateStr, options: [], range: NSMakeRange(0, dateStr.characters.count), usingBlock:{
            (textCheckingResult, matchingFlags, stop) in
            
            detectedDate = textCheckingResult!.date
        })
        
        return detectedDate!
    }
    
    //this method parses the JSON from the given file name and returns the entity corresponding to the data key
    //It is the responsibility of the caller to cast the result into appropriate type
    class func parseJsonFromFile(jsonFilePath: String) -> AnyObject {
        
        let path: NSString? = NSBundle.mainBundle().pathForResource(jsonFilePath, ofType: "json")!
        
        let data : NSData = try! NSData(contentsOfFile: path as! String, options: NSDataReadingOptions.DataReadingMapped)
        let dict: NSDictionary!=(try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
        
        return dict.valueForKey(jsonDataKey)!
    }
    
    class func parseJsonFromUrl(url url: String) -> AnyObject {
        
        let JSONData: NSData = NSData(contentsOfURL: NSURL(string: url)!)!
        
        let dict: NSDictionary! = (try! NSJSONSerialization.JSONObjectWithData(JSONData, options: .AllowFragments)) as! NSDictionary
        
        return dict.valueForKey(jsonDataKey)!
    }

    //this function returns the navigation tint color used throughout the application
    class func getNavigationBarTintColor() -> UIColor {
        
        let backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
        
        return backgroundColor
    }
    
}
