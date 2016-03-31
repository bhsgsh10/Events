//
//  ClearWaterBeachViewController+DataStructureCreations.swift
//  Events
//
//  Created by Bhaskar Ghosh on 31/03/16.
//  Copyright © 2016 Bhaskar Ghosh. All rights reserved.
//

import Foundation
import UIKit

extension ClearWaterBeachViewController {
    
    func getDescriptionsFromJsonDictionary(jsonDict dict: NSDictionary) -> EventDescriptions {
        
        //get required information from the JSON dictionary
        let sectionsDict = dict.objectForKey(jsonSectionsKey) as! NSDictionary
        let descriptionDict = dict.objectForKey("description") as! NSDictionary
        
        //get the key corresponing to the Descriptions title in the JSON
        let descriptionKey = self.getEntityKeyForDictionary(entityDictionary: sectionsDict, titleValue: descriptionsKey)
        
        //get the dictionary for the key received in the previous step
        let descriptionsDict = sectionsDict.objectForKey(descriptionKey) as! NSDictionary
        
        
        let descriptions = EventDescriptions.init()
        
        descriptions.header.titleText = descriptionsDict.valueForKey(jsonTitleKey) as! String
        descriptions.header.introductionText = descriptionsDict.valueForKey(jsonDescriptionKey) as! String
        
        let sectionData = descriptionsDict.objectForKey(jsonSectionDataKey) as! NSArray
        
        let subHeaders = NSMutableArray()
        
        for var nIndex = 0; nIndex < sectionData.count; nIndex++ {
            
            let sectionDict = sectionData.objectAtIndex(nIndex) as! NSDictionary
            
            let dataId = sectionDict.objectForKey(jsonDataIdKey) as! String
            
            descriptions.sectionIds.addObject(dataId)
            
            //let dataIdDict = sectionDict.objectForKey(jsonDataIdKey) as! NSDictionary
            
            let value = sectionDict.valueForKey(jsonDataTypeKey) as! String
            
            if  value == dataTypeDescription {
                
                let subHeader = EventSegmentSubHeader()
                
                subHeader.subHeaderTitle = self.getTextForSubHeaderTitle(dataIdKey: dataId, descriptionDict: descriptionDict)
                subHeader.subHeaderDetail = self.getTextForSubHeaderDetail(dataIdKey: dataId, descriptionDict: descriptionDict)
                
                subHeaders.addObject(subHeader)
            }
            
        }
        
        descriptions.subHeaders = subHeaders
        
        return descriptions
    }
    
    
    func getKeySpeakersFromJsonDictionary(jsonDict dict: NSDictionary) -> EventKeySpeakers {
        
        //get required information from the JSON dictionary
        let sectionsDict = dict.objectForKey(jsonSectionsKey) as! NSDictionary
        let descriptionDict = dict.objectForKey("description") as! NSDictionary
        let personDict = dict.objectForKey("person") as! NSDictionary
        
        //get the key corresponing to the Descriptions title in the JSON
        let descriptionKey = self.getEntityKeyForDictionary(entityDictionary: sectionsDict, titleValue: keySpeakersKey)
        
        //get the dictionary for the key received in the previous step
        let descriptionsDict = sectionsDict.objectForKey(descriptionKey) as! NSDictionary
        
        
        let keySpeakers = EventKeySpeakers.init()
        
        keySpeakers.header.titleText = descriptionsDict.valueForKey(jsonTitleKey) as! String
        keySpeakers.header.introductionText = descriptionsDict.valueForKey(jsonDescriptionKey) as! String
        
        let sectionData = descriptionsDict.objectForKey(jsonSectionDataKey) as! NSArray
        
        let departments = NSMutableArray()
        let persons = NSMutableArray()
        
        for var nIndex = 0; nIndex < sectionData.count; nIndex++ {
            
            let sectionDict = sectionData.objectAtIndex(nIndex) as! NSDictionary
            
            let dataId = sectionDict.valueForKey(jsonDataIdKey) as! String
            
            let value = sectionDict.valueForKey(jsonDataTypeKey) as! String
            
            if  value == dataTypeDescription {
                
                let department = EventSegmentSubHeader()
                
                department.subHeaderTitle = self.getTextForSubHeaderTitle(dataIdKey: dataId, descriptionDict: descriptionDict)
                
                department.subHeaderDetail = self.getTextForSubHeaderDetail(dataIdKey: dataId, descriptionDict: descriptionDict)
                
                departments.addObject(department)
            }
            else if value == dataTypePerson {
                
                let firstName = self.getPersonFirstName(dataIdKey: dataId, personDict: personDict)
                let lastName = self.getPersonLastName(dataIdKey: dataId, personDict: personDict)
                
                let title = self.getPersonTitle(dataIdKey: dataId, personDict: personDict)
                
                let organization = self.getPersonOrganization(dataIdKey: dataId, personDict: personDict)
                
                let person = Person()
                person.personName = firstName + " " + lastName
                person.personDesignation = title + ", " + organization
                
                person.personDetail = self.getPersonDetail(dataIdKey: dataId, personDict: personDict)
                
                var imgUrl = self.getPersonImageUrl(dataIdKey: dataId, personDict: personDict)
                
                imgUrl = imgUrl.stringByReplacingOccurrencesOfString("=>", withString: ":")
                
                person.personImageUrl = imgUrl
                
                persons.addObject(person)
            }
        }
        
        keySpeakers.departments = departments
        keySpeakers.persons = persons
        
        return keySpeakers
    }
    
    func getTimelineFromJsonDictionary(jsonDict dict: NSDictionary) -> EventTimeline {
        
        //get required information from the JSON dictionary
        let sectionsDict = dict.objectForKey(jsonSectionsKey) as! NSDictionary
        let descriptionDict = dict.objectForKey(jsonDescriptionKey) as! NSDictionary
        let timelineSessionDict = dict.objectForKey(jsonSessionKey) as! NSDictionary
        
        //get the key corresponing to the Descriptions title in the JSON
        let descriptionKey = self.getEntityKeyForDictionary(entityDictionary: sectionsDict, titleValue: timeline1Key)
        
        //get the dictionary for the key received in the previous step
        let descriptionsDict = sectionsDict.objectForKey(descriptionKey) as! NSDictionary
        
        let timeline = EventTimeline()
        
        timeline.header.titleText = descriptionsDict.valueForKey(jsonTitleKey) as! String
        timeline.header.introductionText = descriptionsDict.valueForKey(jsonDescriptionKey) as! String
        
        let sectionData = descriptionsDict.objectForKey(jsonSectionDataKey) as! NSArray
        
        let allTimelineSessions = NSMutableArray()
        
        //The timelineSession vaiable corresponds to the 'Morning Sessions', 'Second half session'  etc header
        var timelineSession = TimelineSession.init()
        
        for var nIndex = 0; nIndex < sectionData.count; nIndex++ {
            
            let sectionDict = sectionData.objectAtIndex(nIndex) as! NSDictionary
            //let dataIdDict = sectionDict.objectForKey(jsonDataIdKey) as! NSDictionary
            
            let dataId = sectionDict.valueForKey(jsonDataIdKey) as! String
            
            let value = sectionDict.valueForKey(jsonDataTypeKey) as! String
            
            if value == dataTypeDescription {
                
                //if nIndex is 0 then it means timelineSession has no data yet. Hence we won't be adding it to the array yet.
                if nIndex != 0 {
                    
                    allTimelineSessions.addObject(timelineSession)
                }
                
                let tempTimelineSession = TimelineSession.init()
                
                tempTimelineSession.sessionsName = self.getTextForSubHeaderTitle(dataIdKey: dataId, descriptionDict: descriptionDict)
                
                tempTimelineSession.sessionsDetail = self.getTextForSubHeaderDetail(dataIdKey: dataId, descriptionDict: descriptionDict)
                
                timelineSession = tempTimelineSession
                
                //if the following condition is satisfied then it means we have reached the end of the array and there are no other keys to parse. Hence we add the timelineSession to the array
                if (nIndex == sectionData.count - 1) {
                    
                    allTimelineSessions.addObject(timelineSession)
                }
                
            }
                
            else if value == dataTypeSession {
                
                let session = Session()
                
                session.sessionName = self.getSessionName(dataIdKey: dataId, sessionDict: timelineSessionDict)
                
                var startTimeFromJson = self.getStartTimeForSession(dataIdKey: dataId, sessionDict: timelineSessionDict)
                
                startTimeFromJson = startTimeFromJson.stringByReplacingOccurrencesOfString("=>", withString: ":")
                
                let startDate = EventsUtility.getDateFromString(dateString: startTimeFromJson)
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "HH:mm aa"
                dateFormatter.timeZone = NSTimeZone(name: "IN")
                
                session.sessionStartTime = dateFormatter.stringFromDate(startDate)
                
                //We add the session that are part of the 'Morning session', 'Second half session' etc
                timelineSession.addSessionToSessionsCollection(session)
            }
        }
        
        timeline.timelineSessions = allTimelineSessions
        
        return timeline
        
    }
    
    func getSponsorsListFromJsonDictionary(jsonDict dict: NSDictionary) -> EventSponsors {
        
        //get required information from the JSON dictionary
        let sectionsDict = dict.objectForKey(jsonSectionsKey) as! NSDictionary
        let descriptionDict = dict.objectForKey(jsonDescriptionKey) as! NSDictionary
        let companyDict = dict.objectForKey(jsonCompanyKey) as! NSDictionary
        
        //get the key corresponing to the Descriptions title in the JSON
        let descriptionKey = self.getEntityKeyForDictionary(entityDictionary: sectionsDict, titleValue: sponsorsKey)
        
        //get the dictionary for the key received in the previous step
        let descriptionsDict = sectionsDict.objectForKey(descriptionKey) as! NSDictionary
        
        
        let sponsors = EventSponsors()
        
        sponsors.header.titleText = descriptionsDict.valueForKey(jsonTitleKey) as! String
        sponsors.header.introductionText = descriptionsDict.valueForKey(jsonDescriptionKey) as! String
        
        let sectionData = descriptionsDict.objectForKey(jsonSectionDataKey) as! NSArray
        
        let teams = NSMutableArray()
        let companies = NSMutableArray()
        
        for var nIndex = 0; nIndex < sectionData.count; nIndex++ {
            
            let sectionDict = sectionData.objectAtIndex(nIndex) as! NSDictionary
            
            let dataId = sectionDict.valueForKey(jsonDataIdKey) as! String
            
            let value = sectionDict.valueForKey(jsonDataTypeKey) as! String
            
            if  value == dataTypeDescription {
                
                let team = Team()
                
                team.teamName = self.getTextForSubHeaderTitle(dataIdKey: dataId, descriptionDict: descriptionDict)
                team.teamDetail = self.getTextForSubHeaderDetail(dataIdKey: dataId, descriptionDict: descriptionDict)
                
                
                teams.addObject(team)
            }
            else if value == dataTypeCompany {
                
                let title = self.getCompanyName(dataIdKey: dataId, companyDict: companyDict)
                let description = self.getCompanyDescription(dataIdKey: dataId, companyDict: companyDict)
                
                let company = Company()
                company.companyName = title
                company.companyDetail = description
                
                var imgUrl = self.getCompanyImageUrl(dataIdkey: dataId, companyDict: companyDict)
                
                imgUrl = imgUrl.stringByReplacingOccurrencesOfString("=>", withString: ":")
                
                company.companyImageUrl = imgUrl
                
                companies.addObject(company)
            }
            
        }
        
        sponsors.companies = companies
        sponsors.teams = teams
        
        return sponsors
    }
    
    func getCompanyName(dataIdKey key: String, companyDict: NSDictionary) -> String {
        
        let company = companyDict.objectForKey(key) as! NSDictionary
        
        let title = company.valueForKey(jsonTitleKey) as! String
        
        return title

    }
    
    func getCompanyDescription(dataIdKey key: String, companyDict: NSDictionary) -> String {
        
        let company = companyDict.objectForKey(key) as! NSDictionary
        
        let detail = company.valueForKey(jsonDescriptionKey) as! String
        
        return detail
    }
    
    func getCompanyImageUrl(dataIdkey key: String, companyDict: NSDictionary) -> String {
        
        let company = companyDict.objectForKey(key) as! NSDictionary
        
        let imageDict = company.objectForKey(jsonImageKey) as! NSDictionary
        
        let imageUrl = imageDict.valueForKey(jsonOriginalKey) as! String
        
        return imageUrl
        
    }
    
    
    func getTextForSubHeaderTitle(dataIdKey key: String, descriptionDict: NSDictionary) -> String {
        
        let description = descriptionDict.objectForKey(key) as! NSDictionary
        
        let title = description.valueForKey(jsonTitleKey) as! String
        
        return title
    }
    
    func getTextForSubHeaderDetail(dataIdKey key: String, descriptionDict: NSDictionary) -> String {
        
        let description = descriptionDict.objectForKey(key) as! NSDictionary
        
        let title = description.valueForKey(jsonDescriptionKey) as! String
        
        return title
        
    }
    
    func getPersonFirstName(dataIdKey key: String, personDict: NSDictionary) -> String {
        
        let person = personDict.objectForKey(key) as! NSDictionary
        
        let firstName = person.valueForKey(jsonFirstNameKey) as! String
        
        return firstName
    }
    
    func getPersonLastName(dataIdKey key: String, personDict: NSDictionary) -> String {
        
        let person = personDict.objectForKey(key) as! NSDictionary
        
        let lastName = person.valueForKey(jsonLastNameKey) as! String
        
        return lastName
    }
    
    func getPersonDetail(dataIdKey key: String, personDict: NSDictionary) -> String {
        
        let person = personDict.objectForKey(key) as! NSDictionary
        
        let lastName = person.valueForKey(jsonDescriptionKey) as! String
        
        return lastName
        
    }
    
    func getPersonImageUrl(dataIdKey key: String, personDict: NSDictionary) -> String {
        
        let person = personDict.objectForKey(key) as! NSDictionary
        
        let imageDict = person.objectForKey(jsonImageKey) as! NSDictionary
        
        let imageUrl = imageDict.valueForKey(jsonOriginalKey) as! String
        
        return imageUrl
    }
    
    
    func getPersonTitle(dataIdKey key: String, personDict: NSDictionary) -> String {
        
        let person = personDict.objectForKey(key) as! NSDictionary
        
        let title = person.valueForKey(jsonTitleKey) as! String
        
        return title
    }
    
    func getPersonOrganization(dataIdKey key: String, personDict: NSDictionary) -> String {
        
        let person = personDict.objectForKey(key) as! NSDictionary
        
        let org = person.valueForKey(jsonOrganizationKey) as! String
        
        return org
    }
    
    func getSessionName(dataIdKey key: String, sessionDict: NSDictionary) -> String {
        
        let session = sessionDict.objectForKey(key) as! NSDictionary
        
        let sessionName = session.valueForKey(jsonTitleKey) as! String
        
        return sessionName
    }
    
    func getStartTimeForSession(dataIdKey key: String, sessionDict: NSDictionary) -> String {
        
        let session = sessionDict.objectForKey(key) as! NSDictionary
        
        let startTime = session.valueForKey(jsonStartingAtKey) as! String
        
        return startTime
    }

}
