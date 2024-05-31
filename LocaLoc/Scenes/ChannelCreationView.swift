//
//  ChannelCreationView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 25/5/24.
//

import SwiftUI

struct ChannelCreationView: View {
    @ObservedObject var viewModel: ChannelCreationViewModel
    
    @State private var showIdentificatorError = false
    @State private var showIdentifierCheckingIndicator = false
    @State private var identificatorErrorText = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Main information") {
                    ImagePickerView(viewModel: viewModel)
                    
                    TextEditorWithPlaceholder(
                        text: $viewModel.name.max(72),
                        placeholder: "Name")
                    
                    TextEditorWithPlaceholder(
                        text: $viewModel.description.max(255),
                        placeholder: "Description")
                    
                    ZStack(alignment: .bottomTrailing) {
                        TextEditorWithPlaceholder(
                            text: $viewModel.identificator.max(72),
                            placeholder: "@Identificator")
                        .onChange(of: viewModel.identificator) { _, newValue in
                            if newValue.first != "@" {
                                viewModel.identificator.insert("@", at: viewModel.identificator.startIndex)
                            }
                            
                            showIdentificatorError = false
                        }
                        
                        if showIdentifierCheckingIndicator {
                            ProgressView()
                                .offset(x: -5, y: -12)
                        }
                        
                        if showIdentificatorError {
                            Text(identificatorErrorText)
                                .foregroundStyle(Color.Text.attention)
                                .offset(x: -5, y: -12)
                                .font(.system(size: 12))
                        }
                    }
                }
                
                Section("Settings") {
                    ChannelSettingsView(viewModel: viewModel)
                }
                
            }
            .scrollContentBackground(.hidden)
            .background(Color.background)
        }
        .navigationTitle("Create new channel")
        .toolbarBackground( Color.background, for: .navigationBar)
        .disabled(showIdentifierCheckingIndicator)
        .toolbar {
            Button("Create") {
                showIdentificatorError = false
                showIdentifierCheckingIndicator = true
                
                Task {
                    let validationResult = await viewModel.validateChanelIndicator()
                    
                    await MainActor.run {
                        switch validationResult {
                        case .ok:
                            print("CREATED")
                        case .error(text: let text):
                            identificatorErrorText = text
                            showIdentificatorError = true
                        }
                        
                        showIdentifierCheckingIndicator = false
                    }
                }
            }
        }
    }
}

#Preview {
    ChannelCreationView(viewModel: ChannelCreationViewModel())
}

fileprivate extension ChannelSettings.EditingPermissionType {
    var title: String {
        switch self {
        case .onlyOwner:
            return "Owner"
        case .ownerAndUsers:
            return "List of users"
        case .everyone:
            return "Everyone"
        }
    }
}

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(limit))
            }
        }
        return self
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

fileprivate struct TextEditorWithPlaceholder: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                VStack {
                    Text(placeholder)
                        .padding(.top, 10)
                        .padding(.leading, 6)
                        .opacity(0.6)
                        .cornerRadius(12)
                    Spacer()
                }
            }
            
            VStack {
                TextEditor(text: $text)
                    .opacity(text.isEmpty ? 0.85 : 1)
                    .cornerRadius(12)
                Spacer()
            }
        }
    }
}

fileprivate struct ChannelSettingsView: View {
    @ObservedObject var viewModel: ChannelCreationViewModel
    //@Binding var showEditingPermissionPicker: Bool
    
    var body: some View {
        //        Picker("Editing permission", selection: $viewModel.selectedEditingPermission) {
        //            ForEach(viewModel.editingPermissionAvailableOption, id: \.self) { option in
        //                Text(option.title)
        //                    .onTapGesture {
        //                        viewModel.selectedEditingPermission = option
        //                        showEditingPermissionPicker.toggle()
        //
        //                        switch option {
        //                        case .ownerAndUsers(ids: let ids):
        //                            break
        //                        default:
        //                            break
        //                        }
        //                    }
        //            }
        //        }
        
        Toggle("Request to join", isOn: $viewModel.isRequestJoinRequired)
    }
}

fileprivate struct ImagePickerView: View {
    @ObservedObject var viewModel: ChannelCreationViewModel
    @State private var showSheet = false
    
    var body: some View {
        Button {
            showSheet = true
        } label: {
            HStack {
                Spacer()
                if viewModel.isImageSelected {
                    Image(uiImage: viewModel.image)
                        .resizable()
                        .cornerRadius(50)
                        .padding(4)
                        .frame(width: 180, height: 180)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "photo.circle.fill")
                        .resizable()
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.Text.main, Color.Extra.silver)
                        .cornerRadius(50)
                        .padding(4)
                        .frame(width: 180, height: 180)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                }
                Spacer()
                    .sheet(isPresented: $showSheet) {
                        ImagePicker(sourceType: .photoLibrary, selectedImage: self.$viewModel.image)
                    }
            }
        }
    }
}
