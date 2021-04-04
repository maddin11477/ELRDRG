//
//  OpenTopoMapProvider.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 22.03.21.
//  Copyright © 2021 Jonas Wehner. All rights reserved.
//

import UIKit
import MapKit

class OpenTopoMapProvider: BaseTileOverlay {
    override func url(forTilePath path: MKTileOverlayPath) -> URL {
      let tileUrl =
        "http://a.tile.opentopomap.org/\(path.z)/\(path.x)/\(path.y).png"
      
      return URL(string: tileUrl)!
    }
}
