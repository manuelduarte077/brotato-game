import SwiftUI

struct CategoryIcon: View {
    let category: SubscriptionCategory
    var size: CGFloat = 40
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(category.color).opacity(0.2))
                .frame(width: size, height: size)
            
            Image(systemName: category.icon)
                .font(.system(size: size * 0.4))
                .foregroundColor(Color(category.color))
        }
    }
}

struct CategoryBadge: View {
    let category: SubscriptionCategory
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: category.icon)
                .font(.system(size: 12))
            
            Text(category.rawValue)
                .font(.caption)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(category.color).opacity(0.2))
        .foregroundColor(Color(category.color))
        .cornerRadius(12)
    }
}
