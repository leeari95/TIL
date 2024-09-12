# 240912 SwiftUI, TextField, TextView, ScrollView, TableView, Dynamic height


스유에서 동적으로 늘어나는 텍스트뷰 높이에 따라 스크롤 가능한 뷰의 높이도 동적으로 조정하는 법


9월 12일 (목)


# 학습내용

- UITableView를 활용하여 동적 높이의 스크롤 뷰를 구현하기
- 동적 높이 기능을 가진 텍스트뷰 구현하기
- 삽질...


# 고민한 점 / 해결방법

회사 프로젝트인... 즉 UIKit 베이스 프로젝트에서 조금씩 SwiftUI를 도입하기 시작했다.
정보를 수정하는 화면을 구현하는 도중에 삽질한 내용을 기록해보려고 한다.
스펙 조건은 텍스트뷰가 입력 내용만큼 동적으로 높이가 늘어나고, 
그에 따라 스크롤뷰의 높이도 늘어나게 되면서...
입력 커서의 포커싱도 화면 밖으로 나가지 않도록 사용성 문제를 해결하기 위해 삽질을 하게 되었다.

## 내가 시도한 방법들

### 1. `ScrollView`, `ScrollViewReader` 활용

* SwiftUI의 `ScrollView`, `ScrollViewReader`를 사용하여 텍스트 필드나 텍스트뷰의 Focused 여부에 따라 스크롤 해주도록 하는 방법이다.
* 그러나 Focused 된 이후로 텍스트뷰의 경우는 높이가 늘어날때 커서에 맞춰 스크롤도 되야하는데, 계속 늘어나는 높이에도 불구하고 스크롤 offSet은 그대로라서 내가 입력한 글자가 화면 밖으로 탈출하는 현상이 나타났다.

### 2. `UIScrollView`를 래핑해서 사용하기

* `UIViewControllerRepresentable`를 활용하여 UIScrollView를 래핑해서 해결해보려고 했다.
  * 이유는 UIScrollView의 경우 레이아웃 제약조건만 잘 설정해줘도 텍스트 필드나 텍스트뷰에 따라 알아서 스크롤도 자연스럽게 동작하기 때문이다.
* 하지만 어째서인지.. SwiftUI 환경에서는 내가 원하던 동작이 제대로 동작하지 않았다.
* 그래서 `UIScrollViewDelegate`와 `Notification`을 활용해서 키보드의 높이에 따라 `scrollView.contentInset.bottom`을 조정해주었다.
* 텍스트뷰를 탭한 후에 스크롤은 잘 동작했지만, 텍스트뷰의 높이가 늘어날 수록 스크롤이 끝까지 내려가지 않았다.
* 알고보니... 스크롤뷰의 높이는 동적으로 늘어나지 않고 있었던 것이였다. 그래서 텍스트뷰가 스크롤뷰 바깥으로 탈출하는 현상이 나타났다.
* 레이아웃 제약조건을 높이가 동적으로 늘어나도록 세팅했는데도 해결되지 않았다...
  * [https://stackoverflow.com/questions/62853846/uiscrollview-in-swiftui-with-dynamic-content-wrong-length](https://stackoverflow.com/questions/62853846/uiscrollview-in-swiftui-with-dynamic-content-wrong-length)

이 방법은 내가 구현을 잘못한건지 아니면 원래 래핑해서 쓰면 발생하는 문제인지 더 파악이 필요할 것 같다.

### 3. 최종... `UITableView` 래핑해서 사용하기

* `UIScrollView` 가지고 열심히 삽질을 몇시간동안 하다가... 감이 잡히지 않아서 SwiftUI 톡방에 조언을 구했다.
* UITableView를 래핑해서 활용해보라는 조언을 듣고 몇시간 전에 봤던 레포가 생각이 났다.
  * [https://github.com/exyte/Chat](https://github.com/exyte/Chat)
* UITableView를 활용해서 ChatView를 리스트 형태로 띄워주는데, 채팅 메시지 내용에 따라 높이가 동적으로 늘어나도록 구현되어져 있다.
* 그래서 이를 참고해서 UITablewView를 래핑했고, 키보드가 올라올 때 `contentInset.bottom`을 조정해주었다.

이 방법으로 해결하긴 했으나, 특정 버튼을 누를 때 뷰가 펼쳐지는 기능이 있는데,
이때 뷰가 그려질 때마다 애니메이션 동작이 불필요하게 발생되는 사이드 이펙트가 있어서
이를 대응하는 코드를 적어야 했다.

```swift
// View 코드...
.onChange(of: shouldShowAddress) { shouldShowAddress in
    UIView.setAnimationsEnabled(!shouldShowAddress)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
        UIView.setAnimationsEnabled(true)
    }
}
```

그래서 만든 최종 래핑 코드다:

```swift
import Combine
import SwiftUI
import UIKit

struct KeyboardAwareScrollView<Content: View>: UIViewRepresentable {

    @StateObject private var keyboardState = KeyboardState()

    @Binding var shouldScrollToTop: () -> Void

    let mainBackgroundColor: Color
    let content: Content

    init(shouldScrollToTop: Binding<() -> Void>,
         mainBackgroundColor: Color,
         content: () -> Content) {
        self._shouldScrollToTop = shouldScrollToTop
        self.mainBackgroundColor = mainBackgroundColor
        self.content = content()
    }

    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.dataSource = context.coordinator
        tableView.delegate = context.coordinator
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor(mainBackgroundColor)
        tableView.contentInset = .zero

        DispatchQueue.main.async {
            shouldScrollToTop = {
                tableView.contentOffset = CGPoint(x: 0, y: tableView.contentSize.height - tableView.frame.height)
                tableView.endEditing(true)
            }
        }

        return tableView
    }

    func updateUIView(_ tableView: UITableView, context: Context) {
        DispatchQueue.main.async {
            let inset: CGFloat = 49 + 16 + 16 + 6 + 40 // 하단 버튼이랑 하단 뷰 가려지지 않도록 inset을 줌...
            tableView.contentInset.bottom = keyboardState.isShown ? inset : 0
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, mainBackgroundColor: mainBackgroundColor)
    }

    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        let parent: KeyboardAwareScrollView
        let mainBackgroundColor: Color

        init(_ parent: KeyboardAwareScrollView, mainBackgroundColor: Color) {
            self.parent = parent
            self.mainBackgroundColor = mainBackgroundColor
        }

        func numberOfSections(in tableView: UITableView) -> Int {
            1
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            tableViewCell.selectionStyle = .none
            tableViewCell.backgroundColor = UIColor(mainBackgroundColor)

            if #available(iOS 16.0, *) {
                tableViewCell.contentConfiguration = UIHostingConfiguration {
                    parent.content
                }
                .minSize(width: 0, height: 0)
                .margins(.all, 0)
            } else {
                return UITableViewCell()
            }

            return tableViewCell
        }

        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            return nil
        }

        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            return nil
        }

        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 0.1
        }

        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 0.1
        }
    }
}

public final class KeyboardState: ObservableObject {
    @Published private(set) public var isShown: Bool = false

    private var subscriptions = Set<AnyCancellable>()

    init() {
        subscribeKeyboardNotifications()
    }
}

private extension KeyboardState {
    func subscribeKeyboardNotifications() {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },

            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .receive(on: RunLoop.main)
        .assign(to: \.isShown, on: self)
        .store(in: &subscriptions)
    }
}
```

# 느낀점

- 정말.. SwiftUI iOS 15에서 쓸만하다고 들었는데, iOS 16은 되야할 것 같다.
- 이런 자연스러운 UX를 구현하기 위해서 UIKit을 쓸 수 밖에 없다는 현실이 슬프다.
- 온전히 SwiftUI로 이런 당연한 UX도 구현 가능한 날이 언젠가 오겠지...?


---


# 참고 링크

- [https://stackoverflow.com/a/69466458](https://stackoverflow.com/a/69466458)
- [https://github.com/exyte/Chat](https://github.com/exyte/Chat)
- [https://stackoverflow.com/questions/62853846/uiscrollview-in-swiftui-with-dynamic-content-wrong-length](https://stackoverflow.com/questions/62853846/uiscrollview-in-swiftui-with-dynamic-content-wrong-length)