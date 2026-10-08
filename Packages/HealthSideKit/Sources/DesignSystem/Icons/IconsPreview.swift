import SwiftUI

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(IconsPreviewItem.all, id: \.name) { item in
                HStack(spacing: 12) {
                    item.image
                        .foregroundStyle(.text.primary)
                    Text(item.name)
                        .font(.footnote)
                        .foregroundStyle(.text.secondary)
                }
            }
            Text("home sizes")
                .font(.headline)
                .foregroundStyle(.text.primary)
            HStack(spacing: 16) {
                ForEach([16, 19, 20, 22], id: \.self) { size in
                    Image.icons.home
                        .resizable()
                        .frame(width: CGFloat(size), height: CGFloat(size))
                        .foregroundStyle(.text.primary)
                }
            }
        }
        .padding(16)
    }
    .background(.bg.base)
}

private struct IconsPreviewItem {
    let name: String
    let image: Image

    static let all = [
        IconsPreviewItem(name: "home", image: .icons.home),
        IconsPreviewItem(name: "documents", image: .icons.documents),
        IconsPreviewItem(name: "user", image: .icons.user),
        IconsPreviewItem(name: "plus", image: .icons.plus),
        IconsPreviewItem(name: "document", image: .icons.document),
        IconsPreviewItem(name: "documentCheck", image: .icons.documentCheck),
        IconsPreviewItem(name: "camera", image: .icons.camera),
        IconsPreviewItem(name: "photo", image: .icons.photo),
        IconsPreviewItem(name: "eye", image: .icons.eye),
        IconsPreviewItem(name: "alertTriangle", image: .icons.alertTriangle),
        IconsPreviewItem(name: "chevronRight", image: .icons.chevronRight),
        IconsPreviewItem(name: "chevronLeft", image: .icons.chevronLeft),
        IconsPreviewItem(name: "close", image: .icons.close),
        IconsPreviewItem(name: "check", image: .icons.check),
        IconsPreviewItem(name: "arrowUp", image: .icons.arrowUp),
        IconsPreviewItem(name: "sparkle", image: .icons.sparkle),
        IconsPreviewItem(name: "mailVerified", image: .icons.mailVerified),
        IconsPreviewItem(name: "clear", image: .icons.clear),
        IconsPreviewItem(name: "lock", image: .icons.lock),
    ]
}
