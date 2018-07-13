//
//  main.swift
//  xcbetarunner
//
//  Created by Daniele Margutti.
//  twitter: @danielemargutti
//  web: http://www.danielemargutti.com
//  Copyright © 2018 Daniele Margutti. All rights reserved.
//

import Foundation

struct Arguments {
	var xcode: XcodeApp? = XcodeApp.defaultApp()
	var xcodeBeta: XcodeApp? = XcodeApp.betaApp()
	var action: String?
	var symLink: Bool = true
	var sdkToCopy: [String] = []
	
	public func hasAllXcodePaths() -> Bool {
		return (xcode != nil && xcodeBeta != nil)
	}
	
	public func hasMainXCode() -> Bool {
		return (xcode != nil)
	}
	
	init(arguments: [String]) {
		for (idx, argument) in arguments.enumerated() {
			switch argument.lowercased() {
			case "--xcodebeta", "-xcb":
				if let path = arguments.element(after: idx) {
					self.xcode = XcodeApp(path: path)
				}
			case "--xcode", "-xc":
				if let path = arguments.element(after: idx) {
					self.xcodeBeta = XcodeApp(path: path)
				}
			case "--action", "-a":
				self.action = arguments.element(after: idx)?.lowercased()
			case "--symlink", "-l":
				if let value = arguments.element(after: idx) {
					self.symLink = (value == "true")
				}
			case "--sdk", "-sdk":
				self.sdkToCopy = (arguments.element(after: idx) ?? "").components(separatedBy: ",").map({
					return $0.trimmingCharacters(in: CharacterSet.whitespaces)
				})
			default:
				break
			}
		}
	}
}


print("📲 Welcome to xcbetarunner, a simple way to use new iOS SDKs on old XCode")
print("")
var args = Arguments(arguments: CommandLine.arguments)

switch args.action {
case "list":	exec_listSDKsOfXCodeApp(args)
case "new":		exec_listNewSDKs(args)
case "use":		exec_useSDKOnStableXcode(args)
case "sync":	exec_syncSDKs(&args)
case "help":	exec_printHelp()
default:		print("❌ Unknown command received")
}
