//
//  AddBirthdayView.swift
//  SimpleBirthReminder
//
//  Created by Nicolò Curioni on 04/03/24.
//

import SwiftUI

struct AddBirthdayView: View {
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    var birthday: Birthday? = nil
    
    @State var name: String = ""
    @State var dateOfBirth: Date = .now
    @State var isFamilyMember: Bool = false
    @State var isFriendMember: Bool = false
    
    @State private var buttoConfirmTitle = "Save"
    @State private var editorTitle = "Add Birthday"
    
    // MARK: - View Life-cycle
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name (required)", text: $name)
                        .textInputAutocapitalization(.none)
                }
                
                Section {
                    DatePicker("Date of Birthday", selection: $dateOfBirth, displayedComponents: .date)
                        .fontWeight(.medium)
                }
                
                Section {
                    familyToggleView
                }
                
                Section {
                    friendToggleView
                }
            }
            .navigationTitle(editorTitle)
            
            VStack {
                Button(action: addBirthday) {
                    Text(buttoConfirmTitle)
                        .font(.title2)
                        .fontWeight(.medium)
                        .shadow(radius: 8)
                        .frame(height: 30)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.horizontal, 15)
                .disabled(validateFields())
                
                Button(action: cancel) {
                    Text("Cancel")
                        .font(.title2)
                        .fontWeight(.medium)
                        .shadow(radius: 8)
                        .frame(height: 30)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.horizontal, 15)
            }
            .padding(10)
        }
        .onAppear {
            if let birthday {
                // We are editing an exisiting birthday..
                name = birthday.name
                dateOfBirth = birthday.dateOfBirth
                isFamilyMember = birthday.isFamilyMember
                isFriendMember = birthday.isFriendMember
                
                buttoConfirmTitle = "Update"
                editorTitle = "Edit Birthday"
            } else {
                // We are going to add a new birthday
                buttoConfirmTitle = "Save"
                editorTitle = "Add Birthday"
            }
        }
    }
    
    // MARK: - Custom Fields
    var familyToggleView: some View {
        HStack {
            Text("Family Member?")
                .fontWeight(.medium)
            
            Spacer()
            
            Toggle("", isOn: $isFamilyMember)
        }
    }
    
    var friendToggleView: some View {
        HStack {
            Text("Friend Member?")
                .fontWeight(.medium)
            
            Spacer()
            
            Toggle("", isOn: $isFriendMember)
        }
    }
    
    // MARK: - Private Methods
    func addBirthday() {
        if let birthday {
            birthday.name = name
            birthday.dateOfBirth = dateOfBirth
            birthday.isFamilyMember = isFamilyMember
            birthday.isFriendMember = isFriendMember
            
            dismiss()
           
        } else {
            let newBirthday = Birthday(
                name: name,
                dateOfBirth: dateOfBirth,
                isFamilyMember: isFamilyMember,
                isFriendMember: isFriendMember)
            
            modelContext.insert(newBirthday)
            
            dismiss()
        }
    }
    
    private func cancel() {
        withAnimation {
            dismiss()
        }
    }
    
    private func validateFields() -> Bool {
        guard name.isEmpty else {
            return false
        }
        
        return true
    }
}

#Preview {
    AddBirthdayView()
}
