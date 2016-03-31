//
//  EventSpeakerView.swift
//  Events
//
//  Created by Bhaskar Ghosh on 24/03/16.
//  Copyright © 2016 Bhaskar Ghosh. All rights reserved.
//

import UIKit

class EventSpeakerView: UIView {

    //MARK: - IBOutlets -
    @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet weak var introductionText: UITextView!
    
    @IBOutlet weak var firstSubHeader: UILabel!
    @IBOutlet weak var firstSubHeaderDetail: UITextView!
    @IBOutlet weak var firstSpeakerImageView: UIImageView!
    @IBOutlet weak var firstImageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var firstSpeakerName: UILabel!
    @IBOutlet weak var firstSpeakerDesignation: UILabel!
    @IBOutlet weak var firstSpeakerDetail: UITextView!
    
    @IBOutlet weak var secondSubHeader: UILabel!
    @IBOutlet weak var secondSubHeaderDetail: UITextView!
    @IBOutlet weak var secondSpeakerImageView: UIImageView!
    @IBOutlet weak var secondImageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var secondSpeakerName: UILabel!
    @IBOutlet weak var secondSpeakerDesignation: UILabel!
    @IBOutlet weak var secondSpeakerDetail: UITextView!
    @IBOutlet weak var thirdSpeakerImageView: UIImageView!
    @IBOutlet weak var thirdImageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var thirdSpeakerName: UILabel!
    @IBOutlet weak var thirdSpeakerDesignation: UILabel!
    @IBOutlet weak var thirdSpeakerDetail: UITextView!

    @IBOutlet weak var thirdSubHeader: UILabel!
    @IBOutlet weak var thirdSubHeaderDetail: UITextView!
    @IBOutlet weak var fourthSpeakerImageView: UIImageView!
    @IBOutlet weak var fourthImageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var fourthSpeakerName: UILabel!

    @IBOutlet weak var fourthSpeakerDesignation: UILabel!
    @IBOutlet weak var fourthSpeakerDetail: UILabel!

    var keySpeakers: EventKeySpeakers!
    var isFirstTime: Bool = true
    
    //MARK: - UIView overridden methods -
    override func layoutSubviews() {
        
        if self.isFirstTime == true {
            
            self.setDefaultValuesToLabels()
            self.configureSubviewsContent()
            
            self.isFirstTime = false
        }
        
        //this ensures that the content in the text views is always scrolled to the top.
        self.firstSpeakerDetail.scrollRangeToVisible(NSMakeRange(0, 0))
        self.secondSpeakerDetail.scrollRangeToVisible(NSMakeRange(0, 0))
        self.thirdSpeakerDetail.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    //MARK: - private methods -
    private func setDefaultValuesToLabels() {
        
        self.firstSubHeader.text = ""
        self.secondSubHeader.text = ""
        self.thirdSubHeader.text = ""
        self.firstSpeakerName.text = ""
        self.firstSpeakerDesignation.text = ""
        self.secondSpeakerName.text = ""
        self.secondSpeakerDesignation.text = ""
        self.thirdSpeakerName.text = ""
        self.thirdSpeakerDesignation.text = ""
        self.fourthSpeakerName.text = ""
        self.fourthSpeakerDesignation.text = ""
        self.fourthSpeakerDetail.text = ""
    }
    
    
    private func configureSubviewsContent() {
        
        self.titleHeader.text = self.keySpeakers.header.titleText
        self.introductionText.text = self.keySpeakers.header.introductionText
        
        let departments = self.keySpeakers.departments
        
        for var nIndex = 0; nIndex < departments.count; nIndex++ {
            
            let department = departments.objectAtIndex(nIndex) as! EventSegmentSubHeader
            
            switch(nIndex) {
                
            case 0:
                self.firstSubHeader.text = department.subHeaderTitle
                self.firstSubHeaderDetail.text = department.subHeaderDetail
                break
                
            case 1:
                self.secondSubHeader.text = department.subHeaderTitle
                self.secondSubHeaderDetail.text = department.subHeaderDetail
                break
                
            case 2:
                self.thirdSubHeader.text = department.subHeaderTitle
                self.thirdSubHeaderDetail.text = department.subHeaderDetail
                break
                
            default:
                break
            }
            
        }
        
        let persons = self.keySpeakers.persons
        
        for var nIndex = 0; nIndex < persons.count; nIndex++ {
            
            let person = persons.objectAtIndex(nIndex) as! Person
            
            switch(nIndex) {
                
            case 0:
                self.firstSpeakerName.text = person.personName
                self.firstSpeakerDesignation.text = person.personDesignation
                self.firstSpeakerDetail.text = person.personDetail
                
                self.loadImageForPerson(person: person, imageView: self.firstSpeakerImageView, loadingIndicator: self.firstImageLoadingIndicator)
                
                break
                
            case 1:
                self.secondSpeakerName.text = person.personName
                self.secondSpeakerDesignation.text = person.personDesignation
                self.secondSpeakerDetail.text = person.personDetail
                
                self.loadImageForPerson(person: person, imageView: self.secondSpeakerImageView, loadingIndicator: self.secondImageLoadingIndicator)

                break
                
            case 2:
                self.thirdSpeakerName.text = person.personName
                self.thirdSpeakerDesignation.text = person.personDesignation
                self.thirdSpeakerDetail.text = person.personDetail
                
                self.loadImageForPerson(person: person, imageView: self.thirdSpeakerImageView, loadingIndicator: self.thirdImageLoadingIndicator)

                break
                
            case 3:
                self.fourthSpeakerName.text = person.personName
                self.fourthSpeakerDesignation.text = person.personDesignation
                self.fourthSpeakerDetail.text = person.personDetail
                
                self.loadImageForPerson(person: person, imageView: self.fourthSpeakerImageView, loadingIndicator: self.fourthImageLoadingIndicator)

                break
                
            default:
                break
            }
            
        }
        
    }
    
    private func loadImageForPerson(person person: Person, imageView: UIImageView, loadingIndicator: UIActivityIndicatorView) {
        
        //set image in image view if it exists in documents directory. otherwise download it
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) as NSArray
        
        if paths.count > 0 {
            
            let dirPath = paths.objectAtIndex(0)
            
            let imagePath = dirPath.stringByAppendingPathComponent(person.personName)
            
            if let image = UIImage(named: imagePath) {
                
                imageView.contentMode = .ScaleToFill
                imageView.image = image
            }
            else {
                
                if person.personImageUrl != "" {
                    
                    loadingIndicator.hidden = false
                    loadingIndicator.startAnimating()
                    imageView.alpha = 0.5
                    
                    self.downloadAndSetImageForPerson(person: person, imageView: imageView, imageLoadingIndicator: loadingIndicator)
                }
                
                
            }
            
        }

    }
    
    
    private func downloadAndSetImageForPerson(person person: Person, imageView: UIImageView, imageLoadingIndicator: UIActivityIndicatorView) {
        
        
        let queue = NSOperationQueue()
        
        let imageDownloadOperation = NSBlockOperation(block: {
            
            if let eventImage = ImageDownloader.downloadImageWithURL(person.personImageUrl) {
                
                let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
                
                let documentsDirectory = paths.objectAtIndex(0)
                
                let imagePath = documentsDirectory.stringByAppendingPathComponent(person.personName)
                
                person.personImageFilePath = imagePath
                
                let imageData = UIImagePNGRepresentation(eventImage)
                imageData?.writeToFile(imagePath, atomically: false)
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    
                    imageLoadingIndicator.stopAnimating()
                    imageView.alpha = 1
                    imageView.image = eventImage
                })
            }
            
        })
        
        queue.addOperation(imageDownloadOperation)

    }
}
