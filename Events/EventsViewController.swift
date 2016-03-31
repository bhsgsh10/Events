//
//  ViewController.swift
//  Events
//
//  Created by Bhaskar Ghosh on 17/03/16.
//  Copyright © 2016 Bhaskar Ghosh. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Constants -
    let TABLE_CELL_HEIGHT: CGFloat = 300
    let eventsJsonFile = "discovery_event_list"
    let navigationBarTitle = "Events"
    
    let eventsListUrl = "https://api-diy-in.bookmyshow.com/api/v1/aggregate/eventmetapublishlist"
    
    //PRAGMAMARK: - properties declaration -
    
    var eventsTableView : UITableView!
    var eventsCollection : NSArray!
    var imageCache : NSCache!
    var eventsList : NSArray?
    
    var eventsListJson: NSArray!
    
    //PRAGMAMARK: - view life cycle methods -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setPropertiesToNavigationBar()
        
        self.imageCache = NSCache()
        
//        self.eventsCollection = EventsUtility.parseJsonFromFile(self.eventsJsonFile) as! NSArray
        
//        self.eventsCollection = self.parseJsonFromUrl(url: self.eventsListUrl)
        
        self.eventsList = self.getEventsListFromJson()

        self.addEventsTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        
        if (self.eventsTableView != nil) {
            
            self.eventsTableView.frame = self.getEventsTableViewFrame()
        }
        
    }


    //PRAGMAMARK: - table view data source methods -
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let nCount: NSInteger
        
        if let list = self.eventsList {
            
            nCount = list.count
        }
        else {
            
            nCount = 0
        }
        
        return nCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cellIdentifier"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)

        if (cell == nil) {
            
            let nibCollection = NSBundle.mainBundle().loadNibNamed(eventsTableViewCellXibName,
                                                                    owner: nil,
                                                                    options: nil)
            
            cell = (nibCollection as NSArray).objectAtIndex(0) as? EventsTableViewCell
        }
        
        //set visual properties of the cell
        cell?.backgroundColor = self.getBackgroundColorForTableViewCell()
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        
        let eventCell = cell as! EventsTableViewCell

        if let events = self.eventsList {
            
            let event = events.objectAtIndex(indexPath.row) as! Event
            
            //read image from documents directory. if image is not found, then download it.
            let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
            let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
            let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) as NSArray
            
            if paths.count > 0 {
                
                let dirPath = paths.objectAtIndex(0)
                
                let imagePath = dirPath.stringByAppendingPathComponent(event.name)
                
                if let image = UIImage(named: imagePath) {
                    
                    eventCell.eventImageView.contentMode = .ScaleToFill
                    eventCell.eventImageView.image = image
                }
                else {
                    
                    let imgPath = event.name + ".png"
                    
                    eventCell.alpha = 0.5
                    
                    self.loadImageInCell(cell: eventCell, forRow: indexPath.row, url: event.imageUrl, path: imgPath)
                }
                
            }
            
            eventCell.eventNameLabel.text = event.name
            eventCell.eventLocationLabel.text = event.location
            eventCell.eventStatusLabel.text = event.statusText
            eventCell.eventDateRangeLabel.text = event.dateRangeText
            
            self.setStatusBasedPropertiesToCellSubviews(cell: eventCell)

        }
        
        return eventCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return TABLE_CELL_HEIGHT
    }
    
    //PRAGMAMARK: - table view delegate methods -
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let event = self.eventsList!.objectAtIndex(indexPath.row) as! Event
        
        if event.name == beachLadyEvent {
            
            let clearWaterBeachViewController = ClearWaterBeachViewController(nibName: clearwaterBeachEventXibName, bundle: nil)
            
            clearWaterBeachViewController.clearWaterBeachEvent = event
            
            self.navigationController?.pushViewController(clearWaterBeachViewController, animated: true)
        }
    }
    
    //PRAGMAMARK: - private methods -
    private func addEventsTableView() {
        
        self.eventsTableView = UITableView(frame: CGRectZero,
            style: UITableViewStyle.Plain)
        
        self.eventsTableView.delegate = self
        self.eventsTableView.dataSource = self
        
        self.eventsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.view.addSubview(self.eventsTableView)
    }
    
    private func getBackgroundColorForTableViewCell() -> UIColor {
        
        return UIColor.init(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
    }
    
    
    private func setPropertiesToNavigationBar() {
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.translucent = false
        
        self.navigationController?.navigationBar.barTintColor = EventsUtility.getNavigationBarTintColor()
        
        self.navigationItem.title = navigationBarTitle
    }
    
    private func getEventsTableViewFrame()->CGRect {
        
        return self.view.bounds
    }
    
    private func setStatusBasedPropertiesToCellSubviews(cell cell: EventsTableViewCell) {
        
        //if the event has expired, then status label's background should be red. Also the buy tickets button should be disabled
        if cell.eventStatusLabel.text == eventStatusLabelExpiredText {
            
            cell.eventStatusLabel.backgroundColor = UIColor.redColor()
            cell.eventTicketsButton.enabled = false
            cell.eventTicketsButton.alpha = 0.7
        }
        else {
            
            cell.eventStatusLabel.backgroundColor = UIColor.init(red: 34/255, green: 146/255, blue: 114/255, alpha: 1)
            cell.eventTicketsButton.enabled = true
            cell.eventTicketsButton.alpha = 1
        }
    }
    
    
}

