//  Created by Eric on 10/25/18.
//  Copyright © 2018 App Parents LLC. All rights reserved.
//

import Foundation

public enum Result<Value> {
	case success(Value)
	case failure(Error)
}

public typealias ResultCallback<Value> = (Result<Value>) -> Void
