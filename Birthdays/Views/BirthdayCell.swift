//
//  BirthdayCell.swift
//  Birthdays
//
//  Created by Rens Verhoeven on 04/06/2020.
//  Copyright © 2020 Renssies. All rights reserved.
//

import SwiftUI

struct BirthdayCell: View {
    
    var contact: BirthdayContact
    
    var body: some View {
        HStack(spacing: 10) {
            Image(uiImage: contact.thumbnail ?? UIImage(named: "Placeholder")!)
                .resizable()
                .frame(width: 40, height: 40, alignment: .center)
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .accentColor(.primary)
            
            VStack(alignment: .leading) {
                Text(contact.name)
                    .fontWeight(.medium)
                Text(contact.formattedBirthday ?? "Unknown")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            ZStack {
                Color.purple.brightness(0.2)
                    .frame(width: 50, height: 50)
                    .cornerRadius(10)
                if contact.hasAge {
                    Text("\(contact.age(at: contact.nextBirthdayDate) ?? 0)")
                        .ageLabel()
                } else {
                    Text("??")
                        .ageLabel()
                }
            }.padding(.all, 10)
        }
    }
}

extension Text {
    func ageLabel() -> Text {
        self
        .font(.title)
        .fontWeight(.black)
        .foregroundColor(.white)
    }

}

struct BirthdayCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                BirthdayCell(contact: BirthdayContact(id: "hello", name: "Rens Verhoeven", birthday: DateComponents(calendar: .current, timeZone: .current, year: 1993, month: 9, day: 26)))
            }
            .previewLayout(PreviewLayout.fixed(width: 375, height: 100))
            
            List {
                BirthdayCell(contact: BirthdayContact(id: "hello", name: "Rens Verhoeven", birthday: DateComponents(calendar: .current, timeZone: .current, year: 1993, month: 9, day: 26)))
            }
            .previewLayout(PreviewLayout.fixed(width: 375, height: 100))
            .environment(\.colorScheme, .dark)
        }
    }
}
