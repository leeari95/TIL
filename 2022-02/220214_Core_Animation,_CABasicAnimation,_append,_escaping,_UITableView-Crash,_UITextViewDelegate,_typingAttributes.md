# 220214 Core Animation, CABasicAnimation, append, escaping, UITableView-Crash, UITextViewDelegate, typingAttributes
# TIL (Today I Learned)

2월 14일 (월)

## 학습 내용

- 월요일 활동학습
    - 오답노트
    - Core Animation
- UITableView Crash 문제해결
    - Thread 1: Attempted to scroll the table view to an out-of-bounds row (0) when there are only 0 rows in section 0.
    - Thread 1: Invalid update: invalid number of rows in section 0
- UITextView - 실시간으로 폰트 변경하는 방법 구현하기

&nbsp;

## 고민한 점 / 해결 방법

**[활동학습 퀴즈 오답노트]**

* Array타입의 append 메서드의 시간복잡도는 항상 O(1)이다.
    * 아니다. 일반적으로는 O(1)이지만 메모리 공간을 재할당해야하는 경우에는 시간복잡도가 O(n)이다.
* SOLID 원칙 복기하기
    * SRP (Single responsibility principle) 
        * 단일 책임 원칙
        * 한 클래스는 하나의 책임만 가져야 한다.
    * OCP (Open/closed principle)
        * 개방-폐쇄 원칙
        * 소프트웨어의 요소는 확장에는 열려있으나 변경에는 닫혀 있어야 한다.
    * LSP (Liskov substitution principle)
        * 리스코프 치환 원칙
        * 프로그램의 객체는 프로그램의 정확성을 깨뜨리지 않으면서 하위 타입의 인스턴스로 바꿀 수 있어야 한다.
    * ISP (Interface segregation principle
        * 인터페이스 분리 원칙
        * 특정 클라이언트를 위한 인터페이스 여러 개가 범용 인터페이스 하나보다 낫다.
    * DIP (Dependency inversion principle)
        * 의존관계 역전 원칙
        * 프로그래머는 "추상화에 의존해야지, 구체화에 의존하면 안된다"
        * 의존성 주입은 이 원칙을 따르는 방법 중 하나다.
* 탈출 클로저를 만들 때 매개변수의 타입은?
    * @escaping () -> Void
        * 애만 되는 줄 알았는데
    * (() -> Void)?
        * 이렇게 옵셔널 형태가 되면 자동으로 escaping 클로저가 된다.

---

**[Relationship between a view's frame and bounds]**

https://developer.apple.com/library/archive/documentation/WindowsViews/Conceptual/ViewPG_iPhoneOS/WindowsandViews/WindowsandViews.html

frame, bounds및 center properties은 다른 property과 별도로 변경할 수 있지만, 한 properties을 변경하면 아래와 같은 방식으로 다른 properties에 영향을 준다.

* frame property를 설정하면 bounds property의 size 값이 frame rectangle의 new size와 일치되도록 변경된다. center property의 값은 frame rectangle의 new center point과 일치하도록 유사하게 변경된다.
* center property를 설정하면 frame의 원점 값이 그에 따라 변경된다.
* bounds property의 size를 설정하면 frame property의 size 값이 bounds rectangle의 new size와 일치하도록 변경된다.

> 기본적으로 view의 frame은 superView의 frame에 잘리지 않는다. </br>
  따라서 superview의 frame 외부에 있는 모든 subviews는 전체적으로 렌더링 된다. </br>
  superview의 clipsToBounds property를 true로 설정하면 이 동작을 변경할 수 있다. </br>
  subviews가 시각적으로 잘려있는지 여부에 관계없이 touch events는 항상 target view의 bounds rectangle을 따른다. </br>
  즉, superview의 bounds rectangle 외부에 있는 view의 일부에서 발생하는 touch events는 해당 view에 전달되지 않는다. </br>

---

**[Core Animation]**

https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/CoreAnimationBasics/CoreAnimationBasics.html#//apple_ref/doc/uid/TP40004514-CH2-SW3

![](https://i.imgur.com/11lMLCn.png)

* CAAnimation
    * 대부분의 애니메이션들을 관리하는 추상 클래스
    * 이게 코어 애니메이션의 전부는 아니지만 주로, 그리고 처음부터 많이 쓰게 될 클래스이다.
    * 상속받은 추상 클래스
        * CAAnimationGroup
        * CAPropertyAnimation (추상클래스)
            * CABasicAnimation
            * CAKeyframeAnimation
        * CATransition

**[Core Animation이란?]**
* 시각적 요소에 대해 그래픽 렌더링 및 구성을 통해 애니메이션을 만드는 프레임워크
* 시작 및 끝 포인트의 매개변수를 구성하고 애니메이션을 구현하면 Task가 자동으로 일을 수행한다.
* 드로잉 작업을 그래픽 하드웨어로 전달하여 레이어 객체가 조작할 수 있도록 렌더링 작업을 가속화해 앱 속도 및 품질의 다운없이 높은 프레임과 자연스러운 애니메이션을 보여준다.
* 
![](https://i.imgur.com/axMWwD0.png)

* 때로는 UiKit에서 원하는 유형의 애니메이션을 수행할 수 없을 수도 있으며, 원하는 효과를 얻을 수 있는 것은 Core Animation으로 직접 드롭다운해야 한다.
* UIKit에서 작업하든 SwiftUI에서 작업하든 관계없이 모든 애니메이션은 결국 이 프레임워크를 통해 렌더링 된다. 작동 방식을 이해한다면 이러한 상위 수준 API로 작업하기 더 쉬워진다.

![](https://i.imgur.com/pDAfuLt.png)

* 코어 애니메이션은 레이어에서 작동한다.
* 뷰의 속성을 애니메이션 및 변경하는데 사용된다. UIView에는 기본 CALayer가 있다.
* 기본적으로 시작 및 중지 위치를 지정한다.
* 레이어에 애니메이션을 추가하면 Core Animation이 나머지 두 상태 사이의 이미지를 보간하고 화면에서 애니메이션을 처리한다.

**[CALayer]**

* 컨텐츠를 관리/조작하는데 사용된다.
* 그래픽 하드웨어로 쉽게 조작할 수 있도록 비트맵으로 컨텐츠를 캡쳐한다.
* 뷰와의 차이는 자체 형태를 정의하지 않는다.
    * 비트맵으로 구성된 상태정보만 관리
    * 레이어가 앱에서 실제 드로잉 작업을 하진 않는다.
    * 변경사항을 가진 애니메이션 트리거시 레이어 비트맵/상태정보 -> 그래픽 하드웨어 전달
    * UIView에 최소 1개씩 있고 렌더링을 담당한다. (자신을 그려줄 레이어)
    * 3D에 구성된 2D (레이어 객체)
    * 레이어는 두가지 유형의 좌표계를 사용하여 애니메이션을 만든다.
        * 점 기반 좌표계
        * 단위 기반 좌표계

![](https://i.imgur.com/bGJxB99.png)

**[Layer Tree의 종류]**

* 코어 애니메이션은 CALayer의 프로퍼티를 직접 건드리지 않고 아래와 같은 3개의 Layer Tree를 가지고 관리
    * Model
        * 해당 레이어의 실제 상태 값
    * Presentation
        * 애니메이션 중에만 관리하며 뷰에 표시되는 현재 상태값을 반영
    * Render
        * 실제 애니메이션을 수행하는 코어 애니메이션 전용

![](https://i.imgur.com/yFYMC1X.png)

* Core Animation의 다양한 프로퍼티
    * https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/AnimatableProperties/AnimatableProperties.html#//apple_ref/doc/uid/TP40004514-CH11-SW1

**[Core Animation 만들어보기 - 직선으로 움직이는 뷰]**

```swift
class ViewController: UIViewController {

    let redView: UIView = {
       let view = UIView(frame: CGRect(x: 20, y: 100, width: 140, height: 100))
        view.backgroundColor = .systemRed
        return view
    }()
    
    let button: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Animate", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(redView)
        view.addSubview(button)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .primaryActionTriggered)
        
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: button.bottomAnchor, multiplier: 2),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func animate() {
        let animation = CABasicAnimation()
        animation.keyPath = "position.x" // keyPath를 사용하여 어떤 애니메이션을 만들고 싶은지 알린다.
        // 애니메이션의 시작 및 종료상태를 정의한다.
        animation.fromValue = 20 + 140 / 2
        animation.toValue = 300
        animation.duration = 1
        /*
         이해하기 까다로운 점은 shapes position 또는
         anchor point의 코어 애니메이션 작업이다.
         position은 도형 중간이다.
         따라서 rectangle을 왼쪽에서 오른쪽으로 이동하려면
         먼저 rectangle의 가운데 x점 값을 계산한 다음
         직사각형의 가운데 마지막 x 위치를 계산하여
         fromValue와 toValue로 만들어야 한다.
         */

        redView.layer.add(animation, forKey: "basic") // 뷰의 레이어에 애니메이션을 추가
        redView.layer.position = CGPoint(x: 300, y: 100 + 100/2) // 최종 애니메이션의 위치를 업데이트

        /*
         이 마지막 단계는 매우 중요합니다.
         앞서 언급한 바와 같이 Core Animation는 모델 레이어(현재 상태)과 프레젠테이션 레이어(애니메이션 상태)의 두 가지 레이어을 유지합니다.
         그리고 애니메이션이 끝나면 final presentation state를 반영하여 model state를 업데이트해야 합니다.
         */
    }
}
```

---

**[UITableView Cell을 selectRow를 호출했을 때 발생한 Crash]**

> UITableView의 selectRow를 통해 Select를 시도했을 때, 아래와 같은 에러가 나면서 Crash가 발생했다.
```
Thread 1: 
"Attempted to scroll the table view to an out-of-bounds row (0) when there are only 0 rows in section 0. 
Table view: <UITableView: 0x13f031400; 
frame = (0 0; 420 834); 
clipsToBounds = YES; 
autoresize = W+H; gestureRecognizers = <NSArray: 0x600000031680>;
layer = <CALayer: 0x600000ec7b80>; contentOffset: {0, -74}; 
contentSize: {420, 72.5}; adjustedContentInset: {74, 0, 20, 0}; 
dataSource: <CloudNotes.MemoListViewController: 0x14880fad0>>"
```

* `상황` 메모장의 마지막 남은 셀을 지우게 되면서 selectRow가 호출이 되는 상황이였다.
* `이유` **셀을 지우고 난 후**니까 UITableView에 보여줄 데이터가 존재하지 않고, Cell도 존재하지 않는 상황이였는데, `존재하지 않는 셀`을 `Select`를 하려고 해서 크래쉬가 난 것이였다.
* `해결` 따라서 Select를 하기 전에 먼저 UITableView에 `numberOfRows(inSection:)` 메소드를 통해 해당 값이 0이 아닐 경우에만 seletRow를 호출할 수 있도록 guard문을 추가하여 해결해주었다.

```swift
func updateData(at index: Int) {
    guard self.tableView.numberOfRows(inSection: .zero) != .zero else {
        return
    }
    ...
    tableView.selectRow(at: IndexPath(row: .zero, section: .zero), animated: false, scrollPosition: .middle)
}
```

---

**[UITableView의 Cell을 deleteRows로 지웠을 때 발생한 Crash]**

> 메모장의 데이터를 JSON으로 파싱한 샘플 모델에서 Core Data로 리팩토링하는 과정에서 난 에러였다.
```
Thread 1: 
"Invalid update: invalid number of rows in section 0. 
The number of rows contained in an existing section after the update (15) must be equal to the number of rows contained in that section before the update (15), plus or minus the number of rows inserted or deleted from that section (0 inserted, 1 deleted) and plus or minus the number of rows moved into or out of that section (0 moved in, 0 moved out).
 Table view: 
<UITableView: 0x11081d400;
 frame = (0 0; 420 1194); 
clipsToBounds = YES; 
autoresize = W+H; 
gestureRecognizers = <NSArray: 0x6000033708a0>; layer = <CALayer: 0x600003d8cb40>; 
contentOffset: {0, -74}; 
contentSize: {420, 1160}; 
adjustedContentInset: {74, 0, 20, 0};
 dataSource: <CloudNotes.NotesViewController: 0x12a808ee0>>"
```
- `상황` 테이블 뷰의 `섹션의 행 개수`와 `실제 보여줄 섹션 개수`가 맞지 않아서 발생하는 오류이다.
- `이유` 테이블뷰의 셀을 삭제하면서 테이블뷰에 보여줄 데이터도 동일하게 삭제처리를 해주어야 하는데, 누락되서 발생한 것이였다.
- `해결` 셀을 `추가`, `삭제`할 때 테이블뷰에 보여줄 섹션의 개수도 동일할 수 있도록 PersistentManager의 notes 관리(배열 요소 제거, 코어데이터 요소 제거)도 빼먹지 않도록 해주었다.

---

**[UITextView - 실시간으로 폰트 변경하는 방법 구현하기]**

> 메모장 앱 구현 시 맨 첫줄에는 큰 제목이, 그 아래부터는 본문 글꼴로 설정하여 제목과 내용을 구분해줄 수 있는 방법은 무엇인지 찾아보았다.

> UITextViewDelegate - [textView(_:shouldChangeTextIn:replacementText:)](https://developer.apple.com/documentation/uikit/uitextviewdelegate/1618630-textview) 메소드를 활용하여 해결해보았다.
```swift
func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let currentText = textView.text as NSString // 타이핑 후 텍스트
    let titleRange = currentText.range(of: Constant.lineBreak.description) // title의 range를 linebreak를 활용하여 구한다.
    if titleRange.location < range.location { // title의 location과 전체 텍스트의 location을 비교
        textView.typingAttributes = Constant.bodyAttributes // title보다 전체 텍스트의 location이 크다면
    } else {
        textView.typingAttributes = Constant.headerAttributes // title의 location이 전체 텍스트보다 크다면
    }
    return true
}
```
 텍스트를 입력할 때마다 title의 location과 전체 텍스트의 location을 비교하여 typingAttributes를 할당해주도록 분기처리하였다.

---

- 참고링크
    - https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/CoreAnimationBasics/CoreAnimationBasics.html#//apple_ref/doc/uid/TP40004514-CH2-SW3
    - https://www.youtube.com/watch?v=93bfh3GK79s
    - https://hartl.co/2015/05/21/Highlight-first-line.html
    - https://green1229.tistory.com/76
