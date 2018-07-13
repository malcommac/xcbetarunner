//
//  Commons.swift
//  xcbetarunner
//
//  Created by Daniele Margutti.
//  twitter: @danielemargutti
//  web: http://www.danielemargutti.com
//  Copyright © 2018 Daniele Margutti. All rights reserved.
//

import Foundation

func exec_syncSDKs(_ arguments: inout Arguments) {
	arguments.sdkToCopy = ["all"]
	exec_useSDKOnStableXcode(arguments)
}

func exec_useSDKOnStableXcode(_ arguments: Arguments) {
	guard arguments.hasAllXcodePaths() else {
		error("You must specify both --xcode and --xcodebeta if both XCode versions are not in default path")
		return
	}
	
	guard arguments.sdkToCopy.isEmpty == false else {
		error("You must specify sdk to use using --sdk (ie. \"11.4\" or \"9,11.4,12)")
		return
	}
	do {
		var SDKsList: [XcodeSDK] = []
		if arguments.sdkToCopy.first == "all" {
			SDKsList = try arguments.xcodeBeta!.newSDKs(comparingTo: arguments.xcode!)
			if (SDKsList.isEmpty) {
				print("✅ All SDKs from \(arguments.xcodeBeta!) are also available in \(arguments.xcode!)")
				exit(0)
			}
		} else {
			SDKsList = arguments.xcodeBeta!.filteredSDKs(withNames: arguments.sdkToCopy)
			guard SDKsList.isEmpty == false else {
				error("No SDKs found in \(arguments.xcodeBeta!) from list: \(arguments.sdkToCopy.joined(separator: ","))")
				return
			}
		}
		
		SDKsList.forEach { targetSDK in
			print("🕑 Now copying \"\(targetSDK.name)\"...")
			if targetSDK.copy(toXCode: arguments.xcode!, asSymLink: arguments.symLink) == false {
				error("Failed to copy SDK \"\(targetSDK.name)\"")
			} else {
				print("  ✅ Device Support for SDK \"\(targetSDK.name)\" is now available on \(arguments.xcode!) 🎉")
			}
		}
	} catch let err {
		error("\(err)")
	}
}

func exec_listSDKsOfXCodeApp(_ arguments: Arguments) {
	guard arguments.hasMainXCode() else {
		error("No Xcode path specified. Use --xcode followed by the path to list SDKs")
		return
	}
	do {
		let list = try arguments.xcode!.supportedSDKs()
		print("\(list.count) SDKs supported by \(arguments.xcodeBeta!):")
		list.enumerated().forEach({ (idx,file) in
			print(" - \(file.name)")
		})
	} catch let err {
		error("Failed to list SDKs list: \(err)")
	}
}

func exec_listNewSDKs(_ arguments: Arguments) {
	guard arguments.hasAllXcodePaths() else {
		error("You must specify both --xcode and --xcodebeta if both XCode versions are not in default path")
		return
	}
	do {
		let newSDKs = try arguments.xcodeBeta!.newSDKs(comparingTo: arguments.xcode!)
		if newSDKs.isEmpty {
			print("All SDKs from \(arguments.xcodeBeta!) are also available on \(arguments.xcode!):")
			exit(0)
		}
		
		print("\(newSDKs.count) SDKs from \(arguments.xcodeBeta!) but not available on \(arguments.xcode!):")
		newSDKs.enumerated().forEach({ (idx,file) in
			print(" - \(file.name)")
		})
	} catch let err {
		error("Failed to read directories: \(err)")
	}
}

func error(_ string: String) {
	print("❌ \(string)")
	exit(0)
}

func exec_printHelp() {
	print("Usage:")
	print("")
	
	print("▶︎ List Xcode DeviceSupport SDKs")
	print("xcbetarunner -a list [-xc <Xcode_Path>]")
	print("")

	print("▶︎ Get New Xcode DeviceSupport SDKs between two XCode versions")
	print("  When no -xc/-xcb was specified, /Applications/XCode and /Applications/XCode-beta paths are used")
	print("xcbetarunner -a new [-xc <Xcode_Path>] [-xcb <Xcode_BetaPath> [-l true|false]")
	print("")
	
	print("▶︎ Use specified SDKs in XCode stable")
	print("xcbetarunner -a use [-xc <Xcode_Path>] [-xcb <Xcode_BetaPath> [-l true|false symlink] [-sdk <SDK1;SDK2;SDKn> or all]")
	print("xcbetarunner -a use -sdk all (copy all new SDKs)")
	print("")

	print("▶︎ Sync beta Xcode SDKs to stable Xcode")
	print("xcbetarunner -a sync")
}
