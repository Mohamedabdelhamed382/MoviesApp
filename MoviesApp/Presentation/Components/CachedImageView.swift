
import SwiftUI

struct CachedImageView<Placeholder: View>: View {
    let urlString: String
    let placeholder: Placeholder
    
    @State private var image: Image?
    @State private var isLoading = false
    
    init(urlString: String, @ViewBuilder placeholder: () -> Placeholder) {
        self.urlString = urlString
        self.placeholder = placeholder()
    }
    
    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder
                    .onAppear {
                        load()
                    }
            }
        }
    }
    
    private func load() {
        guard let url = URL(string: urlString) else { return }
        if isLoading { return }
        
        // Check cache first
        if let cached = ImageCacheService.shared.loadImage(for: url) {
            self.image = cached
            return
        }
        
        isLoading = true
        // Download and cache
        Task {
            await ImageCacheService.shared.saveImage(from: url)
            
            if let cached = ImageCacheService.shared.loadImage(for: url) {
                await MainActor.run {
                    self.image = cached
                    self.isLoading = false
                }
            } else {
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
}
