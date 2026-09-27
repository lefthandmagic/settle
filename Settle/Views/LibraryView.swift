import SwiftUI

struct LibraryView: View {
    var avatar: Avatar
    var initialFilter: String = "All"

    @State private var filter = "All"

    private let ink = SettleColor.ink

    private var shown: [Exercise] {
        if filter == "All" { return Library.all }
        if let module = Module(rawValue: filter) { return Library.session(module) }
        if let muscle = Muscle.allCases.first(where: { $0.rawValue == filter }) {
            return Library.matching(muscle)
        }
        return Library.all
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                chipRow(["All"] + Module.allCases.map(\.rawValue))
                chipRow(Muscle.allCases.map(\.rawValue))

                if !shown.isEmpty {
                    NavigationLink {
                        SessionView(exercises: shown, title: filter, avatar: avatar)
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
                        ExerciseDetailView(exercise: item, avatar: avatar)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                                .font(.body.weight(.semibold))
                            Text(item.muscleLine)
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
        .onAppear {
            if filter == "All", initialFilter != "All" {
                filter = initialFilter
            }
        }
    }

    private func chipRow(_ chips: [String]) -> some View {
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
    }
}

struct ExerciseDetailView: View {
    var exercise: Exercise
    var avatar: Avatar

    private let ink = SettleColor.ink

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                LoopingVideo(name: exercise.clip(avatar))
                    .frame(maxWidth: .infinity)
                    .frame(height: 320)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text(exercise.cue)
                    .font(.title3)
                    .foregroundStyle(ink)
                    .fixedSize(horizontal: false, vertical: true)
                Text(exercise.muscleLine)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(ink.opacity(0.7))
                ForEach(exercise.steps, id: \.self) { step in
                    Text(step)
                        .font(.body)
                        .foregroundStyle(ink.opacity(0.75))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(SettleColor.paper.ignoresSafeArea())
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
