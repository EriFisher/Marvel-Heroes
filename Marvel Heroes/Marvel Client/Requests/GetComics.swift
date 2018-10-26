//  Created by Eric on 10/25/18.
//  Copyright © 2018 App Parents LLC. All rights reserved.
//
import Foundation

public struct GetComics: APIRequest {
	// When encountered with this kind of enums, it will spit out the raw value
	public enum ComicFormat: String, Encodable {
		case comic = "comic"
		case digital = "digital comic"
		case hardcover = "hardcover"
	}

	public typealias Response = [Comic]

	public var resourceName: String {
		return "comics"
	}

	// Parameters
	public let title: String?
	public let titleStartsWith: String?
	public let format: ComicFormat?
	public let limit: Int?
	public let offset: Int?
    public struct Resource{
        var available: Int
        var returned: Int
        var collectionURI: URL
    }
	// Note that nil parameters will not be used
	public init(title: String? = nil,
	            titleStartsWith: String? = nil,
	            format: ComicFormat? = nil,
	            limit: Int? = nil,
	            offset: Int? = nil) {
		self.title = title
		self.titleStartsWith = titleStartsWith
		self.format = format
		self.limit = limit
		self.offset = offset
	}
}
