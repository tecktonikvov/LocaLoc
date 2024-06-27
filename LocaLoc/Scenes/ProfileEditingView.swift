//
//  ProfileEditingView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 26/5/24.
//

import PhotosUI
import SwiftUI
import PopupView

struct ProfileEditingView: View {
    @Bindable private var viewModel: ProfileEditingViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showCamera = false
    @State private var showPhotosPicker = false
    @State private var doesImageWasChanged = false
        
    init(viewModel: ProfileEditingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ProfileEditingListView(
                viewModel: viewModel,
                doesImageWasChanged: $doesImageWasChanged,
                showCamera: $showCamera,
                showPhotosPicker: $showPhotosPicker
            )
        }
        .navigationTitle("Edit profile")
        .toolbar {
            if viewModel.isLoading {
                ProgressView()
            } else {
                Button("Done", action: viewModel.saveChanges)
            }
        }
        
        // Sheets
        .fullScreenCover(isPresented: $showCamera) {
            AccessCameraView(selectedImage: $viewModel.selectedUIImage)
        }
        .photosPicker(isPresented: $showPhotosPicker, selection: $viewModel.selectedPickerImage)
        
        // Actions
        .onChange(of: viewModel.selectedPickerImage) { _, _ in
            viewModel.setSelectedUIImage()
        }
        .onChange(of: viewModel.selectedUIImage) { _, _ in
            doesImageWasChanged = true
        }
        .onChange(of: viewModel.dismiss) { _, shouldDismiss in
            if shouldDismiss {
                dismiss()
            }
        }
        
        // Regular
        .disabled(viewModel.isLoading)
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}

// MARK: - ProfileEditingListView
fileprivate struct ProfileEditingListView: View {
    @Bindable private var viewModel: ProfileEditingViewModel
    @Binding private var doesImageWasChanged: Bool
    @Binding private var showCamera: Bool
    @Binding private var showPhotosPicker: Bool

    @State private var showUsernameTipsView = false
    @State private var showPhotoSourceSheet = false
    
    init(viewModel: ProfileEditingViewModel,
         doesImageWasChanged: Binding<Bool>,
         showCamera: Binding<Bool>,
         showPhotosPicker: Binding<Bool>) {
        self._doesImageWasChanged = doesImageWasChanged
        self._showCamera = showCamera
        self._showPhotosPicker = showPhotosPicker
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            Section {
                HStack(alignment: .center) {
                    ZStack {
                        if !doesImageWasChanged {
                            CachedCenteredImage(
                                url: URL(string: viewModel.profile.imageUrl),
                                placeholderImageName: "person.circle.fill")
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                            
                        } else {
                            CachedCenteredImage(uiImage: viewModel.selectedUIImage ?? UIImage())
                                .frame(width: 80, height: 80)
                        }
                    }
                    .overlay {
                        ZStack {
                            Button {
                                showPhotoSourceSheet = true
                            } label: {
                                Image(systemName: "camera")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color.white)
                            }
                        }
                    }
                    .background(Color.gray)
                    .opacity(0.7)
                    .clipShape(Circle())
                    
                    VStack {
                        TextField("First name", text: $viewModel.profile.firstName.max(Constants.firstNameCharactersLimit))
                        Rectangle()
                            .frame(height: 0.5)
                        TextField("Last name", text: $viewModel.profile.lastName.max(Constants.lastNameCharactersLimit))
                    }
                    .padding(.leading)
                }
            }
            
            VStack {
                HStack {
                    Text("@")
                        .padding(.trailing, -6)
                    TextField("Username",
                              text: $viewModel.profile.username.max(Constants.usernameCharactersLimit)) { isEditing in
                        showUsernameTipsView = isEditing || viewModel.errorText != nil
                    }
                }
                .onChange(of: viewModel.profile.username) { _, _ in
                    viewModel.errorText = nil
                }
                
                if showUsernameTipsView || viewModel.errorText != nil {
                    if let errorText = viewModel.errorText {
                        Text(errorText)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.footnote)
                            .foregroundColor(Color.Text.attention)
                    } else {
                        let amount = symbolsLeft()
                        Text("\(amount) symbols left")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.footnote)
                            .foregroundColor(amount <= 0 ? Color.Text.attention : Color.Text.main)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .scrollContentBackground(.hidden)
        .backgroundDefault()
        .popup(isPresented: $showPhotoSourceSheet) {
            SourceSelector(showCamera: $showCamera, showGallery: $showPhotosPicker)
        } customize: {
            $0
                .type(.toast)
                .appearFrom(.bottomSlide)
                .disappearTo(.bottomSlide)
                .closeOnTapOutside(true)
                .isOpaque(true)
                .backgroundColor(Color.black.opacity(0.5))
        }
    }
    
    // MARK: - Private
    private func symbolsLeft() -> Int {
        let amount = Constants.usernameCharactersLimit - viewModel.profile.username.count
        return max(0, amount)
    }
}

// MARK: - AccessCameraView
fileprivate struct AccessCameraView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(picker: self)
    }
}

// MARK: - Coordinator
fileprivate final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: AccessCameraView
    
    init(picker: AccessCameraView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.picker.selectedImage = selectedImage
        self.picker.isPresented.wrappedValue.dismiss()
    }
}

// MARK: - SourceSelector
fileprivate struct SourceSelector: View {
    @Binding var showCamera: Bool
    @Binding var showGallery: Bool
    
    init(showCamera: Binding<Bool>, showGallery: Binding<Bool>) {
        self._showCamera = showCamera
        self._showGallery = showGallery
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Select source")
                .font(.title)
                .padding(.vertical)
            
                Button {
                    showCamera = true
                } label: {
                    ZStack {
                        HStack {
                            Image(systemName: "camera")
                                .font(.system(size: 24))
                            Spacer()
                        }
                        Text("Camera")
                    }
                    .padding()
                    .background(Color.Extra.isabelline)
                }
                .cornerRadius(12)
                .tint(Color.black)
                .padding(.horizontal)
                
                Button {
                    showGallery = true
                } label: {
                    ZStack {
                        HStack {
                            Image(systemName: "photo")
                                .font(.system(size: 24))
                            Spacer()
                        }
                        Text("Gallery")
                    }
                    .padding()
                    .background(Color.Extra.isabelline)
                }
                .cornerRadius(12)
                .tint(Color.black)
                .padding(.horizontal)
        }
        .padding(.bottom, 40)
        .frame(maxWidth: .infinity)
        .background(Color.background)
        .cornerRadius(24)
    }
}

//#Preview {
//    var previewer = Previewer()
//    return ProfileEditingListView(
//        viewModel: ProfileEditingViewModel(
//            userDataRepository: previewer.userDataRepository,
//            usernameManager: previewer.usernameManager, 
//            userPhotoUploader: previewer.userPhotoUploader),
//        doesImageWasChanged: .constant(false), showCamera: .constant(false), showPhotosPicker: .constant(false))
//}
