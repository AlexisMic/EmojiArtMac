//
//  EmojiArtMacDocument.swift
//  EmojiArtMac
//
//  Created by Alexis Schotte on 9/17/22.
//

import SwiftUI
import Combine
import UniformTypeIdentifiers

extension UTType {
    static var emojiart: UTType {
        UTType(exportedAs: "edu.stanford.cs193p.emojiart")
    }
}

class EmojiArtMacDocument: ReferenceFileDocument {
        
    static var readableContentTypes: [UTType] {[.emojiart]}
    
    required init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            emojiArt = try EmojiArtModel(json: data)
            fetchBackgroundImageDataIfNecessary()
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    func snapshot(contentType: UTType) throws -> Data {
        return try emojiArt.json()
    }
    
    func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: snapshot)
    }
    
    typealias Background = EmojiArtModel.Background
    typealias Emoji = EmojiArtModel.Emoji
    
    @Published private(set) var emojiArt: EmojiArtModel {
        didSet {
            if emojiArt.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
            }
        }
    }
    
    @Published var selectedEmojis = Set<Emoji>()
    
    init() {
        emojiArt = EmojiArtModel()
    }


    
    var emojis: [Emoji] {
        emojiArt.emojis
    }
    
    var background: Background {
        emojiArt.background
    }
    
    @Published var backgroundImage: UIImage?
    @Published var backgroundImageFetchStatus = BackgroundImageFetchStatus.idle
    
    enum BackgroundImageFetchStatus: Equatable {
        case idle, fetching, failed(URL)
    }
    
    private var backgroundImageCacellables: AnyCancellable?
    
    private func fetchBackgroundImageDataIfNecessary() {
        backgroundImage = nil
        switch emojiArt.background {
        case .url(let url):
            //fetch url
            backgroundImageFetchStatus = .fetching
            backgroundImageCacellables?.cancel()
            let session = URLSession.shared
            let publisher = session.dataTaskPublisher(for: url)
                .map({(data, response) in UIImage(data: data)})
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
            
            backgroundImageCacellables = publisher
                .sink(receiveValue: { [weak self] uiImage in
                    self?.backgroundImage = uiImage
                    self?.backgroundImageFetchStatus = self?.backgroundImage == nil ? .failed(url) : .idle
                })
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        case .blank:
            break
        }
    }
    
    //MARK: Intents
    
    func setBackground(_ background: Background, undoManager: UndoManager?) {
        undoablyPerform(operation: "Set Background", with: undoManager) {
            emojiArt.background = background
        }
    }
    
    func addEmoji(_ text: String, at location: (x: Int, y: Int), size: CGFloat, undoManager: UndoManager?) {
        undoablyPerform(operation: "Add \(text)", with: undoManager) {
            emojiArt.addEmoji(text: text, at: location, size: Int(size))
        }
    }
    
    func removeEmoji(_ emoji: Emoji, undoManager: UndoManager?) {
        undoablyPerform(operation: "Remove", with: undoManager) {
            emojiArt.removeEmoji(emoji)
        }
    }
    
    func moveEmoji(_ emoji: Emoji, by offset: CGSize, undoManager: UndoManager?) {
        if let index = emojis.index(matching: emoji) {
            undoablyPerform(operation: "Move", with: undoManager) {
                emojiArt.emojis[index].x += Int(offset.width)
                emojiArt.emojis[index].y += Int(offset.height)
            }
        }
    }
    
    func scaleEmoji(_ emoji: Emoji, by scale: CGFloat, undoManager: UndoManager?) {
        if let index = emojis.index(matching: emoji) {
            undoablyPerform(operation: "Scale", with: undoManager) {
                emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
            }
        }
    }
    
    //MARK: Undo
    
    private func undoablyPerform(operation: String, with undoManager: UndoManager? = nil, doit: () -> Void) {
        let oldEmojiArt = emojiArt
        doit()
        undoManager?.registerUndo(withTarget: self) { myself in
            myself.undoablyPerform(operation: operation, with:undoManager) {
                myself.emojiArt = oldEmojiArt
            }
        }
        undoManager?.setActionName(operation)
    }
}
