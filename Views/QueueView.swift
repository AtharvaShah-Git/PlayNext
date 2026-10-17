import SwiftUI

struct QueueView: View {

    let player: PlayerManager

    var body: some View {

        List {

            ForEach(Array(player.queue.enumerated()),
                    id: \.element.id) { index, song in

                HStack {

                    Image(systemName:
                            index == player.currentIndex
                            ? "play.fill"
                            : "music.note")

                    Text(song.title)

                }

            }

        }

    }

}
