//
//  ImageCacheService.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 02/01/2026.
//

import SwiftUI
import Combine

final class ImageCacheService: ObservableObject {
    static let shared = ImageCacheService()
    
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    // Memory cache to keep SwiftUI Images
    @Published private var memoryCache: [String: Image] = [:]
    
    private init() {
        // Use Caches directory
        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ImageCache")
        
        // Create directory if not exists
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    /// Downloads and saves the image from the given URL to the disk cache properly.
    func saveImage(from url: URL) async {
        let filename = url.lastPathComponent // e.g. "image.jpg"
        let fileURL = cacheDirectory.appendingPathComponent(filename)
        
        // Skip if already exists
        if fileManager.fileExists(atPath: fileURL.path) { return }
        
        do {
            // Check if it's a valid URL for download
            guard url.scheme?.lowercased().hasPrefix("http") == true else { return }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            try data.write(to: fileURL)
            
            // Also save in memory cache
            if let uiImage = UIImage(data: data) {
                let image = Image(uiImage: uiImage)
                memoryCache[filename] = image
            }
        } catch {
            print("Failed to cache image: \(error)")
        }
    }
    
    /// Loads image from disk cache if available.
    func loadImage(for url: URL) -> Image? {
        let filename = url.lastPathComponent
        let fileURL = cacheDirectory.appendingPathComponent(filename)
        
        // Return memory cache first
        if let cached = memoryCache[filename] {
            return cached
        }
        
        if let data = try? Data(contentsOf: fileURL),
           let uiImage = UIImage(data: data) {
            let image = Image(uiImage: uiImage)
            memoryCache[filename] = image
            return image
        }
        return nil
    }
    
    /// Checks if image exists in disk cache.
    func hasImage(for url: URL) -> Bool {
        let filename = url.lastPathComponent
        let fileURL = cacheDirectory.appendingPathComponent(filename)
        return fileManager.fileExists(atPath: fileURL.path)
    }
}
