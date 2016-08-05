//
//  Renderer.swift
//  Gravity
//
//  Created by Silvan Mosberger on 05/08/16.
//  
//

import Foundation
import MetalKit
import MetalMemory

protocol Renderer {
	associatedtype RenderedObject
	init(device: MTLDevice, library: MTLLibrary)
	func render(encoder: MTLRenderCommandEncoder)
}

