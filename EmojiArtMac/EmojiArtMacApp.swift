//
//  EmojiArtMacApp.swift
//  EmojiArtMac
//
//  Created by Alexis Schotte on 9/17/22.
//

import SwiftUI

@main
struct EmojiArtMacApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: EmojiArtMacDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
