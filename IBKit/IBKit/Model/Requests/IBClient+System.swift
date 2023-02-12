//
//  IBClient+System.swift
//	IBKit
//
//	Copyright (c) 2016-2023 Sten Soosaar
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//




import Foundation

extension IBClient {
	
	internal func sendGreeting(range: ClosedRange<Int>) {
	
		var greeting = Data()
		let prefix="API\0"
		if let contentData = prefix.data(using: .ascii, allowLossyConversion: false){
			greeting += contentData
		}
	
		let versions = "v\(range.lowerBound)..\(range.upperBound)"
		greeting += versions.count.toBytes(size: 4)
		if let contentData = versions.data(using: .ascii, allowLossyConversion: false){
			greeting += contentData
		}
	
		connection?.send(data: greeting)
	
	}

	
	internal func startAPI(clientID: Int) throws {
		let version: Int = 2
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.startAPI)
		try container.encode(version)
		try container.encode(clientID)
		try container.encode("")
		try send(encoder: encoder)
	}
	
	
	public func nextRequestID() throws {
		let version: Int = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.nextId)
		try container.encode(version)
		try container.encode("")
		try send(encoder: encoder)

	}
	
	public func serverTime() throws {

		let version: Int = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.serverTime)
		try container.encode(version)
		try send(encoder: encoder)

	}

	public func subscribeBulletins(includePast all: Bool = false) throws {

		let version: Int = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.newsBulletins)
		try container.encode(version)
		try container.encode(all)
		try send(encoder: encoder)

	}
	
	public func unsubscribeNewsBulletins() throws {

		let version: Int = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.cancelNewsBulletins)
		try container.encode(version)
		try send(encoder: encoder)

	}
	
}
