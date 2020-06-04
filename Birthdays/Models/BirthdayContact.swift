//
//  BirthdayContact.swift
//  Birthdays
//
//  Created by Rens Verhoeven on 03/06/2020.
//  Copyright © 2020 Renssies. All rights reserved.
//

import Foundation
import Contacts
import Combine
import SwiftUI

public struct BirthdayContact: CustomStringConvertible, Identifiable {
        
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    static var dateFormatterWithoutYear: DateFormatter = {
        let template = "dMMM"

        let format = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: NSLocale.current)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter
    }()
    
    public typealias ID = String
    
    public var id: String
    
    public var name: String
    public var birthday: DateComponents
    public var thumbnailImageData: Data?
    public var formattedBirthday: String? {
        guard let date = self.birthday.date else {
            return nil
        }
        guard self.birthday.year ?? 0 > 0 else {
            return BirthdayContact.dateFormatterWithoutYear.string(from: date)
        }
        return BirthdayContact.dateFormatter.string(from: date)
    }
    
    public var hasAge: Bool {
        return currentAge != nil
    }

    public var currentAge: Int? {
        return age(at: Date())
    }
    
    var thumbnail: UIImage? {
        guard let data = self.thumbnailImageData else {
            return nil
        }
        return UIImage(data: data)?.withRenderingMode(.alwaysOriginal)
    }

    public var nextBirthdayDate: Date {
        let calendar = Calendar.current
        
        let currentDateComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        var newDateComponents = DateComponents()
        newDateComponents.calendar = calendar
        newDateComponents.timeZone = TimeZone.current
        if birthday.month! < currentDateComponents.month! || (birthday.month! == currentDateComponents.month! && birthday.day! < currentDateComponents.day!) {
            // This person already had a birthday this year.
            newDateComponents.year = (currentDateComponents.year ?? 0) + 1
        } else {
            newDateComponents.year = currentDateComponents.year
        }
        newDateComponents.day = birthday.day
        newDateComponents.month = birthday.month
        newDateComponents.hour = 0
        newDateComponents.minute = 0
        guard let date = newDateComponents.date else {
            fatalError("All required components are available to create a date, something is wrong")
        }
        return date
    }

    public func age(at date: Date) -> Int? {
        guard self.birthday.year ?? 0 > 0, let birthdayDate = self.birthday.date else {
            return nil
        }
        let calendar = Calendar.current

        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: birthdayDate)
        let date2 = calendar.startOfDay(for: date)

        let components = calendar.dateComponents([.year], from: date1, to: date2)
        return components.year
    }

    public var description: String {
        return "\(name), birthday: \(formattedBirthday ?? "Unknown"), next birthday: \(BirthdayContact.dateFormatter.string(from: nextBirthdayDate)), currentAge: \(currentAge ?? -1), next age \(age(at: nextBirthdayDate) ?? -1)"
    }

}

