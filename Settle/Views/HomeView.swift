import SwiftUI

struct HomeView: View {
    private let paper = SettleColor.paper
    private let ink = SettleColor.ink

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("MyFlexLife")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(ink)
                    Text("Mobility for the seat and the bed. Ease off if a hip or your low back pinches.")
                        .font(.body)
                        .foregroundStyle(ink.opacity(0.72))
                        .fixedSize(horizontal: false, vertical: true)

                    NavigationLink(value: Place.flight) {
                        placeCard(.flight, count: Library.flight.count)
                    }
                    .buttonStyle(.plain)
                    NavigationLink(value: Place.bed) {
                        placeCard(.bed, count: Library.bed.count)
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        LibraryView()
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Library")
                                    .font(.title3.weight(.semibold))
                                Text("\(Library.all.count) movements, with a loop for each")
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
                    .buttonStyle(.plain)

                    Text("The loops are drawn demos, so you can review the set before any filming.")
                        .font(.footnote)
                        .foregroundStyle(ink.opacity(0.5))
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(paper.ignoresSafeArea())
            .navigationDestination(for: Place.self) { place in
                SessionView(exercises: Library.session(place), title: place.rawValue)
            }
        }
    }

    private func placeCard(_ place: Place, count: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(place.rawValue)
                .font(.title2.weight(.bold))
            Text(place.blurb)
                .font(.body)
                .foregroundStyle(ink.opacity(0.7))
            Text("\(place.minutes) min · \(count) movements")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(ink.opacity(0.55))
        }
        .foregroundStyle(ink)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(SettleColor.card, in: RoundedRectangle(cornerRadius: 20))
    }
}

enum SettleColor {
    static let paper = Color(red: 0.961, green: 0.941, blue: 0.902)
    static let ink = Color(red: 0.165, green: 0.267, blue: 0.220)
    static let clay = Color(red: 0.722, green: 0.384, blue: 0.282)
    static let card = Color(red: 0.910, green: 0.878, blue: 0.820)
}
