import SwiftUI

struct BodyMapView: View {
    var avatar: Avatar
    @State private var showingBack = false

    private let ink = SettleColor.ink

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Picker("Side", selection: $showingBack) {
                    Text("Front").tag(false)
                    Text("Back").tag(true)
                }
                .pickerStyle(.segmented)

                Text("Tap a region to see the muscles and the movements that use them.")
                    .font(.subheadline)
                    .foregroundStyle(ink.opacity(0.65))

                Group {
                    if showingBack {
                        backFigure
                    } else {
                        frontFigure
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(20)
        }
        .background(SettleColor.paper.ignoresSafeArea())
        .navigationTitle(showingBack ? "Back" : "Front")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var frontFigure: some View {
        VStack(spacing: 8) {
            part("front-neck", width: 72, height: 72, round: true)
            HStack(spacing: 10) {
                part("front-hands", width: 64, height: 64, round: true)
                part("front-shoulders", width: 150, height: 52)
                part("front-hands", width: 64, height: 64, round: true)
            }
            part("front-chest", width: 160, height: 70)
            part("front-core", width: 140, height: 78)
            part("front-hips", width: 168, height: 52)
            HStack(spacing: 18) {
                part("front-thighs", width: 62, height: 96)
                part("front-thighs", width: 62, height: 96)
            }
            HStack(spacing: 22) {
                part("front-calves", width: 52, height: 88)
                part("front-calves", width: 52, height: 88)
            }
        }
    }

    private var backFigure: some View {
        VStack(spacing: 8) {
            part("back-neck", width: 72, height: 72, round: true)
            part("back-upper", width: 210, height: 78)
            part("back-low", width: 150, height: 64)
            part("back-glutes", width: 180, height: 58)
            HStack(spacing: 18) {
                part("back-hams", width: 62, height: 96)
                part("back-hams", width: 62, height: 96)
            }
            HStack(spacing: 22) {
                part("back-calves", width: 52, height: 88)
                part("back-calves", width: 52, height: 88)
            }
        }
    }

    private func part(_ id: String, width: CGFloat, height: CGFloat, round: Bool = false) -> some View {
        let zone = BodyZone.all.first { $0.id == id }
        return NavigationLink {
            if let zone {
                ZoneView(zone: zone, avatar: avatar)
            }
        } label: {
            Text(zone?.name ?? "")
                .font(.caption.weight(.semibold))
                .multilineTextAlignment(.center)
                .foregroundStyle(ink)
                .frame(width: width, height: height)
                .background(SettleColor.card, in: RoundedRectangle(cornerRadius: round ? height / 2 : 18))
        }
        .buttonStyle(.plain)
    }
}

struct ZoneView: View {
    var zone: BodyZone
    var avatar: Avatar

    private let ink = SettleColor.ink

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                ForEach(zone.muscles) { muscle in
                    let moves = Library.matching(muscle)
                    VStack(alignment: .leading, spacing: 8) {
                        NavigationLink {
                            LibraryView(avatar: avatar, initialFilter: muscle.rawValue)
                        } label: {
                            HStack {
                                Text(muscle.rawValue)
                                    .font(.title3.weight(.bold))
                                Spacer()
                                Text("Filter")
                                    .font(.subheadline.weight(.semibold))
                            }
                            .foregroundStyle(ink)
                        }
                        .buttonStyle(.plain)
                        if moves.isEmpty {
                            Text("No movements for this one yet.")
                                .font(.subheadline)
                                .foregroundStyle(ink.opacity(0.55))
                        }
                        ForEach(moves) { item in
                            NavigationLink {
                                ExerciseDetailView(exercise: item, avatar: avatar)
                            } label: {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.name)
                                        .font(.body.weight(.semibold))
                                    Text(item.muscleLine)
                                        .font(.caption)
                                        .foregroundStyle(ink.opacity(0.55))
                                }
                                .foregroundStyle(ink)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 6)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(SettleColor.paper.ignoresSafeArea())
        .navigationTitle(zone.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
