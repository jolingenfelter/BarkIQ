//
//  Loggers.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

import OSLog

private let systemIdentifier = Bundle.main.bundleIdentifier ?? "com.firstdata.BarkIQ"

extension Logger {
    static let `default` = Logger(subsystem: systemIdentifier, category: "Default")
    
    static let networking = Logger(subsystem: systemIdentifier, category: "Networking")
}
