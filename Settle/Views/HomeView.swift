import SwiftUI

struct HomeView: View {
    @AppStorage("myflex.avatar") private var avatarRaw = Avatar.male.rawValue

    private let paper = SettleColor.paper
    private let ink = SettleColor.ink
    private var avatar: Avatar { Avatar(rawValue: avatarRaw) ?? .male }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("MyFlexLife")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(ink)
                    Text("Mobility for where you actually are. Ease off if a hip or your low back pinches.")
                        .font(.body)
                        .foregroundStyle(ink.opacity(0.72))
                        .fixedSize(horizontal: false, vertical: true)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Avatar")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(ink.opacity(0.55))
                        Picker("Avatar", selection: $avatarRaw) {
                            ForEach(Avatar.allCases) { choice in
                                Text(choice.title).tag(choice.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    ForEach(Module.allCases) { module in
                        NavigationLink(value: module) {
                            moduleCard(module)
                        }
                        .buttonStyle(.plain)
                    }

                    NavigationLink {
                        BodyMapView(avatar: avatar)
                    } label: {
                        rowLink(
                            title: "Body map",
                            subtitle: "Front and back, split into muscles"
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        LibraryView(avatar: avatar)
                    } label: {
                        rowLink(
                            title: "Library",
                            subtitle: "\(Library.all.count) movements · filter by muscle"
                        )
                    }
                    .buttonStyle(.plain)

                    Text("Female and male are drawn avatars. A filmed or AI clip can replace each loop later.")
                        .font(.footnote)
                        .foregroundStyle(ink.opacity(0.5))
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(paper.ignoresSafeArea())
            .navigationDestination(for: Module.self) { module in
                SessionView(exercises: Library.session(module), title: module.rawValue, avatar: avatar)
            }
        }
    }

    private func moduleCard(_ module: Module) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(module.rawValue)
                .font(.title2.weight(.bold))
            Text(module.blurb)
                .font(.body)
                .foregroundStyle(ink.opacity(0.7))
            Text("\(module.minutes) min · \(Library.session(module).count) movements")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(ink.opacity(0.55))
        }
        .foregroundStyle(ink)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(SettleColor.card, in: RoundedRectangle(cornerRadius: 20))
    }

    private func rowLink(title: String, subtitle: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title3.weight(.semibold))
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(ink.opacity(0.65))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(ink.opacity(0.4))
        }
        .foregroundStyle(ink)
        .padding(18)
        .background(ink.opacity(0.06), in: RoundedRectangle(cornerRadius: 18))
    }
}

enum SettleColor {
    static let paper = Color(red: 0.961, green: 0.941, blue: 0.902)
    static let ink = Color(red: 0.165, green: 0.267, blue: 0.220)
    static let clay = Color(red: 0.722, green: 0.384, blue: 0.282)
    static let card = Color(red: 0.910, green: 0.878, blue: 0.820)
}
