# 220318 UIStoryboard, Spell checking in Xcode, Quick help

# TIL (Today I Learned)

3월 18일 (금)

## 학습 내용

- 코드리뷰 코멘트 보면서 학습
    - 오탈자 손쉽게 찾는 방법
    - 퀵헬프와 문서화 주석?
    - UIStoryboard extension

&nbsp;

## 고민한 점 / 해결 방법

**[스토리보드로 설정한 ViewController 인스턴스를 간결하게 가져오기]**

```swift
func storyboardStart() {
    let storyboard = UIStoryboard(name: Constant.storyboardName, bundle: nil)
    guard let main = storyboard.instantiateViewController(
        withIdentifier: Constant.storyboardID
    ) as? MainViewController else {
        return
    }
    main.viewModel = ProjectListViewModel(coordinator: self)
    navigationController.pushViewController(main, animated: false)
}
```
* 스토리보드를 가져오고, 그 스토리보드 내부에 있는 ViewController를 인스턴스화 해주려면 위와 같이 guard문으로 캐스팅을 해줘야한다.

이 작업을 매번 이렇게 해줄게 아니라, 좀 더 간단하게 해줄 수는 없을까? 하고 방법을 찾아보았다.

```swift
/// case에 해당하는 스토리보드를 반환하는 열거형 타입
enum Storyboard: String {
    case main = "Main"
    case detail = "Detail"
    
    func storyboard() -> UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: nil)
    }
}
```

먼저 위와 같이 스토리보드라는 열거형 타입을 만들어서 각 케이스 별로 스토리보드 name을 rawValue로 가지고 있게 설계한 후, storyboard 메소드를 호출했을 때, 자신이 가지고있는 rawValue를 활용하여 UIStoryboard를 호출하도록 만들어주었다.

```swift
/// Storyboard 타입의 프로퍼티와 associatedtype 타입의 ViewModel을  정의하고 있는 프로토콜
protocol StoryboardCreatable {
    associatedtype ViewModel
    static var storyboard: Storyboard { get }
    var viewModel: ViewModel { get set }
}

extension StoryboardCreatable {
    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }
    /// ViewController 내부에 ViewModel을 할당해주는 메소드
    mutating func configureWithViewModel(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}
```

그리고 ViewController에 채택해줄 StoryboardCreatable 프로토콜을 구현했다.
extension으로 Identifier를 반환하는 프로퍼티와 ViewModel을 할당해주는 메소드를 구현해주었다.


```swift
extension StoryboardCreatable where Self: UIViewController {
    /// 스토리보드에서 ViewController를 가져와서 ViewModel을 주입해주는 메소드
    /// - Parameter viewModel: ViewController에 주입할 ViewModel
    /// - Returns: ViewModel이 할당된 ViewController를 반환한다.
    static func createFromStoryboard(viewModel: ViewModel) -> Self {
        var viewController: Self = UIStoryboard.createViewController()
        viewController.configureWithViewModel(viewModel: viewModel)
        return viewController
    }
}

extension UIStoryboard {
    /// 스토리보드에서 ViewController를 인스턴스화 시켜주는 메소드
    /// - Returns: ViewController를 반환한다.
    static func createViewController<T: StoryboardCreatable>() -> T {
        let storyboard = UIStoryboard(name: T.storyboard.rawValue, bundle: nil)
        let createViewController = storyboard.instantiateViewController(withIdentifier: T.storyboardIdentifier)
        guard let viewController =  createViewController as? T else {
            fatalError("Expected view controller with identifier \(T.storyboardIdentifier)")
        }
        return viewController
    }
}

```

그리고 본격적으로 스토리보드를 통해 ViewController를 인스턴스화 해준 뒤 앞서 만든 configureWithViewModel 메소드를 활용하여 ViewModel을 할당해준 뒤 ViewController를 반환해주는 메소드를 구현해주었다.

```swift
class MainViewController: UIViewController, StoryboardCreatable {
    static var storyboard: Storyboard = .main
```

그리고 ViewController에서는 StoryboardCreatable를 채택해주고 storyboard 프로퍼티만 구현해주면 된다.

코디네이터 내부 메소드는 아래와 같이 단 3줄로 간결해졌다.

```swift
// 리팩토링 전
func storyboardStart() {
    let storyboard = UIStoryboard(name: Constant.storyboardName, bundle: nil)
    guard let main = storyboard.instantiateViewController(
        withIdentifier: Constant.storyboardID
    ) as? MainViewController else {
        return
    }
    main.viewModel = ProjectListViewModel(coordinator: self)
    navigationController.pushViewController(main, animated: false)
}

// 리팩토링 후
func storyboardStart() {
    let viewModel = ProjectListViewModel(coordinator: self) // 뷰모델 생성
    let mainViewController = MainViewController.createFromStoryboard(viewModel: viewModel) // 뷰모델을 전달하여 ViewController 인스턴스화

    navigationController.pushViewController(mainViewController, animated: false)
}
```

---

**[Xcode에서 오탈자를 손쉽게 찾는 방법]**

* 오탈자를 찾고싶은 파일에 접근하고 아래와 같은 경로로 들어가준다.
* Check를 하게되면 Xcode에서 빨간줄로 오탈자를 체크해준다.
![](https://i.imgur.com/I4GmuFW.png)

> 체크 예시

![](https://i.imgur.com/23mGmUZ.png)


### 단축키
`Command` + `;`

---

**[문서화 주석과 퀵헬프]**

### 퀵헬프란?
Xcode에서 래퍼런스 문서의 요약된 내용을 보여주는 기능

### 문서화 주석
변수, 상수, 클래스, 메소드, 함수, 열거형 등을 설명할 경우 마크업 문법에 따라 주석을 작성하면 다른 프로그래머가 '퀵헬프'를 통해 해당 내용을 확인할 수 있다.
형식을 맞추는 일은 번거롭지만 문서화에 큰 도움이 되므로 사용할 것을 권장한다.

### 문서화 주석 생성 단축키
- `Command` + `Option` + `/`
- 문서화 주석에서 한줄 주석은 슬래시 세개, 여러줄 주석은 별표 두개를 사용한다.
```swift
// MARK: - 문서화 주석
/// 한 줄 문서화 주석
/**
 여러 줄 문서화 주석
 */
```

### 코드예제

```swift
    /**
     자기 자신을 제외한 나머지 case들의 description을 문자열 배열 형태로 반환합니다.
     
     예시로 todo 케이스의 경우 doing과 done의 description이 담긴 문자열 배열이 반환됩니다.
     ````
     let array = ProjectState.todo.excluded // ["DOING", "DONE"]
     ````
     */
    var excluded: [String] {
        switch self {
        case .todo:
            return [ProjectState.doing.description, ProjectState.done.description]
        case .doing:
            return [ProjectState.todo.description, ProjectState.done.description]
        case .done:
            return [ProjectState.todo.description, ProjectState.doing.description]
        }
    }
```

![](https://i.imgur.com/xUKjujA.png)

### 마크업 문법

- '-', '+', '*' : 원형 글머리 기호 즉, 순서가 없는 리스트를 사용할 수 있다.
• 1. 2. 3. ... : 번호를 붙여서 순서 있는 리스트를 만들 수 있다.
   ※ 번호는 크게 중요하지 않다. 자동으로 번호를 매겨 준다.
• 줄바꿈 : 텍스트 간에 한 줄을 비워놓으면 된다.
• 문단 바꿈 : 바를 세 개 이상 사용하면 긴 줄로 문단을 나눠준다. 
• 텍스트 기울임 : `*[텍스트]*`
• 텍스트 굵게 : `**[텍스트]**`
• 링크 : `[링크 내용](링크 주소)`
• 큰 제목 : 큰 제목으로 사용할 텍스트 밑에 '==' 등호 두 개 쓰기 or # [제목 작성]
• 중간 제목 : 중간 제목으로 사용할 텍스트 밑에 '-' 바 쓰기 or ## [중간 제목 작성] 
• 코드 블록 : 네 칸 이상 들여쓰기 or 강세표(backquote, `)를 세 개 이상 한 쌍으로 묶기

---

**[스토리보드를 쓰지말아야하는 이유]**

### 스토리보드의 장점
* `빠른 초기화`
    * 뷰를 만드는데 오래 걸리지 않는다.
* `시각화`
    * 앱의 흐름을 한눈에 볼 수 있다.
* `낮은 진입장벽`
    * 코드를 몰라도 초보자들이 이쁜 뷰를 만들 수 있다.

### 스토리보드의 한계와 단점
* `생산성`
    * 앱이 점점 커지고 스토리보드 로딩시간이 길어지게 되면 오히려 생산성이 떨어지게 된다.
* `가독성`
    * 스토리보드가 방대하면 읽기도 어려워지고 난잡해보인다.
* `협업 어려움`
    * 스토리보드 파일이 XML 포맷에다가 읽기도 어렵기 때문에 다수의 인원이 수정을 하게되면 Merge Conflict 처리가 큰 어려움으로 작용된다.
* `재사용성`
    * 스토리보드로 만든 뷰는 재사용하기가 어렵다
* `번거로움`
    * 스토리보드로 만든 뷰들을 코드와 연결하기 위해서는 Identifier를 부여해줘야하는데 일일히 연결해주는게 생각보다 번거롭다.

### 코드로 UI를 짜야하는 이유
* 간혹 스토리보드로는 구현 못하는 것들이 있다.
    * 버튼에 Border Radius를 준다던가, 배경에 특정 패턴을 준다던가...
* 코드로 UI를 작성하다보면 API Reference Documentation을 자주 찾아보게 되고 자연스럽게 공식문서와 친해진다.
    * 네비게이션 바, 탭바 컨트롤러 동작 원리 등을 자연스럽게 찾아보게 된다.
* 스토리보드에만 의존하다보면 언젠가는 한계에 직면하게 되고 극복하려면 코드를 써야한다.

### 그렇다면 스토리보드는 언제써야 적절할까?
* 앱이 규모가 크지 않고 복잡하지 않아서 빠르게 만들 수 있을 때
* 스토리보드만으로 만들 수 있고 흐름을 한눈에 보고싶을 때
* 누군가와 협업하지 않고 혼자서 앱을 만들 때


---

- 참고링크
    - https://charmintern.tistory.com/40
    - https://charmintern.tistory.com/41
    - https://zeunny.tistory.com/9
    - 야곰의 스위프트 프로그래밍 3판 70p
    - https://sarunw.com/posts/spell-checking-in-xcode/
    - https://gist.github.com/markcleonard/f1a19b27c00f8e1c82872705c1a06863

