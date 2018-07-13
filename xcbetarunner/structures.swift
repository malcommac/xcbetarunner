//
//  Structures.swift
//  xcbetarunner
//
//  Created by Daniele Margutti.
//  twitter: @danielemargutti
//  web: http://www.danielemargutti.com
//  Copyright © 2018 Daniele Margutti. All rights reserved.
//

import Foundation

public class XcodeSDK: Hashable, Equatable {
	public let name: String
	public weak var app: XcodeApp?
	
	public var hashValue: Int {
		return self.name.hashValue
	}
	
	public lazy var path: String = {
		return self.app!.sdksFolder.append(component: name)
	}()
	
	public init(_ name: String, xcode: XcodeApp) {
		self.name = name
		self.app = xcode
	}
	
	public static func ==(lhs: XcodeSDK, rhs: XcodeSDK) -> Bool {
		return lhs.name == rhs.name
	}
	
	public func copy(toXCode app: XcodeApp, asSymLink: Bool) -> Bool {
		do {
			let destPath = app.sdksFolder.append(component: self.name)
			switch asSymLink {
			case false:
				try FileManager.default.copyItem(atPath: self.path, toPath: destPath)
			case true:
				try FileManager.default.createSymbolicLink(atPath: destPath, withDestinationPath: self.path)
			}
			return true
		} catch let err {
			print(" - Error occurred: \(err)")
			return false
		}
	}
	
}

public class XcodeApp: CustomStringConvertible {
	private let DEVICE_SUPPORT_PATH = "/Contents/Developer/Platforms/iPhoneOS.platform/DeviceSupport"

	
	public var path: String
	
	private lazy var infoDictionary: [String:Any] = {
		let infoDictPath = self.path.append(component: "Contents/Info.plist")
		return (NSDictionary.init(contentsOfFile: infoDictPath) as? [String:Any]) ?? [:]
	}()
	
	public lazy var versionNo: String = {
		return (self.infoDictionary["CFBundleShortVersionString"] as? String) ?? "UNKNOWN"
	}()
	
	public lazy var buildNo: String = {
		return (self.infoDictionary["DTSDKBuild"] as? String) ?? "UNKNOWN"
	}()
	
	public lazy var sdksFolder: String = {
		return self.path.append(component: DEVICE_SUPPORT_PATH)
	}()
	
	public init?(path: String) {
		guard FileManager.default.fileExists(atPath: path) else { return nil }
		guard (path as NSString).pathExtension == "app" else { return nil }
		self.path = path
	}
	
	public convenience init?(name: String) {
		guard let appDir = NSSearchPathForDirectoriesInDomains(.applicationDirectory, .systemDomainMask, true).first else {
			return nil
		}
		let fullPath = appDir.append(component:"\(name).app")
		self.init(path: fullPath)
	}
	
	public static func betaApp() -> XcodeApp? {
		return XcodeApp(name: "Xcode-beta")
	}
	
	public static func defaultApp() -> XcodeApp? {
		return XcodeApp(name: "Xcode")
	}
	
	public func supportedSDKs() throws -> [XcodeSDK] {
		let list = try FileManager.default.contentsOfDirectory(atPath: self.sdksFolder).sorted(by: { (fA, fB) -> Bool in
			return (fA.compare(fB, options: .numeric) == .orderedDescending)
		}).map( {
			return XcodeSDK($0, xcode: self)
		})
		return list
	}
	
	public func newSDKs(comparingTo otherXCode: XcodeApp) throws-> [XcodeSDK] {
		let thisSDKsSet = try Set<XcodeSDK>(self.supportedSDKs())
		let otherSDKsSet = try Set<XcodeSDK>(otherXCode.supportedSDKs())
		let diff =  Array(thisSDKsSet.subtracting(otherSDKsSet))
		return diff
	}
	
	public var description: String {
		return "Xcode \(self.versionNo)(\(self.buildNo))"
	}
	
	public func filteredSDKs(withNames names: [String])  -> [XcodeSDK] {
		do {
			return try self.supportedSDKs().filter({
				return names.contains($0.name)
			})
		} catch {
			return []
		}
	}
 }

extension Array {
	func element(after index: Int) -> Element? {
		guard index >= 0 && index < count else {
			return nil
		}
		
		return self[index + 1]
	}
}

extension Array where Element: Hashable {
	func difference(from other: [Element]) -> [Element] {
		let thisSet = Set(self)
		let otherSet = Set(other)
		return Array(thisSet.subtracting(otherSet))
	}
}

extension String {
	
	public func pad(to length: Int, pad: String = " ", startingAt start: Int = 0) -> String {
		return (self as NSString).padding(toLength: length, withPad: pad, startingAt: start)
	}
	
	public func append(component: String) -> String {
		return (self as NSString).appendingPathComponent(component)
	}
	
}
