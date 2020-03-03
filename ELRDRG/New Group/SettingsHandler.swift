//
//  SettingsHandler.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 29.02.20.
//  Copyright © 2020 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData

class SettingsHandler: NSObject {

	//lädt einstellungen, wenn keine vorhanden sind, werden neue angelegt
	public func getSettings() -> Settings
	{
		let request: NSFetchRequest<Settings> = Settings.fetchRequest()

		do
		{
			let settings = try AppDelegate.viewContext.fetch(request)
			if settings.count > 0
			{
				return settings[0]
			}
			else
			{
				let setting = Settings(context: AppDelegate.viewContext)
				do
				{
					try AppDelegate.viewContext.save()
				}catch{

				}
				return setting
			}

		}
		catch
		{
			let setting = Settings(context: AppDelegate.viewContext)
			do
			{
				try AppDelegate.viewContext.save()
			}catch{

			}
			return setting
		}
	}

	public func save()->Bool
	{
		do{
			try AppDelegate.viewContext.save()
			return true
		}
		catch{
			return false
		}
	}



}
