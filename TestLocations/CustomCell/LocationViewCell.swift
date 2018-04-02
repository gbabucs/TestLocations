//
//  LocationViewCell.swift
//  TestLocations
//
//  Created by Babu Gangatharan on 4/2/18.
//  Copyright © 2018 Babu Gangatharan. All rights reserved.
//

import UIKit

class LocationViewCell: UITableViewCell {
    
    //--------------------------------------------------------------------------
    // MARK: - IBOutlet
    //--------------------------------------------------------------------------
    
    @IBOutlet weak var locationName: UILabel!
    
    //--------------------------------------------------------------------------
    // MARK: - Helpers
    //--------------------------------------------------------------------------
    
    func update(with location: GeoLocation) {
        locationName.text = location.name
    }

}
