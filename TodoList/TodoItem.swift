import Foundation

struct TodoItem {
    var title: String
    var isCompleted: Bool
    var deadline: Date?  // Optional, 모든 할 일이 마감 기한을 가질 필요는 없기 때문에
}
