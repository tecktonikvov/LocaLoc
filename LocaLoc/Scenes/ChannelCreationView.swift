//
//  ChannelCreationView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 25/5/24.
//

import SwiftUI

struct ChannelCreationView: View {
    @Bindable private var viewModel: ChannelCreationViewModel
    
    @Binding private var path: NavigationPath

    // MARK: - Init
    init(viewModel: ChannelCreationViewModel, path: Binding<NavigationPath>) {
        self._path = path
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            DefaultBackground()
            
            List {
                Section("Main information") {
                    ImagePickerView(viewModel: viewModel)
                    
                    TextEditorWithPlaceholder(
                        text: $viewModel.name.max(Constants.channelNameCharactersLimit),
                        placeholder: "Name")
                    
                    TextEditorWithPlaceholder(
                        text: $viewModel.description.max(Constants.channelDescriptionCharactersLimit),
                        placeholder: "Description")
                    
                    HStack(alignment: .top) {
                        Text("@")
                            .opacity(0.6)
                        
                        LimitedTextField(
                            max: Constants.channelIdentifierMaxCharactersLimit,
                            min: Constants.channelIdentifierMinCharactersLimit,
                            title: "Identifier",
                            output: $viewModel.identifier)
                        .padding(.leading, -4)
                    }
                }
                
                Section("Settings") {
                    ChannelSettingsView(viewModel: viewModel)
                }
            }
            .disabled(viewModel.isLoading)
            .scrollContentBackground(.hidden)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text(viewModel.identifierErrorText),
                    message: Text("Try another one"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationTitle("Create new channel")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavBarBackButton {
                    path.removeLast()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    let disabled = viewModel.identifier.count < Constants.channelIdentifierMinCharactersLimit
                    || viewModel.name.isEmpty
                    
                    Button("Create", action: viewModel.createChannel)
                        .disabled(disabled)
                        .foregroundColor(disabled ? Color.Text.subtitle : Color.Text.main)
                }
            }
        }
        .onChange(of: viewModel.dismiss) { _, _ in
            path.removeLast()
        }
    }
}

//#Preview {
//    ChannelCreationView(viewModel: ChannelCreationViewModel(channelIdentifierClient: ChannelIdentifierClient))
//}

fileprivate extension ChannelInvitationMode {
    var title: String {
        switch self {
        case .open:
            return "Open"
        case .byInvitation:
            return "By invitation"
        }
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
                        .opacity(0.6)
                    Spacer()
                }
                .padding(.leading, 4)
            }
            
            TextEditor(text: $text)
        }
        .cornerRadius(12)
    }
}

fileprivate struct ChannelSettingsView: View {
    @State var viewModel: ChannelCreationViewModel
    
    var body: some View {
        Picker("Channel type", selection: $viewModel.invitationMode) {
            ForEach(viewModel.availableInvitationModes, id: \.self) { option in
                Text(option.title)
            }
        }
    }
}

fileprivate struct ImagePickerView: View {
    @State var viewModel: ChannelCreationViewModel
    @State private var showSheet = false
    
    var body: some View {
        Button {
            showSheet = true
        } label: {
            HStack {
                Spacer()
                if viewModel.isImageSelected {
                    CachedCenteredImage(uiImage: viewModel.image)
                        .frame(width: 180, height: 180)
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
            }
            .sheet(isPresented: $showSheet) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$viewModel.image)
            }
        }
    }
}
