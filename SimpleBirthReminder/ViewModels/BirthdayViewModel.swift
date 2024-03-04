//
//  BirthdayViewModel.swift
//  SimpleBirthReminder
//
//  Created by Nicolò Curioni on 04/03/24.
//

import Foundation
import SwiftData
import Combine

@MainActor
class BirthdayViewModel: ObservableObject {
    // The database connection
    private let modelContext: ModelContext
    
    // When using Xcode previews, prevent create, update, or delete operations on SampleData
    private let inPreviewMode = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    
    @Published var name: String = ""
    @Published var dateOfBirth: Date = .now
    @Published var isFamilyMember: Bool = false
    @Published var isFriendMember: Bool = false
    
    let createBirthday = PassthroughSubject<Void, Never>()
    let editBirthday = PassthroughSubject<Birthday, Never>()
    let deleteBirthday = PassthroughSubject<Birthday, Never>()
    let toggleBirthdayCompletionStatus = PassthroughSubject<Birthday, Never>()
    
    let confirmEditAction = PassthroughSubject<Bool, Never>()
    let confirmDeleteAction = PassthroughSubject<Bool, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        sinkSubjects()
    }
    
    private func sinkSubjects() {
        createBirthday
            .sink { [weak self] _ in
                guard let self = self else { return }
                let newBirthday = Birthday(name: self.name, dateOfBirth: self.dateOfBirth, isFamilyMember: self.isFamilyMember, isFriendMember: self.isFriendMember)
                self.modelContext.insert(newBirthday)
            }
            .store(in: &subscriptions)
        
        editBirthday
            .sink { [weak self] todo in
                guard let self = self else { return }
                
                self.name = todo.name
            }
            .store(in: &subscriptions)
        
        // Wait for edit completion
        Publishers.Zip(editBirthday, confirmEditAction)
            .sink { [weak self] birthItem, confirmEdit in
                guard let self = self else { return }
                if !confirmEdit { return }
                birthItem.name = self.name
                self.name = ""
            }
            .store(in: &subscriptions)
        
        toggleBirthdayCompletionStatus.sink { birth in
            birth.isFamilyMember.toggle()
            birth.isFriendMember.toggle()
        }
        .store(in: &subscriptions)
        
        deleteBirthday
            .sink { _ in }
            .store(in: &subscriptions)
        
        // Wait for delete completion
        Publishers.Zip(deleteBirthday, confirmDeleteAction)
            .sink { [weak self] birthItem, confirmDelete in
                guard let self = self else { return }
                if !confirmDelete { return }
                self.modelContext.delete(birthItem)
            }
            .store(in: &subscriptions)
    }
}
