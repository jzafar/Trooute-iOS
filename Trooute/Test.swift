import SwiftUI

struct ContentView1: View {
    var body: some View {
        Button(action: {
            print("Button tapped!")
        }) {
            Text("-")
                .font(.largeTitle)
                .foregroundColor(Color("TitleColor"))
                .frame(width: 40, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.lightBlue)
                )
        }
    }
}


struct UserCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView1()
    }
}
