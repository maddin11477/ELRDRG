//
//  OpenStreetMapOverlay.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 21.03.21.
//  Copyright © 2021 Jonas Wehner. All rights reserved.
//

import UIKit
import MapKit

class OpenStreetMapOverlay: BaseTileOverlay {
  override func url(forTilePath path: MKTileOverlayPath) -> URL {
    let tileUrl =
      "https://tile.openstreetmap.org/\(path.z)/\(path.x)/\(path.y).png"
    
    return URL(string: tileUrl)!
  }
}


