//
//  EventMapViewController.swift
//  Events
//
//  Created by Bhaskar Ghosh on 20/03/16.
//  Copyright © 2016 Bhaskar Ghosh. All rights reserved.
//

import UIKit
import MapKit

class EventMapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - properties declaration -
    @IBOutlet weak var eventMapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0
    var eventName: String?
    var eventLocality: String?
    
    //MARK: - view life cycle methods -
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addButtonToNavigationBar()
        
        self.navigationController?.navigationBar.barTintColor = EventsUtility.getNavigationBarTintColor()

        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        centerMapOnLocation(initialLocation)
        
        self.eventMapView.delegate = self
        
        let annotation = AnnotationOnMap(title: self.eventName!,
                            locationName: self.eventLocality!,
                            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        
        self.eventMapView.addAnnotation(annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Selector for cancel button -
    func cancelButtonTapped() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - private methods -
    
    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        
        self.eventMapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func addButtonToNavigationBar() {
        
        let leftButton =  UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "onCancel")
        
        navigationItem.leftBarButtonItem = leftButton
    }

    func onCancel() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - map view delegate methods -
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? AnnotationOnMap {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                
            }
            return view
        }
        return nil
    }

}
