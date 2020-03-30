//
//  Connection.swift
//  Recipe House
//
//  Created by Ajay Vandra on 2/27/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import Foundation
import Alamofire

public class Connection{
    class func isConnectedToInternet()->Bool{
        return NetworkReachabilityManager()!.isReachable
    }
}
