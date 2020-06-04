//
//  ContentView.swift
//  Birthdays
//
//  Created by Rens Verhoeven on 02/06/2020.
//  Copyright © 2020 Renssies. All rights reserved.
//

import SwiftUI
import Contacts

// MARK: - Content View

struct ContentView: View {
    
    @State private var hasPermission = false
    
    @EnvironmentObject private var contactsLoader: ContactsLoader
    
    var body: some View {
        NavigationView {
            Group {
                if hasPermission {
                    Group {
                        if self.contactsLoader.isLoading {
                            Text("Loading...")
                        } else {
                            BirthdaysList()
                        }
                    }
                } else {
                    PermissionView(hasPermission: $hasPermission)
                }
            }
            .navigationBarTitle("Birthdays")
            .onAppear {
                self.hasPermission = CNContactStore.authorizationStatus(for: .contacts) == .authorized
            }
        }
    }

}

// MARK: - Birthdays List

struct BirthdaysList: View {
    
    @EnvironmentObject private var contactsLoader: ContactsLoader
    
    var body: some View {
        List {
            ForEach(contactsLoader.months) { group in
                Section(header: Text(group.displayName)) {
                    ForEach(self.contactsLoader.groupedContacts[group] ?? []) { contact in
                        BirthdayCell(contact: contact)
                    }
                }
            }
            VStack(alignment: .center) {
                Text("\(contactsLoader.contacts.count) Contacts")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Permission View

struct PermissionView: View {
    
    @EnvironmentObject private var contactsLoader: ContactsLoader
    
    @Binding internal var hasPermission: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            Text("We need your permission to see the birthdays of your contacts")
                .multilineTextAlignment(.center)
                .frame(minWidth: 100, idealWidth: 320, maxWidth: 320, alignment: .center)
            Button(action: {
                if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
                    self.contactsLoader.contactStore.requestAccess(for: .contacts) { (status, error) in
                        self.hasPermission = status
                        self.contactsLoader.loadContacts()
                    }
                } else {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                }
            }, label: {
                Text("Enable permissions")
                    .fontWeight(.semibold)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
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


