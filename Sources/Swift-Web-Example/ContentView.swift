import TokamakDOM
import Foundation

struct MockImage: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [.green, .black]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct SectionTitle: View {
    var title: String

    var body: some View {
        Text(title)
            .font(.title)
            .bold()
            .padding(.leading, 16)
    }
}

struct AlbumItem: View {
    var body: some View {
        VStack(alignment: .leading) {
            MockImage()
                .frame(width: 150, height: 150)

            Text("The Martin Garrix Experi")
                .font(.system(size: 14))
                .bold()
//                .lineLimit(1)

            Text("アルバム・マーティン・ギャリックス")
                .font(.system(size: 12))
//                .lineLimit(2)
//                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(width: 150)
    }
}

struct HighlightButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct RecentItem: View {
    var body: some View {
        Button {
        } label: {
            HStack(spacing: .zero) {
                MockImage()
                    .frame(width: 50, height: 50)

                Text("お気に入りの曲")
                    .font(.system(size: 14))
                    .bold()
                    .padding(.leading, 4)

                Spacer()
            }
            .background(Color.gray)
            .cornerRadius(4)
        }
        .buttonStyle(HighlightButtonStyle())
    }
}

struct MainDataModel {
    var greeting: String = "こんばんは"
}

struct MainView<Adapter: MainAdapterProtocol>: View {
    @EnvironmentObject var adapter: Adapter

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("This UI is built with Swift")
                    .bold()
                    .font(.title2)
                    .padding(.leading, 16)
                    .padding(.top, 32)

                Text("こんばんは")
                    .bold()
                    .font(.title2)
                    .padding(.leading, 16)
                    .padding(.top, 32)

                HStack {
                    Button("音楽") {
                    }
                    .modifier(Hoge())

                    Button("ポッドキャストと音楽") {
                    }
                    .modifier(Hoge())
                }
                .padding(.leading, 16)

                Spacer().frame(height: 16)

                LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                    RecentItem()
                    RecentItem()
                    RecentItem()
                    RecentItem()
                    RecentItem()
                    RecentItem()
                }
                .padding(.horizontal, 16)

                Spacer().frame(height: 32)

                Group {
                    SectionTitle(title: "あなたにおすすめの話題のアルバム")

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            AlbumItem()
                            AlbumItem()
                            AlbumItem()
                            AlbumItem()
                            AlbumItem()
                            AlbumItem()
                        }
                    }
                    .padding(.leading, 16)

                    Spacer().frame(height: 32)
                }

                Group {
                    SectionTitle(title: "ちょっと前のお気に入り")

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            AlbumItem()
                            AlbumItem()
                            AlbumItem()
                            AlbumItem()
                            AlbumItem()
                            AlbumItem()
                        }
                    }
                    .padding(.leading, 16)
                }
            }
        }
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            Text(adapter.state.text)
//            Text("\(ObjectIdentifier(adapter).debugDescription)")
//
//            Button("Show sheet") {
//                adapter.setSheetForBinding(.popup)
//            }
//        }
//        .sheet(item: Binding(
//            get: { adapter.state.sheet },
//            set: { sheet in adapter.setSheetForBinding(sheet) }
//        )) {
//            sheet in sheet.content()
//        }
//        .onAppear {
//            adapter.refresh()
//        }
    }
}

struct Hoge: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(PlainButtonStyle())
            .font(.footnote)
            .padding(.vertical, 4)
            .padding(.horizontal, 12)
            .background(.gray, in: Capsule())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView<MainAdapterMock>()
            .environmentObject(MainAdapterMock())
    }
}

protocol MainAdapterProtocol: ObservableObject {
    var state: MainState { get }

    func refresh()
    func setSheetForBinding(_ sheet: MainSheet?)
}

struct Popup: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.red)
    }
}

enum MainSheet: Identifiable {
    var id: String {
        UUID().uuidString
    }

    case popup

    func content() -> some View {
        switch self {
        case .popup:
            return Popup()
//                .ignoresSafeArea()
        }
    }
}

struct MainState {
    var text: String = "Hello"
    var sheet: MainSheet?
}

struct MainBidirectionalState {
}

final class MainAdapter: MainAdapterProtocol {
    struct Dependency {
        var userRepository: UserRepositoryProtocol

        static var live: Dependency {
            Dependency(
                userRepository: UserRepository()
            )
        }
    }

    @Published private(set) var state = MainState()

    internal init(dependency: Dependency) {
        self.dependency = dependency
    }

    private let dependency: Dependency

    func setSheetForBinding(_ sheet: MainSheet?) {
        state.sheet = sheet
    }

    func refresh() {
        Task { @MainActor in
            state.text = await dependency.userRepository.getMyName()
            state.sheet = .popup
        }
    }
}

final class MainAdapterMock: MainAdapterProtocol {
    var state: MainState = .init(text: "fuga", sheet: nil)

    func refresh() {}
    func setSheetForBinding(_ sheet: MainSheet?) {}
}

protocol UserRepositoryProtocol: AnyObject {
    func getMyName() async -> String
}

final class UserRepository: UserRepositoryProtocol {
    func getMyName() async -> String {
        return "MyName"
    }
}
