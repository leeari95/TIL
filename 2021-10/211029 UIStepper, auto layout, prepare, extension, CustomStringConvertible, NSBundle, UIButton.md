# TIL (Today I Learned)

10월 28일 (목)

## 학습 내용
오늘은 이번 스텝에서 사용해봤던 UILabel, UIButton에 대해서 정리해보고, 다음 스텝에서 사용하게 될 UIStepper에 대한 튜토리얼을 만들어보았다. 그리고 피드백이 와서 제이티와 함께 피드백에 대해서 의논하였고 리뷰어인 흰과 코드에 대해서 이야기를 나누고 싶어서 약속을 잡게되었다. 이후 오토레이아웃을 복습해보았다. 그리고 피드백 코멘트 중 이해가 안되는 부분이 있어 저녁에 리뷰어인 흰과 함께 약속을 잡아서 코드를 보면서 이야기를 나누기로 하였다.

&nbsp;

## 문제점 / 고민한 점
- 구글링 해봤는데 은근 UIStepper에 대한 글이 별로 없었다. 
- 오토레이아웃은 배워서 정리해본 적이 있었는데 안써먹다보니 다 까먹었다.. 
- 제이티와 의논하다가 prepare라는 메서드를 알고있기는 하지만 정확히 어떤 역할을 하는지 모르고 있었다는 사실을 깨달았다.
- 다음 스텝에서 오토 레이아웃을 설정해야하는데 프로젝트에 이미 구현되어있는 것 같아서 어떤것을 설정해야하는지 감이 오질않았는데, 디바이스를 1세대 SE로 바꿔보니 경고가 떠서 찾아보았다.
- ViewController의 가독성을 높히는 방법은 뭐가 있을까?
- 전역변수를 어떻게 관리하면 좋을까?
- CustomStringConvertible의 용도를 다시한번 생각해보자.
- `OK`나 `Cancel` 같은 단어를 다국어로 현지화해서 번역해주는 기능이 있는데, 어떻게 작성해야 구현할 수 있는지를 모르겠다.

&nbsp;
## 해결방법
- `Stepper`에 대한 튜토리얼을 만들어보면서 사용법도 익혀보았다.
- 야곰의 오토 레이아웃 정복 강의를 보기 시작했다. 복습하는 느낌으로 다시 꼼꼼히 봐야겠다.
- prepare라는 메서드의 예제를 만들어보았다.
- 경고 문구는 다음과 같았다. "set vertical compression resistance priority to 751" 그리고 스택오버플로우에서 해결방안을 찾았는데 영어가 안되서 정확히 뭔말을 하는건지는 이해를 못했다. 근데 어떤 방식으로 해결해나가야하는지 감은 잡혔다.
- 열심히 찾아본 결과 extension으로 ViewController를 분리해주는 방법을 알아냈다. 분류만 잘한다면 가독성 향상에 도움을 줄 것 같다.
- 리뷰어인 흰이 조언을 해주었는데, enum에 static 변수를 추가해서 관리하는 방식을 알아냈다.
    ```swift
    private enum Const {
        static let defaultFruitCount = 10
    }
    ```
- 난 이제까지 rawValue를 사용하기 위해서 해당 프로토콜을 쓰고 있었는데, 프로토콜의 사용의도와는 다르게 활용을 하고 있었다. 보통 인스턴스를 문자열보간법을 이용해서 String으로 반환하고 싶을 때 사용하는 프로토콜이였다. 그동안 어색한 방법으로 활용하려고 했다는 사실을 깨달았다.
    ```swift
    extension Point: CustomStringConvertible {
        var description: String {
            return "(\(x), \(y))"
        }
    }
    ```
- NSBundle을 이용한다면 해결할 수 있었다. 제이티가 찾아내서 사용한 방법인데 우리 둘다 정확하게 어떤 식으로 구현되는지 간단히 읽어보기만 하였고 좀더 Bundle에 대한 타입에 대해서 공부가 필요할 것 같다. 
    ```swift
    enum Text {
        case cancel
        case ok

        var title: String {
            return localizedTitle(key: self.key)
        }

        private var key: String {
            switch self {
            case .cancel:
                return "Cancel"
            case .ok:
                return "OK"
            }
        }

        private func localizedTitle(key: String) -> String {
            let bundle = Bundle.init(for: UIButton.self)
            let title = bundle.localizedString(forKey: key, value: nil, table: nil)
            return title
        }
    }
    ```

&nbsp;

## 오늘의 깨달음
```swift
class MyButton: UIButton {
    var juice: Juice?
}

@IBOutlet weak var orderStrawberryBananaJuiceButton: MyButton! {
    didSet {
        orderStrawberryBananaJuiceButton.juice = .strawberryBanana
    }
}
```
- 위 코드는 `제이티`가 리뷰어 `흰`이 어떤 내용으로 조언을 해준건지 이해하지 못한 나에게 코드로 설명해주려고 작성해준 코드인데, UIButton을 상속받아서 **커스텀한 새로운 UIButton 타입**을 만들 수 있었다. 이런식으로 구현한다면 Switch문을 이용해서 어떤 버튼이 들어올지 형변환을 해주는 번거로움이 줄어들겠다. 버튼에 이미 어떤 쥬스버튼인지 정의되어있으니 말이다. 이 방법이 좋지 못하다고 판단해서 코드로 옮기지는 않았지만, 언젠가 UIKit에 적응되고나면 더 좋은 코드를 작성할 수 있으리라 믿는다! 열심히 공부하자!!!!
- 현업에서는 스토리보드를 잘 쓰지 않는다는 사실을 알았다. 서로 충돌나서 꼬일 뿐만 아니라, 코드로 구현하는 것이 더 직관적이고 관리하기도 편하다는 이유에서였다. 스토리보드에만 의존하지말고 코드로 작성해보는 것도 꼭 공부해야겠다.
- 그리고 리뷰어와 코멘트로 즉, 글로 대화하는 것 보다는 시간을 맞춰서 직접 이야기를 나누는 것이 훠어어어어어얼씬!!!! 도움이 많이된다. 이것저것 꿀팁들도 많이 얻고... 앞으로 이해안가는게 있으면 적극적!!!으로 물어봐야겠다. (그동안 바쁜분 붙잡고 물어보기가 뭔가 죄송스러워서... 소극적이였다.)

---

- 참고링크
    - [UIButton](https://developer.apple.com/documentation/uikit/uibutton)
    - [UIStepper](https://developer.apple.com/documentation/uikit/uilabel)
    - [UILabel](https://developer.apple.com/documentation/uikit/uibutton)
    - [set vertical compression resistance priority...](https://stackoverflow.com/questions/54919329/set-vertical-compression-resistance-priority-to-749-for-uitableviewcell)
    - [extension으로 코드 가독성 올리기](https://gwangyonglee.tistory.com/38)
    - [Bundle로 다국어 지원기능 구현](https://stackoverflow.com/questions/6909885/how-to-use-uikit-localized-string-in-my-app)

- 글쓰기
    - [UIStepper Tutorial](https://leeari95.tistory.com/58)
    - [prepare](https://leeari95.tistory.com/59)
