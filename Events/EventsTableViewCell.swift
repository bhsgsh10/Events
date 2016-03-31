//
//  EventsTableViewCell.swift
//  Events
//
//  Created by Bhaskar Ghosh on 17/03/16.
//  Copyright © 2016 Bhaskar Ghosh. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    
    //MARK: - properties declaration -
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventStatusLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDateRangeLabel: UILabel!
    @IBOutlet weak var eventTicketsButton: UIButton!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.commonInit()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Private methods -
    private func commonInit() {
        
        self.setVisualPropertiesOfEventStatusLabel()
        self.setVisualPropertiesOfDateRangeLabel()
        self.setVisualPropertiesOfEventNameLabel()
        self.setVisualPropertiesOfEventLocationLabel()
        self.setVisualPropertiesOfBuyTicketsButton()
        
        self.imageLoadingIndicator.hidesWhenStopped = true
        
        self.eventImageView.contentMode = .ScaleToFill
    }
    
    private func setVisualPropertiesOfEventStatusLabel() {
        
        if let statusLabel = self.eventStatusLabel {
            
            statusLabel.backgroundColor = UIColor.init(red: 34/255, green: 146/255, blue: 114/255, alpha: 1)
            statusLabel.textColor = UIColor.whiteColor()
            statusLabel.layer.cornerRadius = 5
            statusLabel.clipsToBounds = true
        }
    }
    
    private func setVisualPropertiesOfDateRangeLabel() {
        
        if let dateLabel = self.eventDateRangeLabel {
            
            dateLabel.backgroundColor = UIColor.blackColor()
            dateLabel.textColor = UIColor.whiteColor()
            dateLabel.layer.cornerRadius = 5
            dateLabel.clipsToBounds = true
        }
    }
    
    private func setVisualPropertiesOfEventNameLabel() {
        
        if let nameLabel = self.eventNameLabel {
            
            nameLabel.textColor = self.getTextColorForNameAndLocationLabels()
        }
    }
    
    private func setVisualPropertiesOfEventLocationLabel() {
        
        if let locationLabel = self.eventLocationLabel {
            
            locationLabel.textColor = self.getTextColorForNameAndLocationLabels()
        }
    }
    
    private func setVisualPropertiesOfBuyTicketsButton() {
        
        if let ticketButton = self.eventTicketsButton {
            
            ticketButton.layer.cornerRadius = 5
            ticketButton.clipsToBounds = true
        }
    }
    
    private func getTextColorForNameAndLocationLabels() -> UIColor {
        
        return UIColor.darkGrayColor()
    }

}
