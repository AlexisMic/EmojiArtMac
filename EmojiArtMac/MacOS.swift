//
//  MacOS.swift
//  EmojiArtMac
//
//  Created by Alexis Schotte on 9/17/22.
//

import SwiftUI

typealias UIImage = NSImage

typealias PaletteManager = EmptyView

struct Pasteboard {
    static var imageData: Data? {
        NSPasteboard.general.data(forType: .tiff) ?? NSPasteboard.general.data(forType: .png)
    }
    static var imageURL: URL? {
        (NSURL(from: NSPasteboard.general) as URL?)?.imageURL
    }
}

extension Image {
    init(uiImage: UIImage) {
        self.init(nsImage: uiImage)
    }
}

extension UIImage {
    var imageData: Data? { tiffRepresentation }
}

extension View {
    
    func popoverPadding() -> some View {
        self.padding(.horizontal)
    }
    
    func wrappedInNavigationViewToMakeDismissable(_ dismiss: (() -> Void)?) -> some View {
        self
    }
    
    func paletteControlButtonStyle() -> some View {
        self
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.accentColor)
    }
}

typealias Camera = CantDoItPhotoPicker
typealias PhotoLibrary = CantDoItPhotoPicker


struct CantDoItPhotoPicker: View {
    var handlePickedImage: (UIImage?) -> Void
    
    static let isAvailable = false
    
    var body: some View {
        EmptyView()
    }
}
