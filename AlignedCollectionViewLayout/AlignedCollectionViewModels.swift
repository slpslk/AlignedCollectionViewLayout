//
//  AlignedCollectionViewModels.swift
//  AlignedCollectionViewLayout
//
//  Created by Sofya Avtsinova on 08.11.2024.
//

import Foundation

enum Size: Float {
    case small = 0.2
    case normal = 0.4
}

enum Alignment {
    case left
    case center
    case right
}

struct Data {
    let alignment: Alignment
    let elements: [[Size]]
}

