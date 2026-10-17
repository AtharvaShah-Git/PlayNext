import SwiftUI

struct SongRow: View {

    let player: PlayerManager
    let song: Song

    var body: some View {

        HStack {

            Button {

                player.play(song: song)

            } label: {

                HStack {

                    Image(systemName:
                            player.currentSong == song
                            ? "speaker.wave.2.fill"
                            : "music.note")

                    Text(song.title)

                }

            }
            .buttonStyle(.plain)

            Spacer()

            Button {

                player.playNext(song)

            } label: {

                Image(systemName: "text.insert")

            }
            .buttonStyle(.borderless)

        }

    }

}
