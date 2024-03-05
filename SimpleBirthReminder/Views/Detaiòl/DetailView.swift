//
//  DetailView.swift
//  SimpleBirthReminder
//
//  Created by Nicolò Curioni on 05/03/24.
//

import SwiftUI

struct DetailView: View {
    // MARK: - Properties
    @Bindable var birthday: Birthday
    
    @State private var canEditBirthday: Bool = false
    
    // MARK: - View Life-cycle
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Name")
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text(birthday.name)
                            .fontWeight(.medium)
                    }
                }
                
                Section {
                    HStack {
                        Text("Date of Birthday")
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text(DateFormatter.localizedString(from: birthday.dateOfBirth, dateStyle: .long, timeStyle: .none))
                            .fontWeight(.medium)
                    }
                }
                
                Section {
                    familyToggleView
                }
                
                Section {
                    friendToggleView
                }
            }
        }
        .navigationTitle(birthday.name)
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        canEditBirthday = true
                    } label: {
                        Text("Edit")
                    }
                    
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .font(.title)
                        .fontWeight(.medium)
                }
            }
        }
        .sheet(isPresented: $canEditBirthday) {
            AddBirthdayView(birthday: birthday)
        }
    }
    
    // MARK: - Custom Fields
    var familyToggleView: some View {
        HStack {
            Text("Family Member?")
                .fontWeight(.semibold)
            
            Spacer()
            
            Toggle("", isOn: $birthday.isFamilyMember)
        }
    }
    
    var friendToggleView: some View {
        HStack {
            Text("Friend Member?")
                .fontWeight(.semibold)
            
            Spacer()
            
            Toggle("", isOn: $birthday.isFriendMember)
        }
    }
}

#Preview {
    DetailView(birthday: .init(name: "", dateOfBirth: .now, isFamilyMember: true, isFriendMember: false))
}
