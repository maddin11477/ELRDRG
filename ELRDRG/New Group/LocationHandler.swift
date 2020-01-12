//
//  LocationHandler.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 31.12.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import CoreLocation
class LocationHandler: NSObject, CLLocationManagerDelegate {

	private let locationManager : CLLocationManager = CLLocationManager()
	private var enabled : Bool = false

	//Read Only
	public var serviceAvailable : Bool {
		//not sure if it is required
		get{
			if let _  = currentLocation
			{
				return self.enabled
			}
			else
			{
				return false
			}

		}
	}

	private var currentLocation : CLLocation?
	private static var locationHandler : LocationHandler = {
		let handler = LocationHandler()
		//Checking if we have Autorization for Location Abbo
		if(handler.checkAutorization() == false)
		{
			handler.locationManager.requestAlwaysAuthorization()
			if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways
			{
				handler.locationManager.requestWhenInUseAuthorization()
			}
		}

		if(handler.checkAutorization())
		{
			handler.start()
		}

		return handler
	}()


	private func start()
	{
		if CLLocationManager.locationServicesEnabled()
		{

				locationManager.delegate = self
				locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
				locationManager.startUpdatingLocation()
				enabled = true
		}
		else
		{
			enabled = false
			print("No Location Service enabled")
		}
	}
	private func checkAutorization()->Bool
	{
		switch CLLocationManager.authorizationStatus() {
		case CLAuthorizationStatus.authorizedAlways:
			return true
		case CLAuthorizationStatus.authorizedWhenInUse:
			return true
		default:
			return false
		}
	}

	//singleton pattern
	private override init()
	{

	}


	public static func shared()->LocationHandler
	{
		return locationHandler
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		self.currentLocation = locations.last
	}


	public func getCurrentLocation() -> CLLocation?
	{
		return self.currentLocation
	}

	public func getDistance(RemoteLocation lat : Double, RemoteLocation lng : Double)->Double
	{

		let location = CLLocation(latitude: lng, longitude: lat)
		//no service available all distances are generated to the same
		

		if let ownLocation = self.currentLocation
		{
			return ownLocation.distance(from: location)
		}
		else
		{
			return -1
		}




	}

}
