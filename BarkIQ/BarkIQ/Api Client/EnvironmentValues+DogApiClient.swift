//
//  EnvironmentValues+DogApiClient.swift.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var dogApiClient: DogApiClient = .live
}
