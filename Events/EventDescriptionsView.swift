//
//  DescriptionsView.swift
//  Events
//
//  Created by Bhaskar Ghosh on 22/03/16.
//  Copyright © 2016 Bhaskar Ghosh. All rights reserved.
//

import UIKit

class EventDescriptionsView: UIView, UITextViewDelegate {

    
    //MARK: - IBOutlets -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var introductionText: UITextView!
    @IBOutlet weak var firstSubHeader: UILabel!
    @IBOutlet weak var firstSubHeaderDetail: UITextView!
    @IBOutlet weak var secondSubHeader: UILabel!
    @IBOutlet weak var secondSubHeaderDetail: UITextView!
    @IBOutlet weak var introductionTextViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: - properties declaration -
    var eventDescriptions: EventDescriptions!
    var isFirstTime: Bool = true
    
    //MARK: - UIView overridden methods -
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if self.isFirstTime == true {
            
            self.configureSubViewContent()
            self.isFirstTime = false
        }

    }
    
    private func configureSubViewContent() {
        
        self.titleLabel.text = self.eventDescriptions.header.titleText
        self.introductionText.text = self.eventDescriptions.header.introductionText
        self.introductionText.setContentOffset(CGPointZero, animated: false)
        
        
//        let fixedWidth = self.introductionText.frame.size.width;
//        
//        let newSize = self.introductionText.sizeThatFits(CGSizeMake(fixedWidth, CGFloat.max))
//        var newFrame = self.introductionText.frame
//        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
//        
//        self.introductionTextViewHeightConstraint.constant = newFrame.size.height
        
        let subHeadersCollection = self.eventDescriptions.subHeaders
        
        for var nIndex = 0; nIndex < subHeadersCollection.count; nIndex++ {
            
            let subHeader = subHeadersCollection.objectAtIndex(nIndex) as! EventSegmentSubHeader
            
            switch(nIndex) {
                
            case 0:
                self.firstSubHeader.text = subHeader.subHeaderTitle
                self.firstSubHeaderDetail.text = subHeader.subHeaderDetail
                self.firstSubHeaderDetail.setContentOffset(CGPointZero, animated: false)
                break
                
            case 1:
                self.secondSubHeader.text = subHeader.subHeaderTitle
                self.secondSubHeaderDetail.text = subHeader.subHeaderDetail
                self.secondSubHeaderDetail.setContentOffset(CGPointZero, animated: false)
                break
                
             default:
                break
            }
        }
        
    }
    
    //MARK: UITextView delegate methods -
    func textViewDidChange(textView: UITextView) {
        
        let fixedWidth = textView.frame.size.width;
        
        let newSize = textView.sizeThatFits(CGSizeMake(fixedWidth, CGFloat.max))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        self.introductionTextViewHeightConstraint.constant = newFrame.size.height

        self.setNeedsUpdateConstraints()
    }
    
    
}
