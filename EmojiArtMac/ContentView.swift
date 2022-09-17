//
//  ContentView.swift
//  EmojiArtMac
//
//  Created by Alexis Schotte on 9/17/22.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: EmojiArtMacDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(EmojiArtMacDocument()))
    }
}
