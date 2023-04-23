import TokamakDOM

@main
struct TokamakApp: App {
    var body: some Scene {
        WindowGroup("Tokamak App") {
            MainView<MainAdapter>()
                .environmentObject(MainAdapter(dependency: .live))
        }
    }
}
