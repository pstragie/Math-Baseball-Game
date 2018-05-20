//
//  FullVersion.swift
//  Math Baseball Game
//
//  Created by Pieter Stragier on 19/05/2018.
//  Copyright © 2018 Pieter Stragier. All rights reserved.
//

import Foundation

public struct MathBaseballGameFull {
    
    public static let FullVersion = "MathBaseballGameFull"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [MathBaseballGameFull.FullVersion]
    
    public static let store = IAPHelper(productIds: MathBaseballGameFull.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
