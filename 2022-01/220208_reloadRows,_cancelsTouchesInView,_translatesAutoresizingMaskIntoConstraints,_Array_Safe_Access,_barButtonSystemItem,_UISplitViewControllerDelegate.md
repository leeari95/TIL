# 220208 reloadRows, cancelsTouchesInView, translatesAutoresizingMaskIntoConstraints, Array Safe Access, barButtonSystemItem, UISplitViewControllerDelegate
# TIL (Today I Learned)

2월 8일 (화)

## 학습 내용
- 특정 행에 해당되는 셀만 업데이트 하는 방법
- GestureRecognizer를 추가했을 때 tableView Delegate가 먹통인 이유
- translatesAutoresizingMaskIntoConstraints 복습
- 배열의 인덱스 안전하게 조회하는 방법
- barButtonSystemItem
- SplitViewController 인터페이스가 축소되었을 때 primary가 보여지게 설정하기


&nbsp;

## 고민한 점 / 해결 방법

**[특정 행에 해당되는 셀을 업데이트를 해주는 방법]**

* reloadRows(at:with:) 메소드를 활용하여 indexPath를 할당해주면, 그에 맞는 cell만 reload를 실행한다.

```swift
// 사용 예시
func updateData(at index: Int, with data: MemoListInfo) {
    memoListInfo[index] = data
    tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
}
```
---

**[Cell의 Select가 먹히는 문제 해결]**
```swift
extension UIViewController {
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false // 이거 추가하니까 해결댐...
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
```
**[cancelsTouchesInView]**
* Bool 타입의 프로퍼티로 default 값은 true이다.
* Gesture Recognizer가 제스처를 인식하면 나머지 터치정보들을 뷰로 전달하지 않고 이전에 전달된 터치들은 취소된다.
* 하지만 false로 할당한다면 제스처를 인식한 후에도 터치 정보를 뷰에 전달하게 된다.

> **문제가 해결된 이유**
기존에는 cancelsTouchesInView값이 true여서 나머지 터치정보들을 뷰로 전달하지 않고 취소되었기 때문에 TableView의 Select가 먹지 않았던 것이였다. false로 할당해줌으로써 제스처를 인식한 후에도 Gesture Recognizer의 패턴과는 무관하게 터치 정보를 뷰에 전달하게 되어 이 문제가 해결되었던 것이다.

---

**[translatesAutoresizingMaskIntoConstraints]**
* 까묵어서.. 다시 복기하기...
* autoresizingMask는 superview가 변함에 따라 subview의 크기를 어떻게 할것인가이기 때문에, 이와 동일한 기능을 하는 autolayout에서 같이 사용된다면 충돌이 날 수 있는것 > 충돌 방지를 위해 Auturesizing을 사용하지 않는것으로 명시적으로 false를 할당해주는 것이다.

---

**[배열의 인덱스를 안전하게 조회하는 방법]**

* 메모장 앱 구현시 존재하지 않는 인덱스 조회로 인해 앱이 죽어버리는 현상이 발생되어 알아보게 되었다.
* subscript를 추가하여 Collection에 extension을 해주는 방법이다.

```swift
extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
```
* 배열에 접근하려는 인덱스가 유효한지 판단한 뒤 유효할 경우 Element를 반환하고 아닌 경우 nil을 반환하는 메소드이다.

---

**[UIBarButtonItem은 기본 구현되어있는 버튼아이콘이 존재한다.]**

* HIG에 아주 친절하게 표로 안내해주고 있다.
* ![](https://i.imgur.com/6cL2pyo.jpg)
    * https://developer.apple.com/design/human-interface-guidelines/ios/icons-and-images/system-icons/
* 코드로는 아래처럼 접근할 수 있다.
```swift
UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
```

---

**[SplitViewController 인터페이스가 축소되었을 때 primary가 보여지게 설정하기]**

* 아이패드에서 스플릿뷰로 다른 앱과 화면을 같이 쓰는 경우 화면이 작아져서 primary와 secondary뷰가 한번에 보이지 않았다. primary뷰인 메모목록이 먼저 보여지게 하고 싶었는데 secondary뷰인 메모장이 먼저 보여지는 현상이 발생하였다.
* 디폴트 값이 secondary뷰임을 확인하고 primary가 먼저 보여지도록 delegate 메서드를 통해 설정해주었다.
```swift
extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(
        _ svc: UISplitViewController,
        topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column
    ) -> UISplitViewController.Column {
        return .primary
    }
}
```

---

- 참고링크
    - https://yojkim.medium.com/swift%EC%97%90%EC%84%9C-%EC%A2%80-%EB%8D%94-%EC%95%88%EC%A0%84%ED%95%9C-%EB%B0%A9%EB%B2%95%EC%9C%BC%EB%A1%9C-%EB%B0%B0%EC%97%B4%EC%97%90-%EC%A0%91%EA%B7%BC%ED%95%98%EA%B8%B0-47605e7a192b
    - https://baked-corn.tistory.com/130
    - https://violentjy.tistory.com/122
    - https://developer.apple.com/design/human-interface-guidelines/ios/icons-and-images/system-icons
    https://developer.apple.com/documentation/uikit/uisplitviewcontroller
