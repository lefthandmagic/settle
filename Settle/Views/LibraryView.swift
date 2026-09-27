import SwiftUI

struct LibraryView: View {
    @State private var filter = "All"

    private let ink = SettleColor.ink
    private var chips: [String] {
        ["All", Place.flight.rawValue, Place.bed.rawValue] + Area.allCases.map(\.rawValue)
    }

    private var shown: [Exercise] {
        Library.all.filter { item in
            switch filter {
            case Place.flight.rawValue: return item.place == .flight
            case Place.bed.rawValue: return item.place == .bed
            case "All": return true
            default: return item.area.rawValue == filter
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(chips, id: \.self) { chip in
                            Button(chip) { filter = chip }
                                .font(.subheadline.weight(.semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(filter == chip ? ink : ink.opacity(0.08), in: Capsule())
                                .foregroundStyle(filter == chip ? SettleColor.paper : ink)
                        }
                    }
                }

                if !shown.isEmpty {
                    NavigationLink {
                        SessionView(exercises: shown, title: filter)
                    } label: {
                        Text("Play these \(shown.count)")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(ink)
                }

                ForEach(shown) { item in
                    NavigationLink {
                        ExerciseDetailView(exercise: item)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                                .font(.body.weight(.semibold))
                            Text("\(item.place.rawValue) · \(item.area.rawValue) · \(item.seconds)s")
                                .font(.subheadline)
                                .foregroundStyle(ink.opacity(0.6))
                        }
                        .foregroundStyle(ink)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
        .background(SettleColor.paper.ignoresSafeArea())
        .navigationTitle("Library")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ExerciseDetailView: View {
    var exercise: Exercise
    private let ink = SettleColor.ink

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                LoopingVideo(name: exercise.video)
                    .frame(maxWidth: .infinity)
                    .frame(height: 320)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text(exercise.cue)
                    .font(.title3)
                    .foregroundStyle(ink)
                    .fixedSize(horizontal: false, vertical: true)
                ForEach(exercise.steps, id: \.self) { step in
                    Text(step)
                        .font(.body)
                        .foregroundStyle(ink.opacity(0.75))
                        .fixedSize(horizontal: false, vertical: true)
                }
                Text("\(exercise.place.rawValue) · \(exercise.area.rawValue)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(ink.opacity(0.5))
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(SettleColor.paper.ignoresSafeArea())
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
