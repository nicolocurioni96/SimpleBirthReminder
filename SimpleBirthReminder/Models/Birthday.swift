//
//  Birthday.swift
//  SimpleBirthReminder
//
//  Created by Nicolò Curioni on 04/03/24.
//

import Foundation
import SwiftData

@Model
final class Birthday {
    var id = UUID()
    var name: String
    var dateOfBirth: Date
    var isFamilyMember: Bool
    var isFriendMember: Bool
    
    init(id: UUID = UUID(), name: String, dateOfBirth: Date, isFamilyMember: Bool, isFriendMember: Bool) {
        self.id = id
        self.name = name
        self.dateOfBirth = dateOfBirth
        self.isFamilyMember = isFamilyMember
        self.isFriendMember = isFriendMember
    }
}
