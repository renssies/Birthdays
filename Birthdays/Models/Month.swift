//
//  Month.swift
//  Birthdays
//
//  Created by Rens Verhoeven on 04/06/2020.
//  Copyright © 2020 Renssies. All rights reserved.
//

import Foundation

public enum Month: Int, Identifiable {
    case unknown = 0
    case january
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
    
    public typealias ID = Int
    
    public var id: Int {
        return rawValue
    }
    
    public var displayName: String {
        switch self {
        case .unknown:
            return "Unknown"
        case .january:
            return "January"
        case .february:
            return "February"
        case .march:
            return "March"
        case .april:
            return "April"
        case .may:
            return "May"
        case .june:
            return "June"
        case .july:
            return "July"
        case .august:
            return "August"
        case .september:
            return "September"
        case .october:
            return "October"
        case .november:
            return "November"
        case .december:
            return "December"
        }
    }
    
}
