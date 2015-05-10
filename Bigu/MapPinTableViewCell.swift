//
//  MapPinTableViewCell.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 5/2/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit
import MapKit

public class MapPinTableViewCell: UITableViewCell, MKMapViewDelegate {

    @IBOutlet weak public var mapView: MKMapView!
    
    private var location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0) {
        didSet{
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegionMake(self.location, span)
            self.mapView.setRegion(region, animated: true)
        }
    }
    public var pin: MKPointAnnotation? {
        didSet {
            if self.pin != nil {
                self.location = self.pin!.coordinate
                self.mapView.addAnnotation(self.pin!)
            }
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class public var reuseId: String {
        return "MapPinTableViewCellReuseId"
    }
}
