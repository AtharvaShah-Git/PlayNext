import SwiftUI
import Observation

struct ContentView: View {
    
    @State private var player = PlayerManager()
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // Toolbar
            
            HStack {
                
                HStack {

                    Image("PlayNextLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)

                    Text("PlayNext by Atharva Shah")
                        .font(.largeTitle.bold())

                }
                
                Spacer()
                
                Button {
                    
                    player.selectMusicFolder()
                    
                } label: {
                    
                    Label("Open Folder",
                          systemImage: "folder")
                    
                }
                
            }
            .padding()
            
            Divider()
            
            HStack(spacing: 0) {
                
                // Library
                
                VStack(alignment: .leading) {
                    
                    Text("Library")
                        .font(.headline)
                        .padding()
                    
                    List(player.songs) { song in
                        
                        SongRow(
                            player: player,
                            song: song
                        )
                        
                    }
                    
                }
                
                Divider()
                
                // Queue
                
                VStack(alignment: .leading) {
                    
                    Text("Up Next")
                        .font(.headline)
                        .padding()
                    
                    QueueView(player: player)
                    
                }
                
            }
            
            Divider()
            
            PlayerControls(player: player)
            
        }
        .frame(minWidth: 900,
               minHeight: 650)
    }
}

#Preview {
    ContentView()
}
