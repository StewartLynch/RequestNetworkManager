import SwiftUI

struct CreateUserSheetView: View {
    @Environment(UsersViewModel.self) private var model
    @Environment(\.dismiss) private var dismiss
    let user: User?

    @State private var name = ""
    @State private var email = ""
    @State private var gender: User.Gender = .male
    @State private var status: User.Status = .active
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    @State private var hasInitializedForm = false

    private var isEditing: Bool { user != nil }
    private var navigationTitle: String { isEditing ? "Update User" : "Create User" }
    private var submitTitle: String { isEditing ? "Update" : "Add" }
    private var alertTitle: String { isEditing ? "Unable to update user" : "Unable to create user" }

    init(user: User? = nil) {
        self.user = user
    }

    private var canSubmit: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !isSubmitting
    }

    var body: some View {
        NavigationStack {
            formSection
                .navigationTitle(navigationTitle)
                .toolbarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .disabled(isSubmitting)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(submitTitle) {
                            
                        }
                        .disabled(!canSubmit)
                    }
                }
                .onAppear {
                    guard !hasInitializedForm else { return }
                    if let user {
                        name = user.name
                        email = user.email
                        gender = user.gender
                        status = user.status
                    }
                    hasInitializedForm = true
                }
                .alert(alertTitle, isPresented: Binding(
                    get: { errorMessage != nil },
                    set: { if !$0 { errorMessage = nil } }
                )) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(errorMessage ?? "")
                }
        }
    }

    private var formSection: some View {
        Form {
            TextField("Name", text: $name)
                .textFieldStyle(.roundedBorder)

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)

            Picker("Gender", selection: $gender) {
                Text("Male").tag(User.Gender.male)
                Text("Female").tag(User.Gender.female)
            }
            .pickerStyle(.segmented)

            Picker("Status", selection: $status) {
                Text("Active").tag(User.Status.active)
                Text("Inactive").tag(User.Status.inactive)
            }
            .pickerStyle(.segmented)

            if isSubmitting {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    CreateUserSheetView()
        .environment(UsersViewModel())
}
