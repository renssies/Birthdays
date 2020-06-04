//
//  ContactsLoader.swift
//  Birthdays
//
//  Created by Rens Verhoeven on 03/06/2020.
//  Copyright © 2020 Renssies. All rights reserved.
//

import UIKit
import Contacts

public class ContactsLoader: NSObject, ObservableObject {

    @Published public var contacts = [BirthdayContact]()
    
    @Published public var groupedContacts = [Month: [BirthdayContact]]()
    
    @Published public var months = [Month]()
    
    @Published public var isLoading: Bool = false
    
    public var contactStore = CNContactStore()
    
    public var contactFormatter = CNContactFormatter()
    
    public func loadContacts() {
        guard CNContactStore.authorizationStatus(for: .contacts) == .authorized else {
            return
        }
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            
            
            do {
                let contacts = try self.enumerateContacts()
                
                let contactsPerMonth = self.seperateContactsPerMonth(contacts: contacts)
                
                let months = Array(contactsPerMonth.keys).sorted(by: { $0.rawValue < $1.rawValue })
                let currentMonth = Calendar.current.component(.month, from: Date())
                let comingMonths = months.filter { $0.rawValue >= currentMonth }
                let pastMonths = months.filter { $0.rawValue < currentMonth }
                
                DispatchQueue.main.async {
                    self.contacts = contacts
                    self.groupedContacts = contactsPerMonth
                    
                    self.months = comingMonths + pastMonths
                    self.isLoading = false
                }
                
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
    private func enumerateContacts() throws -> [BirthdayContact] {
        let keys: [CNKeyDescriptor] = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                                       CNContactBirthdayKey as CNKeyDescriptor,
                                       CNContactThumbnailImageDataKey as CNKeyDescriptor]
        var contacts = [BirthdayContact]()
        let request = CNContactFetchRequest(keysToFetch: keys)
        try self.contactStore.enumerateContacts(with: request) { (contact, stop) in
            guard contact.isKeyAvailable(CNContactBirthdayKey) else {
                return
            }
            guard let birthday = contact.birthday, let name = self.contactFormatter.string(from: contact), birthday.month != nil && birthday.day != nil else {
                return
            }
            contacts.append(BirthdayContact(id: contact.identifier, name: name, birthday: birthday, thumbnailImageData: contact.thumbnailImageData))
        }
        contacts.sort { (contact1, contact2) -> Bool in
            return contact1.nextBirthdayDate.compare(contact2.nextBirthdayDate) == .orderedAscending
        }
        return contacts
    }
    
    private func seperateContactsPerMonth(contacts: [BirthdayContact]) -> [Month: [BirthdayContact]] {
        return contacts.reduce([Month: [BirthdayContact]]()) { (previousResult, contact) -> [Month: [BirthdayContact]] in
            let month = Month(rawValue: contact.birthday.month ?? 0) ?? .unknown
            var contacts = previousResult[month] ?? [BirthdayContact]()
            contacts.append(contact)

            var newResult = previousResult
            newResult[month] = contacts
            return newResult
        }
    }
    
}
