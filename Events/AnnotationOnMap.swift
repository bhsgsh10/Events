//
//  AnnotationOnMap.swift
//  Events
//
//  Created by Bhaskar Ghosh on 20/03/16.
//  Copyright © 2016 Bhaskar Ghosh. All rights reserved.
//

import UIKit
import MapKit

class AnnotationOnMap: NSObject, MKAnnotation {

    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
