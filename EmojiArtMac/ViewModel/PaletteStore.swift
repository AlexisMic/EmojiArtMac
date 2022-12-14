//
//  PaletteStore.swift
//  EmojiArt
//
//  Created by Alexis Schotte on 8/30/22.
//

import SwiftUI

class PaletteStore: ObservableObject {
    
    var name: String
    @Published var palettes: [Palette] = [] {
        didSet {
            storeInUserDefaults()
        }
    }
    
    private var userDefaultsKey: String {
        "PaletteStore:" + name
    }
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(palettes), forKey: userDefaultsKey)
        
//        UserDefaults.standard.set(palettes.map({[$0.name, $0.emojis, String($0.id)]}), forKey: userDefaultsKey)
    }
    
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
        let decodedPalettes = try? JSONDecoder().decode(Array<Palette>.self, from: jsonData) {
            palettes = decodedPalettes
        }
    }
    
    init(name: String) {
        self.name = name
        restoreFromUserDefaults()
        if palettes.isEmpty {
            insertPalette(name: "Vehicles", emojis: "ððððððððŧðððððððâïļðŦðŽðĐððļðēððķâĩïļðĪðĨðģâīðĒððððððððšð")
            insertPalette(name: "Sports", emojis: "ðâūïļðâ―ïļðūððĨðâģïļðĨðĨðâ·ðģ")
            insertPalette(name: "Music", emojis: "ðžðĪðđðŠðĨðšðŠðŠðŧ")
            insertPalette(name: "Animals", emojis: "ðĨðĢðððððððĶððððððĶðĶðĶðĶðĒððĶðĶðĶðððĶðĶðĶ§ðĶĢððĶðĶðŠðŦðĶðĶðĶŽððĶððĶððĐðĶŪððĶĪðĶĒðĶĐððĶðĶĻðĶĄðĶŦðĶĶðĶĨðŋðĶ")
            insertPalette(name: "Animal Faces", emojis: "ðĩððððķðąð­ðđð°ðĶðŧðžðŧââïļðĻðŊðĶðŪð·ðļðē")
            insertPalette(name: "Flora", emojis: "ðēðīðŋâïļððððūðð·ðđðĨðšðļðžðŧ")
            insertPalette(name: "Weather", emojis: "âïļðĪâïļðĨâïļðĶð§âðĐðĻâïļðĻâïļð§ðĶðâïļðŦðŠ")
            insertPalette(name: "COVID", emojis: "ððĶ ð·ðĪ§ðĪ")
            insertPalette(name: "Faces", emojis: "ððððððððĪĢðĨēâšïļððððððððĨ°ðððððððððĪŠðĪĻð§ðĪððĨļðĪĐðĨģððððððâđïļðĢððŦðĐðĨšðĒð­ðĪð ðĄðĪŊðģðĨķðĨððĪðĪðĪ­ðĪŦðĪĨðŽððŊð§ðĨąðīðĪŪð·ðĪ§ðĪðĪ ")
        }
    }
    
    //MARK: Intents
    
    func palette(at index: Int) -> Palette {
        let safeIndex = min(max(index,0), palettes.count - 1)
        return palettes[safeIndex]
    }
    
    @discardableResult
    func removePalette(at index: Int) -> Int {
        if palettes.count > 1, palettes.indices.contains(index) {
            palettes.remove(at: index)
        }
        return index % palettes.count
    }
    
    func insertPalette(name: String, emojis: String? = nil, at index: Int = 0) {
        let uniqueID = (palettes.max(by: {$0.id < $1.id})?.id ?? 0) + 1
        let newPalette = Palette(id: uniqueID, name: name, emojis: emojis ?? "")
        let safeIndex = min(max(index,0), palettes.count)
        palettes.insert(newPalette, at: safeIndex)
    }
    
    
}
