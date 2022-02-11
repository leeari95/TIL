# 220207 View Drawing Cycle, UISplitViewController이론
# TIL (Today I Learned)

2월 7일 (월)

## 학습 내용
- View Drawing Cycle 활동학습
- UISplitViewController


&nbsp;

## 고민한 점 / 해결 방법

**[View Drawing Cycle]**

> **Drawing Cycle?**
뷰가 로드되거나 변경이 있을 때 화면에 시각적으로 표현되어 그려지는 일종의 사이클

* 뷰 로드 시 시스템이 UIView에게 draw 메소드를 통해 드로잉을 요청
* 뷰의 스냅샷을 캡쳐하여 UIView에게 전달
* 뷰의 컨텐츠 변경시 관련 메소드(setNeedsDisplay, setNeedsLayout...)들을 호출하여 시스템에 업데이트 요청
* Next Drawing Cycle에서 업데이트 요청 받은 뷰를 업데이트

뷰의 스냅샷을 캡쳐하고 뿌려주는 프로세스를 반복하는 과정

## Display
* `draw(_:)`
    * CGRect를 전달받아서 뷰를 그리는 메소드
    * 호출시점: 뷰의 제약 및 레이아웃이 모두 잡힌 후 호출된다.
* `setNeedsDisplay()`
    * 뷰 내부 요소들을 그려줌
    * 호출시점: 드로잉 사이클 시 draw() 호출
* `displayIfNeeded()`
    * 뷰 내부 요소들을 그려주는데, View Drawing Cycle을 기다리지 않고 즉시 실행한다.

## Layout
* `layoutSubviews()`
    * 뷰의 자식뷰들의 위치와 크기를 재조정한다.
    * 이 메소드는 재귀적으로 모든 자식뷰의 layoutSubviews까지 호출해야하기 때문에 실행 시에 부하가 큰 메소드이다.
* `setNeedsLayout()`
    * 뷰의 크기 및 위치를 레이아웃.
    * 호출시점: 드로잉 사이클 시
* `layoutIfNeeded()`
    * 뷰의 크기 및 위치를 레이아웃 시킨다. Cycle을 기다리지 않고 즉시 실행된다.  
    * layoutSubviews를 호출하도록 하는 메소드이다.


## Constraints
* `updateConstraints()`
    * 뷰의 제약조건을 업데이트. 동적으로 변해야하는 제약조건을 구현한다.
    * 호출시점: 최초 실행시 draw보다 이전. 
* `setNeedsUpdateConstraints()`
    * 뷰의 제약조건을 업데이트 하도록 예약한다.
    * setNeedsLayout이나 setNeedsDisplay와 비슷하게 작동한다.
* `updateConstraintsIfNeeded()`
    * 뷰의 제약조건을 즉시 업데이트 한다.
    * layoutIfNeeded 메소드와 유사하다. 그러나 오직 오토레이아웃을 사용하는 뷰에만 유효하다.
* `invalidateIntrinsicContentSize()`
    * 뷰의 크기가 바뀌었을 때 intrinsicContentSize 프로퍼티를 통해 Size를 갱신하고 그에 맞게 오토레이아웃이 업데이트되도록 만들어주는 메소드다.

## 호출순서

![](https://i.imgur.com/7WUpxZI.png)


---

**[SplitView]**

* Master - Detail 인터페이스를 구현하는 컨테이너 뷰 컨트롤러
* primary가 마스터, secondary가 디테일
* Container View 중 하나로 계층형 interface에서 자식뷰컨트롤러들을 관리하는 뷰다.
* 인터페이스 내에서 하나의 뷰컨트롤러의 변경 내용을 다른 뷰컨트롤러 드라이브의 내용을 변경한다.
* Split View interface는 Note 앱과 같은 앱에서 content를 navigation 하는 것과 content를 filtering하는 것에 가장 적합한 interface이다.
* 기본 사이드 바에서 폴더를 선택하면 해당 폴더에 있는 노트목록이 표시되고, 목록에 노트를 선택하면 secondary view에서 특정 노트의 내용이 표시가 된다.

![](https://i.imgur.com/fA5qLom.png)

* UI를 빌드할 때 SplitViewController는 앱 화면의 root view controller이다.
* SplitViewController의 경우 고유한 모양은 없다. 대부분의 모양은 내장되는 하위 ViewController에 의해 정의된다.

> Note
SplitViewController를 네비게이션 스택에 푸쉬할 수 없다. 일부 다른 container View Controller에 하위 뷰컨트롤러로 SplitViewController를 둘 수는 있지만, 대부분의 경우 그렇게 하지 않는 것이 좋다.

**[Split View Styles]**

* iOS 14 버전 이후부터는 column-style 레이아웃을 지원한다.
* 적절한 style을 init(style:) 이니셜라이저와 함께 이용하면 두개 혹은 세개의 column을 가진 interface를 생성할 수 있다.
    * UISplitViewController.Style.doubleColumn
        * 두개의 열로 이루어진 SplitViewController가 생성된다.
        * primary 및 secondary column에 배치된 두개의 하위 뷰 컨트롤러를 관리한다.
    * UISplitViewController.Style.tripleColumn
        * 세개의 열로 이루어진 SplitViewController가 생성된다.
        * primary, secondary, supplementary column에 배치된 세 개의 하위 뷰 컨트롤러를 관리한다.

![](https://i.imgur.com/5R7Ss9m.png)

> iOS 14 이전에는 오직 primary, secondary 뷰컨트롤러를 가진 하나의 SplitViewController만을 지원했는데, 이 인터페이스는 .unspecified 유형이다. iOS14 이후의 column-style API에는 응답하지 않는다.

**[Child View Controllers]**

* column-style split view interface에서 setViewController(_: for:)와viewController(for:) 메서드를 사용하여 각 column의 뷰 컨트롤러들을 지정한다.
* SplitViewController 같은 경우는 모두 Navigation Controller에 둘러쌓여 있다.
    * 만약 자식 뷰 컨트롤러를 Navigation Controller로 감싸지 않더라도, SplitViewController가 자동으로 Navigation Controller를 감싸준다. 
* SplitViewController는 viewController(for:)를 통해서 original view controller를 반환하지만, 자식 프로퍼티는 뷰 컨트롤러를 wrapping하는데 사용한 navigation controller를 포함한다.
* view controller를 특정 열에 할당한 후 show(_:) 또는 hide(_:) 메소드를 사용하여 column을 표시화거나 숨길 수 있다.
* 기존의 split view 인터페이스에서는 인터페이스 빌더를 사용하거나 프로그래밍 방식으로 뷰 컨트롤러를 viewControllers 프로퍼티에 할당하여 하위 뷰 컨트롤러를 구성할 수 있다.
* primary 뷰 컨트롤러나 secondary 뷰 컨트롤러를 변경해야하는 경우 show(_:) 및 showDetailViewController(_:sender:) 메소드를 사용하는 것을 권장한다.
* viewControllers 속성을 직접 수정하는 대신 이러한 방법을 사용하면 SplitViewController가 현재 display mode 및 size class에 가장 적합한 방식으로 지정된 뷰 컨트롤러를 표시할 수 있다.

**[Interface Transitions]**

* SplitViewController는 인터페이스의 특정 변경에 따라 축소 및 확장을 수행한다.
    * 예를들어 인터페이스의 size class가 horizontally regular 및 horizontally compact 간에 전환될 때, 혹은 사용자 상호 작용이나 프로그래밍 방식으로 column을 숨기거나 표시할 때 전환이 발생한다.
    * SplitViewController는 해당 delegate 객체와 함께 축소 및 확장 전환을 수행한다. 
        * delegate는 UISplitViewControllerDelegate 프로토콜을 채택하는 사용자가 제공하는 객체이다.
* column 스타일 split view 인터페이스에서 인터페이스가 축소될 때 primary, supplementary, secondary 뷰 컨트롤러가 아닌 또 다른 뷰 컨트롤러를 표시할 수 있다.
* setViewController(_:for:) 메소드를 사용하여 UISplitViewController.Column.compact column에 원하는 뷰컨트롤러를 설정하자.
* 축소 및 확장 전환을 커스터마이징 하고 싶다면 [Column-Style Split Views](https://developer.apple.com/documentation/uikit/uisplitviewcontrollerdelegate#3596702)를 참조하자.
* 기존 split view 인터페이스에서 전환을 관리하는 방법에 대한 자세한 내용은 [Classic Split Views](https://developer.apple.com/documentation/uikit/uisplitviewcontrollerdelegate#3596701)를 참조하자.

**[Display Mode]**

* SplitViewController의 현재 디스플레이 모드는 하위 뷰 컨트롤러의 시각적 배열을 나타낸다.
* 표시되는 하위 뷰 컨트롤러의 수와 각 컨트롤러가 서로 어떻게 배치되는지를 결정한다.
    * 예를 들어, 하위 뷰 컨트롤러를 한번에 하나씩만 보이도록 나란히 표시하거나, 다른 컨트롤러에 의해 하나가 부분적으로 가려지도록 정렬할 수 있다.
* preferredDisplayMode 프로퍼티를 사용하여 기본 디스플레이 모드를 설정한다.
* SplitViewController는 지정한 디스플레이 모드를 준수하기 위해 노력하지만 공간 제약으로 인해 해당모드를 시각적으로 수용하지 못할 수 있다.
    * 예를 들어 SplitViewController는 수평으로 압축된 환경에서 하위 뷰 컨트롤러를 나란히 표시할 수 없다.
* For possible configurations, see UISplitViewController.DisplayMode.

![](https://i.imgur.com/iwbDGGX.png)

* preferredDisplayMode를 설정한 후 SplitViewController는 자체 업데이트 하고 displayMode 프로퍼티에 반영된다.
* 만약 어떤 column이 보여지기를 원하는지 변경하고 싶다면, show(_:) 혹은 hide(_:) 메소드를 사용하면 된다.
* SplitViewController는 원하는 column을 표시하도록 display mode를 업데이트 하는 방법을 결정할 것이다.

**[Gesture and Button Support]**

* 사용자 상호작용으로 현재 디스플레이 모드를 변경할 수 있는 여러가지 방법이 있다.
    * SplitViewController 내부에는 gesture recognizer가 포함되어 있는데, 이는 스와이프를 통해서 유저가 디스플레이 모드를 변경할 수 있도록 한다.
    * 해당 스와이프를 presentsWithGesture 프로퍼티를 false 값으로 변경함으로써 제어할 수 있다.
    * 만약 presentsWithGesture 프로퍼티가 false라면 우리는 primary view controller를 항상 볼 수 있을 것이다.
    * 그러나 true라면 SplitViewController는 디스플레이 모드를 바꾸는 가지고 있을 것이다.
    * SplitViewController는 이 버튼의 행동(behavior), 모양(appearance), 위치(positioning) 까지도 관리해줄 수 있다.
* UISplitViewController는 사이드바 토글 아이콘으로써 사용되는 UISplitViewController.SplitBehavior.title과 back-chevron 아이콘으로써 사용되는 UISplitViewController.SplitBehavior.overlay와 UISplitViewController.SplitBehavior.displace를 나타낸다.
    * 이 버튼을 누르면 현재 디스플레이 모드 및 split view의 동작에 따라 새로운 디스플레이 모드로 전환된다.
* 3-column의 split view interface - UISplitViewController.Style.tripleColumn의 경우 디스플레이 모드에 영향을 미치는 또다른 property는 showsSecondaryOnlyButton이다.
    * 이 프로퍼티가 참이면 SplitViewController는 UISplitViewController.DisplayMode.secondaryOnly에서 혹은 해당 mode로 변경하기 위한 toggle bar button item을 만든다.
* SplitViewController는 behavior, appearance 그리고 item의 위치를 관리한다.
    * 이 아이콘은 이중 화살표 아이콘이다. 사용자가 이 버튼을 누르면 디스플레이 모드가 secondaryOnly로 전환된다.

**[Split Behavior]** 

* SplitViewController에서 split behavior은 secondary view controller가 다른 view controller와 비교하여 나타나지는 방식을 제어한다.
* secondary view controller가 side에서 다른 view controller에 비해 분명하게 나타나게 할 것인지, 혹은 어둡게 하여 스크린에서 잘 안보이게 할 지를 설정할 수 있다.

![](https://i.imgur.com/XzZlJgf.png)


---

- 참고링크
    - https://lazyowl.tistory.com/entry/iOS-%EB%A0%88%EC%9D%B4%EC%95%84%EC%9B%83-%EC%82%AC%EC%9D%B4%ED%81%B4-%EB%B0%8F-%EB%93%9C%EB%A1%9C%EC%9E%89-%EC%82%AC%EC%9D%B4%ED%81%B4
    - https://green1229.tistory.com/67
    - https://baked-corn.tistory.com/105
    - https://magi82.github.io/ios-intrinsicContentSize/
    - https://velog.io/@elile-e/Drawing-Cycle
    - https://developer.apple.com/documentation/uikit/uisplitviewcontroller
    - https://kyungpyoda.tistory.com/entry/%EB%B2%88%EC%97%AD-UISplitViewController?category=890396
    - https://velog.io/@leeyoungwoozz/UISplitViewController
