import TokamakDOM

@main
struct TokamakApp: App {
    var body: some Scene {
        WindowGroup("Tokamak App") {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State var count = 0

    var body: some View {
        VStack {
            Text("Hello from swift!")

            Text("Counter: \(count)")

            Button("Tap this!") {
                count += 1
            }
        }
    }
}
