import SwiftUI

struct MenuItem: Identifiable {
    let id = UUID()
    let name, emoji, price, category: String
}

struct ContentView: View {
    let items = AppConfig.menuItems.map { MenuItem(name: $0.name, emoji: $0.emoji, price: $0.price, category: $0.category) }
    @State private var selectedCat = "الكل"
    @State private var searchText  = ""

    var categories: [String] {
        ["الكل"] + Array(Set(items.map(\.category))).sorted()
    }
    var filtered: [MenuItem] {
        items.filter {
            (selectedCat == "الكل" || $0.category == selectedCat) &&
            (searchText.isEmpty || $0.name.contains(searchText))
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 6) {
                    Text("🍽️").font(.system(size: 48))
                    Text(AppConfig.restaurantName)
                        .font(.system(size: 22, weight: .bold, design: AppConfig.fontDesign))
                    Text(AppConfig.restaurantTagline)
                        .font(.system(size: 13, design: AppConfig.fontDesign))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(LinearGradient(colors: [AppConfig.primaryColor.opacity(0.12), .clear], startPoint: .top, endPoint: .bottom))

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(categories, id: \.self) { cat in
                            Button(cat) { selectedCat = cat }
                                .buttonStyle(.plain)
                                .font(.system(size: 13, weight: .semibold, design: AppConfig.fontDesign))
                                .padding(.horizontal, 16).padding(.vertical, 8)
                                .background(selectedCat == cat ? AppConfig.primaryColor : Color(.systemGray6))
                                .foregroundColor(selectedCat == cat ? .white : .primary)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal).padding(.vertical, 10)
                }

                List(filtered) { item in
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppConfig.primaryColor.opacity(0.12))
                                .frame(width: 52, height: 52)
                            Text(item.emoji).font(.system(size: 26))
                        }
                        VStack(alignment: .leading, spacing: 3) {
                            Text(item.name).font(.system(size: 15, weight: .semibold, design: AppConfig.fontDesign))
                            Text(item.category).font(.system(size: 12, design: AppConfig.fontDesign)).foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("\\(item.price) ر.س")
                            .font(.system(size: 14, weight: .bold, design: AppConfig.fontDesign))
                            .foregroundColor(AppConfig.accentColor)
                    }
                    .padding(.vertical, 6)
                }
                .listStyle(.plain)
            }
            .navigationTitle("").navigationBarHidden(true)
            .searchable(text: $searchText, prompt: "ابحث في القائمة...")
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}
