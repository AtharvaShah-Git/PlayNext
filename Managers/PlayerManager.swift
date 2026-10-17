import Foundation
import SwiftUI
import Observation
import AVFoundation
import AppKit

@Observable
class PlayerManager: NSObject, AVAudioPlayerDelegate {

    // MARK: - Library

    var songs: [Song] = []

    // MARK: - Queue

    var queue: [Song] = []

    var currentIndex: Int = -1

    // MARK: - Player

    var currentSong: Song?

    var isPlaying = false
    var currentTime: TimeInterval = 0
    var duration: TimeInterval = 0

    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
    // MARK: - Load Music Folder

    func selectMusicFolder() {

        let panel = NSOpenPanel()
        
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.prompt = "Open"

        guard panel.runModal() == .OK,
              let folder = panel.url else {
            return
        }

        loadSongs(from: folder)
    }
    
    private func loadSongs(from folder: URL) {

        let supportedExtensions = [
            "mp3",
            "wav",
            "m4a",
            "aac",
            "aiff",
            "flac"
        ]

        do {

            let files = try FileManager.default.contentsOfDirectory(
                at: folder,
                includingPropertiesForKeys: nil
            )

            songs = files
                .filter {
                    supportedExtensions.contains(
                        $0.pathExtension.lowercased()
                    )
                }
                .map {
                    Song(url: $0)
                }
                .sorted {
                    $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
                }

            queue = songs
            currentIndex = -1
            currentSong = nil

        } catch {

            print("Failed to load songs:", error)

        }

    }
    
    // MARK: - Playback

    func play(song: Song) {

        do {

            audioPlayer = try AVAudioPlayer(contentsOf: song.url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
            duration = audioPlayer?.duration ?? 0
            startTimer()

            currentSong = song
            isPlaying = true

            // Keep queue equal to the library order
            queue = songs

            if let index = queue.firstIndex(of: song) {
                currentIndex = index
            }

        } catch {

            print("Error playing song:", error)

        }

    }
    
    func togglePlayPause() {

        guard let player = audioPlayer else { return }

        if player.isPlaying {
            player.pause()
            timer?.invalidate()
            isPlaying = false
        } else {

            player.play()
            startTimer()
            isPlaying = true

        }

    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer,
                                     successfully flag: Bool) {

        next()
    }
    
    func next() {

        guard currentIndex + 1 < queue.count else {
            return
        }

        currentIndex += 1

        play(song: queue[currentIndex])

    }
    
    func previous() {

        guard currentIndex > 0 else {
            return
        }

        currentIndex -= 1

        play(song: queue[currentIndex])

    }
    
    // MARK: - Play Next
    func playNext(_ song: Song) {
        guard currentIndex >= 0 else {
            play(song: song)
            return
        }
        if let existingIndex = queue.firstIndex(of: song) {
            if existingIndex == currentIndex {
                return
            }
            queue.remove(at: existingIndex)
            if existingIndex < currentIndex {
                currentIndex -= 1
            }
        }
        queue.insert(song, at: currentIndex + 1)
    }
    
    // MARK: - Timer
    
    private func startTimer() {
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 0.25,
                                     repeats: true) { _ in
            guard let player = self.audioPlayer else {
                return
            }
            self.currentTime = player.currentTime
        }
    }
    
    func formatTime(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%d:%02d", minutes, secs)
    }
    
    func seek(to time: TimeInterval) {
        guard let player = audioPlayer else {
            return
        }
        player.currentTime = time
        currentTime = time

    }
}
