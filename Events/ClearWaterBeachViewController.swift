//
//  ClearWaterBeachViewController.swift
//  Events
//
//  Created by Bhaskar Ghosh on 20/03/16.
//  Copyright © 2016 Bhaskar Ghosh. All rights reserved.
//

import UIKit

class ClearWaterBeachViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Constants
    let clearWaterBeachJsonFile = "event_data_collated"
    let clearWaterBeachJsonurl = "https://api-diy-in.bookmyshow.com/api/v1/events/beach/meta/microsite"
    
    let SPEAKER_SEGMENT = 0
    let TIMELINE_SEGMENT = 1
    let SPONSORS_SEGMENT = 2
    let DESCRIPTIONS_SEGMENT = 3
    
    //MARK: - properties declaration -
    var eventJsonDictionary: NSDictionary!
    var clearWaterBeachEvent: Event!
    
    @IBOutlet weak var clearWaterImageView: UIImageView!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var openMap: UIButton!
    @IBOutlet weak var optionSelector: UISegmentedControl!
    @IBOutlet weak var purchaseTicketButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var eventDescriptionsView: EventDescriptionsView!
    var eventSponsorsView: EventSponsorsView!
    var eventSpeakerView: EventSpeakerView!
    var eventTimelineView: EventTimelineView!
    
    //MARK: - View life cycle methods -
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.clearWaterBeachEvent.name
        
//        self.eventJsonDictionary = EventsUtility.parseJsonFromFile(self.clearWaterBeachJsonFile) as! NSDictionary
        
        self.eventJsonDictionary = EventsUtility.parseJsonFromUrl(url: clearWaterBeachJsonurl) as! NSDictionary
        
        self.setInfoToSubviews()
        
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //load the Speakers view in the container view by default. Later when user changes selection, other views will load
        self.loadSpeakerView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
    }
    
    //MARK: - IBAction methods -
    
    @IBAction func showMap(sender: AnyObject) {
        
        //read latitude and longitude from the JSON and launch the map view controller
        let locationDict = self.eventJsonDictionary.objectForKey(jsonLocationKey) as! NSDictionary
        let geoJsonDict = locationDict.objectForKey(jsonGeoJsonKey) as! NSDictionary
        let coordinates = geoJsonDict.objectForKey(jsonCoordinatesKey) as! NSArray
        
        let mapViewController = EventMapViewController(nibName: eventMapViewControllerXibName, bundle: nil)
        
        let longitude = coordinates.objectAtIndex(0).doubleValue
        let latitude = coordinates.objectAtIndex(1).doubleValue
        
        mapViewController.longitude = longitude
        mapViewController.latitude = latitude
        
        //add locality and event name for annotation purposes
        let locality = locationDict.valueForKey(jsonLocalityKey) as! String
        mapViewController.eventLocality = locality
        
        let eventName = self.clearWaterBeachEvent.name
        mapViewController.eventName = eventName
        
        //wrap the mapViewController into a navigation controller
        let mapViewNavigationController = UINavigationController(rootViewController: mapViewController)
        
        //present the mapViewnavigationController modally
        self.presentViewController(mapViewNavigationController, animated: true, completion: nil)
        
    }
    
    @IBAction func onSegmentChange(sender: AnyObject) {
        
        self.loadViewAsPerSegment(selectedIndex: self.optionSelector.selectedSegmentIndex)
    }
    
    
    //MARK: - private methods -
    
    private func setInfoToSubviews() {
        
        self.setImageInImageView()
        self.setVisualPropertiesOfBuyTicketsButton()
        
        self.startDateLabel.text = self.getStartDateText()
        self.startDateLabel.textColor = UIColor.darkGrayColor()
        
        self.locationLabel.text = self.getLocationText()
        self.locationLabel.textColor = UIColor.darkGrayColor()
        
        self.setPropertiesToOpenMapButton()
        
    }
    
    private func setImageInImageView() {
        
        //read image from documents directory that holds the image.
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) as NSArray
        
        if paths.count > 0 {
            
            let dirPath = paths.objectAtIndex(0)
            
            let imagePath = dirPath.stringByAppendingPathComponent(self.clearWaterBeachEvent.name)
            
            if let image = UIImage(named: imagePath) {
                
                self.clearWaterImageView.image = image
            }
            
        }
    }
    
    private func setVisualPropertiesOfBuyTicketsButton() {
        
        if let ticketButton = self.purchaseTicketButton {
            
            ticketButton.layer.cornerRadius = 5
            ticketButton.clipsToBounds = true
        }
    }
    
    private func getStartDateText() -> String {
        
        //get start date from the json dictionary
        let startDateText = self.eventJsonDictionary.valueForKey(jsonStartDateKey) as! String
        
        let startDate = EventsUtility.getDateFromString(dateString: startDateText)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE dd, YYYY HH:mm aa"
        
        let displayDateText = dateFormatter.stringFromDate(startDate)
        
        return displayDateText
    }
    
    private func getLocationText() -> String {
        
        //get location text from the JSON dictionary
        let eventLocationDict = self.eventJsonDictionary.objectForKey(jsonLocationKey) as! NSDictionary
        let eventAddress = eventLocationDict.valueForKey(jsonFullAddressKey) as! String
        
        return eventAddress
    }
    
    private func setPropertiesToOpenMapButton() {
        
        self.openMap.layer.cornerRadius = (self.openMap.frame.size.height/2);
        self.openMap.layer.borderWidth = 1;
        self.openMap.layer.borderColor = self.view.tintColor.CGColor;
    }
    
    private func setFramesToSubviews() {
        
        let containerViewBounds = self.containerView.bounds
        
        if let descriptionsView = self.eventDescriptionsView {
            
            descriptionsView.frame = containerViewBounds
        }
        
        if let sponsorsView = self.eventSponsorsView {
            
            sponsorsView.frame = containerViewBounds
        }
        
    }
    
    private func loadViewAsPerSegment(selectedIndex index: NSInteger) {
        
        self.hideOtherSubviewsInContainerView()
        
        switch(index) {
            
        case SPEAKER_SEGMENT:
            //load speaker view
            self.loadSpeakerView()
            break
            
        case TIMELINE_SEGMENT:
            //load timeline view
            self.loadTimelineView()
            break
            
        case SPONSORS_SEGMENT:
            //load sponsors view
            self.loadSponsorsView()
            break
            
        case DESCRIPTIONS_SEGMENT:
            //load descriptions view
            self.loadDescriptionsView()
            break
            
        default:
            self.loadSpeakerView()
            break

        }
    }
    
    
    private func hideOtherSubviewsInContainerView() {
        
        if let speakerView = self.eventSpeakerView {
            
            speakerView.hidden = true
        }
        
        if let descriptionsView = self.eventDescriptionsView {
            
            descriptionsView.hidden = true
        }
        
        if let sponsorsView = self.eventSponsorsView {
            
            sponsorsView.hidden = true
        }
        
        if let timelineView = self.eventTimelineView {
            
            timelineView.hidden = true
        }
        
    }

}
