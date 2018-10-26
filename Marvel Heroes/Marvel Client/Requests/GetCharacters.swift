//  Created by Eric on 10/25/18.
//  Copyright © 2018 App Parents LLC. All rights reserved.
//

import Foundation

public struct GetCharacters: APIRequest {
	public typealias Response = [ComicCharacter]

	public var resourceName: String {
		return "characters"
	}

	// Parameters
	public var name: String?
	public var nameStartsWith: String?
	public var limit: Int?
	public var offset: Int?

	// Note that nil parameters will not be used
	public init(name: String? = nil,
	            nameStartsWith: String? = nil,
	            limit: Int? = nil,
	            offset: Int? = nil) {
		self.name = name
		self.nameStartsWith = nameStartsWith
		self.limit = limit
		self.offset = offset
	}
}
