//
//  EventSponsorsView.swift
//  Events
//
//  Created by Bhaskar Ghosh on 23/03/16.
//  Copyright © 2016 Bhaskar Ghosh. All rights reserved.
//

import UIKit

class EventSponsorsView: UIView {
    
    //MARK: - IBOutlets -
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var introductionText: UITextView!
    
    @IBOutlet weak var firstTeamName: UILabel!
    @IBOutlet weak var firstTeamDetail: UITextView!
    @IBOutlet weak var firstTeamImageView: UIImageView!
    @IBOutlet weak var firstTeamSubHeader: UILabel!
    @IBOutlet weak var firstTeamSubHeaderDetail: UITextView!
    
    @IBOutlet weak var secondTeamName: UILabel!
    @IBOutlet weak var secondTeamDetail: UITextView!
    @IBOutlet weak var secondTeamImageView: UIImageView!
    @IBOutlet weak var secondTeamSubHeader: UILabel!
    @IBOutlet weak var secondTeamSubHeaderDetail: UITextView!
    
    
    //MARK: - properties declaration -
    var eventSponsors: EventSponsors!
    var isFirstTime: Bool = true
    
    
    //MARK: - view layout methods -
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if self.isFirstTime == true {
            
            self.setDefaultValuesToLabels()
            self.configureSubviewsContent()
            self.isFirstTime = false
        }
        
        self.introductionText.scrollRangeToVisible(NSMakeRange(0, 0))
        
        
        self.firstTeamDetail.scrollRangeToVisible(NSMakeRange(0, 0))
        self.firstTeamSubHeaderDetail.scrollRangeToVisible(NSMakeRange(0, 0))
        self.secondTeamDetail.scrollRangeToVisible(NSMakeRange(0, 0))
        self.secondTeamSubHeaderDetail.scrollRangeToVisible(NSMakeRange(0, 0))
        
    }


    //MARK: - private methods -
    private func setDefaultValuesToLabels() {
        
        self.title.text = ""
        self.firstTeamName.text = ""
        self.secondTeamName.text = ""
    }
    
    private func configureSubviewsContent() {
        
        self.title.text = self.eventSponsors.header.titleText
        self.introductionText.text = self.eventSponsors.header.introductionText
        
        let teams = self.eventSponsors.teams
        
        for var nIndex = 0; nIndex < teams.count; nIndex++ {
            
            let team = teams.objectAtIndex(nIndex) as! Team
            
            switch(nIndex) {
                
            case 0:
                self.firstTeamName.text = team.teamName
                self.firstTeamDetail.text = team.teamDetail
                break
                
            case 1:
                self.secondTeamName.text = team.teamName
                self.secondTeamDetail.text = team.teamDetail
                break
                
            default:
                break
            }
        }
        
        let companies = self.eventSponsors.companies
        
        for var nIndex = 0; nIndex < companies.count; nIndex++ {
            
            let company = companies.objectAtIndex(nIndex) as! Company
            
            switch(nIndex) {
                
            case 0:
                self.firstTeamSubHeader.text = company.companyName
                self.firstTeamSubHeaderDetail.text = company.companyDetail
                //load image
                self.loadImageForCompany(company: company, imageView: self.firstTeamImageView)
                break
                
            case 1:
                self.secondTeamSubHeader.text = company.companyName
                self.secondTeamSubHeaderDetail.text = company.companyDetail
                //load image
                self.loadImageForCompany(company: company, imageView: self.secondTeamImageView)
                break
                
            default:
                break
            }
        }
        
    }
    
    private func loadImageForCompany(company company: Company, imageView: UIImageView) {
        
        //load image from documents directory if it exists, otherwise download it
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) as NSArray
        
        if paths.count > 0 {
            
            let dirPath = paths.objectAtIndex(0)
            
            let imagePath = dirPath.stringByAppendingPathComponent(company.companyName)
            
            if let image = UIImage(named: imagePath) {
                
                imageView.contentMode = .ScaleToFill
                imageView.image = image
            }
            else {
                
                //download and set image if image is not found
                self.downloadImageForCompany(company: company, imageView: imageView)
            }
            
        }
        
    }

    private func downloadImageForCompany(company company: Company, imageView: UIImageView) {
        
        let queue = NSOperationQueue()
        
        let imageDownloadOperation = NSBlockOperation(block: {
            
            if let eventImage = ImageDownloader.downloadImageWithURL(company.companyImageUrl) {
                
                let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
                
                let documentsDirectory = paths.objectAtIndex(0)
                
                let imagePath = documentsDirectory.stringByAppendingPathComponent(company.companyName)
                
                let imageData = UIImagePNGRepresentation(eventImage)
                imageData?.writeToFile(imagePath, atomically: false)
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    
                    imageView.image = eventImage
                })

            }
            
        })
        
        queue.addOperation(imageDownloadOperation)

    }

}
