import SwiftUI

struct PlayerControls: View {

    let player: PlayerManager

    var body: some View {

        VStack {

            Text(player.currentSong?.title ?? "Nothing Playing")
                .font(.headline)

            HStack {

                Text(player.formatTime(player.currentTime))

                Slider(
                    value: Binding(
                        get: {
                            player.currentTime
                        },
                        set: { newValue in
                            player.currentTime = newValue
                        }
                    ),
                    in: 0...max(player.duration, 1),
                    onEditingChanged: { editing in

                        if !editing {
                            player.seek(to: player.currentTime)
                        }

                    }
                )

                Text(player.formatTime(player.duration))

            }

            HStack(spacing: 40) {

                Button {

                    player.previous()

                } label: {

                    Image(systemName: "backward.fill")

                }

                Button {

                    player.togglePlayPause()

                } label: {

                    Image(systemName:
                            player.isPlaying
                            ? "pause.circle.fill"
                            : "play.circle.fill")
                    .font(.system(size: 45))

                }

                Button {

                    player.next()

                } label: {

                    Image(systemName: "forward.fill")

                }

            }

            .font(.title2)

        }

        .padding()

    }

}
