//
//  Preferences.swift
//  Gravity
//
//  Created by Silvan Mosberger on 03/05/16.
//  Copyright © 2016 Silvan Mosberger. All rights reserved.
//

import Foundation


private let defaults = NSUserDefaults.standardUserDefaults()

protocol DefaultsCompatible {
	init?(object: AnyObject)
	var object : AnyObject { get }
}

extension DefaultsCompatible where Self : _ObjectiveCBridgeable {
	init?(object: AnyObject) {
		if let value = object as? Self {
			self = value
		} else {
			return nil
		}
	}
	
	var object: AnyObject {
		return _bridgeToObjectiveC()
	}
}

extension Float : DefaultsCompatible {}
extension Int : DefaultsCompatible {}
extension Bool : DefaultsCompatible {}
extension Double : DefaultsCompatible {}

// Settable & gettable & observable Preferenc value, stored as a property & in NSUserDefaults
final class Property<V : DefaultsCompatible> : NSObject {
	private let key : String
	private var callbacks : [V -> Void] = []
	private var _value : V
	
	
	/// Value of this property
	var value : V {
		get {
			return _value
		}
		set {
			defaults.setValue(newValue.object, forKey: key)
		}
	}
	
	func observe(callback: V -> Void) {
		callbacks.append(callback)
	}
	
	private init(_ key: String, fallback: V) {
		self.key = key
		if let
			obj = defaults.valueForKey(key),
			value = V(object: obj) {
				_value = value
		} else {
			defaults.setValue(fallback.object, forKey: key)
			_value = fallback
		}
		
		super.init()
		
		defaults.addObserver(self, forKeyPath: key, options: .New, context: nil)
	}
	
	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		guard let newObj = change?[NSKeyValueChangeNewKey] else { return }
		guard let value = V(object: newObj) else { return }
		
		_value = value
		
		callbacks.forEach{ $0(value) }
	}
}

class Preferences {
	let test = Property<Float>("test", fallback: 20)
}



