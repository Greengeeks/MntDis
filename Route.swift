//
//  Root.swift
//  MntDis
//
//  Created by MntDis on 15/11/2019.
//  Copyright © 2019 MntDis. All rights reserved.
//

import UIKit

struct Equipment {
    var name: String
    var image: UIImage
    var link: URL
}

class Route {
    
    var name: String
    var image: UIImage
    
    var lat: String
    var lon: String
    
    var bottomBeacon: String
    var topBeacon: String
    
    var equipments: [Equipment]
    
    init(name: String, image: UIImage, lat: String, lon: String, bottomBeacon: String, topBeacon: String, equipments: [Equipment]) {
        
        self.name = name
        self.image = image
        
        self.lat = lat
        self.lon = lon
        
        self.bottomBeacon = bottomBeacon
        self.topBeacon = topBeacon
        
        self.equipments = equipments
        
    }

}
