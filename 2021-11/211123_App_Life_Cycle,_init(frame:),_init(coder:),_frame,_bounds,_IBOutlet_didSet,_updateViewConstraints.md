# 211123 App Life Cycle, init(frame:), init(coder:), frame, bounds, IBOutlet didSet, updateViewConstraints
# TIL (Today I Learned)


11월 23일 (화)

## 학습 내용
- Applicedation Life Cycle
- UIView의 이니셜라이저 init(frame:)과 init(coder:)의 차이점?
- Frame vs Bounds
- IBOutlet의 didSet은 언제 trigger될까?
- 계산기 프로젝트 버튼의 속성값을 언제 넣어줘야 적절할까?
&nbsp;

## 고민한 점 / 해결 방법
- ### App Life Cycle
    앱은 foreground일 때와 background일 때 앱이 할 수 있는 일과 해야하는 일이 달라진다.
    foreground인 앱은 시스템 자원의 높은 우선 순위를 가지고
    background인 앱은 최대한 적은 일(가능하면 아무것도 안하기)을 해야한다.

    사용자들은 누구나 그렇듯이 앱을 사용할 때
    이 앱 저 앱을 왔다갔다 하거나 잠깐 다른 앱을 보고 오거나 하기 때문에 
    앱의 상태 변화에 따라 반응을 해줄 필요가 있다.

    앱의 상태가 변화했는지 어떻게 알 수 있을까?


* iOS 13 이상에서는 UISceneDelegate object를 통해 Scene-based 앱의 life cycle에 대응하고

* ![](https://i.imgur.com/vDWiiL7.png)

* 그 이전 버전에서는 UIApplicationDelegate objcet를 통해 대응한다.

* ![](https://i.imgur.com/xl7ShNE.png)


* ![](https://i.imgur.com/8icyHFK.png)

* iOS 12 이하 Scene을 지원하지 않는다.
    그래서 UIKit은 모든 life-cycle events를 UIAplicationDelegate object에 전달한다.
    App delegate는 앱의 모든 window를 관리하고 app state의 전환은 앱의 전체 UI에 영향을 미친다.

    ## iOS 13 이후 바뀐점
    iOS 12까지는 하나의 앱에 하나의 window, 즉 한 앱을 동시에 키는 것이 불가능 하였지만
    iOS 13부터는 window의 개념이 Scene으로 대체되고 아래의 그림처럼 하나의 앱에서 여러개의 [Scene](https://developer.apple.com/documentation/uikit/app_and_environment/scenes)을 가질 수 있게 되었다. 즉 하나의 앱을 동시에 켜는 것이 가능해졌다.
    
    ![](https://i.imgur.com/HElGceR.jpg)

    AppDelegate의 역할중 UI의 상태를 알 수 있는 UILifeCycle에 대한 부분을 SceneDelegate가 대체한다.

    * AppDelegate의 역할중에 UISceneSession Lifecycle이 추가되었다.

    ![](https://i.imgur.com/F7jVek4.png)

    * SceneSession이 생성되거나 삭제될 때 AppDelegate에게 알려주는 두 가지의 메소드가 AppDelegate에 추가된 것을 확인할 수 있다.
    * SceneSession은 앱에서 생성한 모든 Scene의 정보를 관리한다.

    ![](https://i.imgur.com/j0jyDQP.png)

    위 그림은 애플 문서에서 제공하는 Scene의 상태 전환을 보여주는 그림이다.
    * 사용자나 시스템이 앱의 Scene을 요청하면 UIKit이 이를 생성하고 Unattached상태로 둔다.
    * 요청자가 사용자라면 Scene을 바로 Foreground로 전환한다.
    * 요청자가 시스템이라면 Scene을 Background로 전환하여 이벤트를 처리할 수 있도록 한다.
    * 사용자가 앱의 UI를 닫으면 UIKit은 Scene을 Background로 전환하고 곧 Suspended 상태로 전환한다.
    * UIKit은 Background, Suspended 상태의 앱은 언제든지 연결을 끊고 Unattached 상태로 전환할 수 있다.

    ### 앱이 실행하는 관점
    1. 먼저 UIKit이 Scene을 앱에 연결한다. 그런 뒤 Scene의 초기 UI를 구성하고 필요한 데이터를 로드한다
    2. Foreground Active 상태로 전환할 때 UI를 구성하고 사용자와 상호작용할 준비를 한다.
    3. Foreground Active > Foreground Inactive로 전환할 때는 데이터를 저장한다
    4. Foreground에서 Background로 전환할 땐 중요한 작업을 완료하고 메모리를 확보한 뒤 현재 앱 UI를 스냅샷으로 준비한다. 이 화면이 앱 전환기에서 보이는 그 화면이다.
    5. Scene과의 연결이 끊어지면 Scene과 관련된 모든 리소스를 정리한다. (Suspeded 상태)

    간단하게 앱에서 이러한 작업들이 어떻게 진행되는지 살펴보자.

    * sceneWillEnterForeground, sceneDidBecomeActive
    
    ![](https://i.imgur.com/jFG547g.gif)

    * sceneWillResignActive, sceneDidBecomeActive

    ![](https://i.imgur.com/O8P8j4p.gif)

    * sceneDidEnterBackground

    ![](https://i.imgur.com/G6AFPco.gif)

    * sceneDidDisconnect
    
    ![](https://i.imgur.com/OAjHu3V.gif)

    이것이 바로 iOS 13 이후에서 Scene을 사용할 때의 App Life Cycle이고, iOS 12에서 AppDelegate가 이를 관리할 땐 조금 달라진다.

    iOS 12까지는 UIApplicationDelegate에서 모든 Life Cycle 이벤트를 처리했다.
    이 때는 아래와 같이 상태 전환이 발생했다고 한다.
    
    ![](https://i.imgur.com/pfQSi2q.png)

    Scene과 비슷하지만 상태의 이름이 다른 것을 확인할 수 있다.
    AppDelegate는 별도의 Scene에 표시되는 Window를 포함하여 앱의 모든 window를 관리한다.
    결과적으로 앱 상태 전환은 외부 디스플레이의 콘텐츠를 포함하여 앱 전체 UI에 영향을 준다.

    앱이 시작하면 UI가 화면에 표시될 것인지에 대한 정보에 따라 앱을 Inactive, background 상태로 전환한다.
    만약 화면에 표시가 될 것이라면 알아서 Active 상태로 전환하고 앱이 종료될 때 까지 Active와 Background 상태를 유지한다.

    이러한 방식을 App transition이라고 하며 이 방법을 사용할 때의 과정은 아래와 같다.

    * 시작시 앱의 자료구조와 UI를 초기화 한다
    * Active 상태가 되면 UI 구성을 완료하고 사용자와 상호작용할 준비를 한다.
    * 비활성화되면 데이터를 저장하고 앱 동작을 최소화한다.
    * Deactivation 상태가 되면 중요한 작업을 완료하고 메모리를 최대한 확보한 뒤 앱 스냅샷을 준비한다.
    * 앱이 종료되면 작업을 즉시 중지하고 공유 자원을 해제한다.

    ## Respond to Other Significant Events (기타 이벤트 응답)
    Life Cycle 이벤트 처리 외에도 앱은 아래와 같이 나열된 이벤트를 처리할 준비가 되어있어야 한다. 
    
    UIApplicationDelegate 객체를 사용하여 이러한 이벤트 대부분을 처리한다.
    경우에 따라 알림을 사용하여 처리할 수도 있으므로 앱의 다른 부분에서 응답할 수 있다. 



|-|-|
|:--------:|:--------:|
|Memory warnings|앱이 메모리 사용량이 너무 높을 때 수신된다. 앱에서 사용하는 메모리 양을 줄인다.|
|Protected data becomes available/unavailable|사용자가 기기를 잠그거나 잠금 해제할 때 수신된다.|
|Handoff tasks|객체를 처리해야할 때 수신된다.|
|Time changes|전화 통신사가 시간 업데이트를 보내는 경우와 같이 여러가지 다른 시간 변경에 대해 수신된다.|
|Open URLs|앱에서 리소스를 열어야 할 때 수신된다.|

---
* `init(frame:)`와 `init(coder:)`의 차이점
    ### init(frame:)
    코드로 UIView Class의 View 인스턴스를 만들기 위해 지정된 이니셜라이저.
    Frame rectangle을 가지고 구현하고자 하는 뷰의 중심과 경계선을 지정해준다.
    스토리보드, xib, nib 같은 인터페이스 빌더를 사용하지 않고 코드로 UIView Calss의 View object를 만들기 위해 지정된 이니셜라이저다.

    ### init(coder:)
    기본적으로 `storyboard`나 `xib`를 활용하면 별도의 코딩 없이 앱의 속성을 수정할 수가 있는데 이것을 가능하게 해주는 과정을 `unarchiving`이라고 한다. Interface builder는 코드가 아니기 때문에 앱을 컴파일 하는 시점에서 컴파일러가 인식할 수 없고 이를 코드로 변환해주는 unarchiving 과정이 필요하다는 것이다.
    이 과정에서 `init?(coder:)`가 사용된다.
    파라미터 coder를 통해 NSCoder 타입의 객체가 전달되는 것이고 전달된 NSCoder 타입의 객체가 decoding되어 초기화된 후 컴파일 할 수 있게 decoding된 자기자신(self)을 반환하는 작업이라고 보면 될 것 같다.

    내가 구성한 View의 상태를 앱의 disk에 저장하는 과정을 `serialize`라고 한다. deserialize는 반대로 disk에 저장된 상태를 불러오는 작업이라고 볼 수 있다. 
    NSCoding이라는 프로토콜을 통해 이 serialize와 deserialize 작업이 가능해진다.

    따라서 init(coder:)의 용도는 아래와 같다.
    * Storyboard라는 인터페이스 빌더를 사용하여 뷰의 상태를 수정할 경우 serialization 작업을 Xcode가 init(coder:)를 호출하여 앱 내 뷰 작업을 저장하고 불러오는 작업을 해준다.

    UIView 선언부를 보면 NSCoding 프로토콜을 채택하고 있는데 NSCoding 선언부를 살펴보면 실패가능한 이니셜라이저를 작성하도록 되어있다.
    프로토콜을 준수하는 클래스에서 프로토콜에서 요구하는 이니셜라이저 요구사항을 구현하려면 required 키워드가 붙어야 한다. 따라서 이를 상속받은 FormulaStackView와 같은 클래스에서는 스토리보드르 사용하고 있지 않지만 init?(coder:)를 구현해줘야 하고 앞에 꼭 required를 붙여주어야 한다.

---
* `Frame` vs `Bounds`
* ## Frame
    Super View 좌표계에서 View의 위치와 크기를 나타낸다.

* ### Frame의 origin(x, y)
    * Super view의 원점을 (0,0)으로 놓고 원점으로부터 얼마나 떨어져 있는지를 나타낸다.
    * 따라서 Frame의 origin 값을 변경하면 SubView도 그만큼 같이 움직인다.

* ### Frame의 Size(width, height)
    * View 영역을 모두 감싸는 사각형으로 나타낸다.
    * View 자체의 크기가 아니라 View가 차지하는 영역을 감싸서 만든 사각형이라고 이해하면 된다.

* ### 언제 사용할까?
    * UIView의 위치 및 크기를 설정할 때 사용한다.

    ---

* ## Bounds
    자신의 좌표계에서 View의 위치와 크기를 나타낸다.

* ### bounds의 origin(x, y)
    * Super view와는 아무 상관 없으면 기준이 자기 자신이다.
    * 따라서 좌표의 시작점을 자기의 원점(0,0)으로 놓는다.
    * bounds를 바꿔줘야 하는 경우는 ScrollView의 ContentOffset을 설정할 때이다.
        * ScrollView의 SubView 중 어떤 영역을 보여줄지 정할 때 사용할 수 있다.
        * bounds의 origin 값을 변경하면 viewport가 변경되며, 뷰가 움직이는 것이 아니라 보여지는 뷰의 좌표가 달라지는 것이라고 이해하면 될 것 같다.
        * 즉 View의 viewport가 변경된다는 것은 내 View의 SubView의 어디 부분을 보여줄지를 바꿔준다는 뜻
        * 예시로 스크롤 뷰에서 이미지를 확대하여 움직여서 이동하는 것을 viewport 값이 바뀌는 것으로 이해하면 될 것 같다.

* ### Bounds의 size(width, height)
    * View 자체의 영역을 나타낸다.
    * Frame과 다르게 View영역을 모두 감싸서 만든 사각형이 아니라 View 자체의 영역을 나타낸다고 이해해보면 된다.


* ### 언제 사용할까?
    * View를 회전(transfomation)한 후 View의 실제 크기를 알고 싶을 때 사용한다.
    * View 내부에 그림을 그릴 때(drawRect) 사용한다.
    * ScrollView에서 스크롤링 할 때 사용한다.
        * ScrollView의 SubView 중 어떤 영역을 보여줄지 정할 때 사용할 수 있다.

---

* ### IBOutlet의 didSet은 언제 trigger될까?
    * utlet 프로퍼티는 class가 막 초기화 될 때는 nil 상태
    * nib으로부터 object가 초기화 될 때에 값을 갖게 된다
    * 모든 Outlet이 nil이 아님을 확신할 수 있을 때는 viewDidLoad때
    * 따라서 Outlet에 있는 didSet 옵저버는 viewDidLoad 바로 전에 호출
    * 따라서 Outlet 프로퍼티 다룰 때 조심해야 함. 예를들어 prepareForeSegue 때 접근하려고 하면 nil이 나올 것.

* IBOutlet은 class라 자체적으로 값을 대입하여 바꾸지 않는 이상 didSet 호출이 되지 않는다.

---

* ### 버튼의 conrnerRadius의 값을 줄 때 어디서 줘야 적절할까?

    ![](https://i.imgur.com/Aqm8zFf.png)

* 엘림의 피드백에 따라 해당 메서드가 언제 호출되는지 확인해보았다. 버튼을 누를 때마다 호출 되었다.
* 따라서 버튼의 속성을 주는 for문이 버튼을 누를 때마다 계속 실행되고 있었다.

    ![](https://i.imgur.com/ZhTzujz.png)


* 버튼의 IBOutlet에 didSet을 줄 수도 있었지만 아래와 같은 문제 때문에 해당 방법은 불가능 했다.

    ![](https://i.imgur.com/JPJ9H8A.png)

* 디버깅을 해보니 viewWillLayoutSubviews 메소드가 호출되는 시점에 레이아웃이 갱신되어 버튼의 너비가 바뀌고 있었다.
* IBOutlet의 didSet은 viewDidLoad가 호출되기 전에 호출되므로 적절하지 못한 방법이였다.
* 따라서 최소한으로 적게 호출되는 updateViewConstraints메소드를 활용하여 해당 문제를 해결하였다.
    ```swift
    func setupButtons() {
        calculatorButtons.forEach { button in
            button.layoutIfNeeded()
            button.layer.cornerRadius = button.layer.bounds.width / 2
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        setupButtons()
    }
    ```    
* updateViewConstraints에 버튼셋팅 메소드를 호출하고있고, for문 내부에서 버튼마다 layoutIfNeeded를 호출하여 레이아웃을 갱신하고 이후 cornerRadius 값을 대입해주고있다.
* 레이아웃을 갱신하는 이유는 갱신하지 않으면 위 디버깅시 발견하였던 최종 레이아웃이 아니라 임의로 잡혀있던 frame값으로 계산을 하기 때문에 아래처럼 찌그러진 원이 나온다.

    ![](https://i.imgur.com/O9e089d.png)

&nbsp;

## 느낀점
* 아니.. App Life Cycle 배울것이 왜이렇게 많지...
* View Life Cycle에 대해서도 배워야할 것 같다...
* 죽여줘....

---

- 참고링크
    - https://developer.apple.com/documentation/uikit/app_and_environment/managing_your_app_s_life_cycle
    - https://developer.apple.com/documentation/uikit/uiviewcontroller/1621379-updateviewconstraints
    - https://sujinnaljin.medium.com/swift-class%EC%99%80-struct%EC%97%90%EC%84%9C-didset%EC%9D%98-%EC%B0%A8%EC%9D%B4-f784e34ea33f
    - https://stackoverflow.com/questions/38197785/when-how-outlet-didset
    - https://babbab2.tistory.com/44
