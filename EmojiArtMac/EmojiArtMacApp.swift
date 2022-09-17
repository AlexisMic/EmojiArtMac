//
//  EmojiArtMacApp.swift
//  EmojiArtMac
//
//  Created by Alexis Schotte on 9/17/22.
//

import SwiftUI

@main
struct EmojiArtMacApp: App {
    @StateObject var paletteStore = PaletteStore(name: "Default")
    
    var body: some Scene {
        DocumentGroup(newDocument: { EmojiArtMacDocument() }) { config in
            EmojiArtDocumentView(document: config.document)
                .environmentObject(paletteStore)
        }
    }
}
