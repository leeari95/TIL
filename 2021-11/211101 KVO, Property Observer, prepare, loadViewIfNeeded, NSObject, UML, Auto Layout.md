# TIL (Today I Learned)

11월 1일 (월)

## 학습 내용
오늘은 오전에 야곰이 KVO와 Property Observer에 대한 녹화를 진행한다고 하여 참석해서 학습을 했다. 이후 오토레이아웃을 마저 학습하고 오후에는 제이티와 함께 STEP 3를 어떻게 구현해볼지 의논해보는 시간을 가졌다. 이후에 UML에 대해서 활동학습을 진행했다. 프로젝트 리뷰어인 흰이 강의해주었다!

&nbsp;

## 문제점 / 고민한 점
- 옵저빙하는 객체가 private이면 옵저빙이 가능할까?
- KVO와 Property Observer는 언제 쓰면 적절할까?
- 왜 텍스트 필드가 왜저리 늘어나는거지....쩝

    ![](https://i.imgur.com/MrPgtP1.png)
    
- prepare 메소드로 넘기기 전에 view를 load하는 방법?
- STEP 3를 진행하는 도중에 왜 만들었는지 모르겠는 코드를 발견했다.. 헐
- UML 강의를 듣고, 예습도 하고 갔지만 화살표의 정확한 용도가 잘 이해가 가지 않았다.
- NSObject에 대해서 알아보자

&nbsp;
## 해결방법
- 오.. 불가능했다. 이런 고민은 해본 적 없었는데, 캠퍼덕에 새로운 사실을 알게되었네!
- KVO는 타입 정의 외부에서 옵저버를 추가할 때 사용할 수 있고, Property Observer는 타입 정의 내부에서 사용할 수 있다. 때에 따라 적절히 이용해주면 좋을 것 같다는 생각이 들었다.

    ![](https://i.imgur.com/Ln5xGmo.png)
    
- 이 부분을 놓쳐서 그랬었다. 근데 이걸 해결했는데 또다른 문제가 생겼다... Scroll View 안에 있는 Stack View가 늘어나지가 않아서 스크롤도 안생기는 현상이 생겨서 자세히 살펴보았더니 Stack View의 Width가 잘못 설정이 되어있었다. priority가 설정이 안되어 있었고, 잘못 설정해준걸로 착각한 위 제약때문에 삭제해주었더니 해결되었다.
    
    ![](https://i.imgur.com/gxIT2hn.png)
    
    ![](https://i.imgur.com/cxDxkwX.gif)
    
- 제이티가 공식문서를 찾다가 발견해주었다. loadViewIfNeeded() 라는 메소드인데 아직 로드되지 않는 경우 뷰 컨트롤러의 뷰를 로드하는 메소드이다. 근데 이렇게 수동적으로  view를 미리 로드하는게 적절한지 잘모르겠다.
- 내일 제이티와 기억을 같이 더듬어봐야할 것 같다.
- 질문시간에 흰에게 질문하였다. 프로토콜과 익스텐션의 관계를 실체화라고 봐야하는지 의존으로 봐야하는지 감이 안왔다. 흰의 답변은 둘다 적절하지 않다는 답변이였다. 나중에 흰의 UML도 보았는데, 익스텐션을 따로 만들어주지 않고 그냥 프로토콜 내부에 통합해주었다. 다른 예제들을 찾아보면 따로 만들어준 경우도 있고... 따라서 정답은 없는 것 같다. UML의 목적은 곧 의사소통이므로 커뮤니케이션 하는데 있어서 문제만 없게 적절하게 그리는 것이 관건이겠다.
- 내가 그려본 UML
   
   ![](https://i.imgur.com/dEYLhwy.png)
   
- NSObject는 다른 클래스를 상속받지 않는 루트 클래스라고 한다. NSObject와 이름이 같은 프로토콜의 공식문서를 살펴보면 모든 Objective-C 객체의 근간이 되는 메서드를 모아둔 프로토콜이라고 한다. 설명중에서 코코아, 런타임 시스템이라는 말과 Objective-C는 왜 등장하는지가 궁금해지는데, 간단히 요약하자면 코코아 터치는 iOS 앱개발을 위한 UiKit, Foundation 등의 프레임워크를 포함한 최상위 프레임워크이고, 그 중 Foundation 프레임워크 내부에는 NSObject가 정의되어 있다. Foundation에서 정의한 데이터 타입은 NSString, NSArray와 같이 앞에 NS가 붙어있고, 이유는 잡스가 과거에 개발했던 운영체제의 이름이 NeXTSTEP이기 때문에 프레임워크에 NS로 흔적이 남아있는 것이다.

&nbsp;

## 공부내용 정리
<details>
<summary>UML 예습</summary>
<div markdown="1">

Unified Modeling Language의 약자
도메인을 모델로 표현해주는 대표적인 모델링 언어
소프트웨어 시스템, 업무 모델링, 시스템의 산출물을 규정하고 시각화, 문서화하는 언어
프로그램 언어가 아닌 기호와 도식을 이용하여 표현하는 방법을 정의한다.
작성목적은 객체지향 시스템을 가시화, 명세화, 문서화한다.
소프트웨어를 설게하며 아래와 같은 필요에 의해서 사용된다.
* 의사소통 또는 설계 논의를 위해 (같이 일하는 사람)
* 전체 시스템의 구조 및 클래스의 의존성 파악을 위해 (나 자신)
* 유지보수를 위한 설계의 back-end 문서 제작을 위해 (문서화)

# 목표
* 사용자들이 의미있는 모델을 만들고 공유할 수 있도록 사용하기 쉬우면서도 표현이 풍부한 시각적 모형화 언어를 제공한다. (문서의 직관성을 높인다)
* 핵심 개념을 확장하기 위한 메커니즘을 제공한다
* 특정 프로그래밍 언어나 개발 공정에 종속되지 않아야 한다. (통합성을 중요시)
* 모델링 언어를 이해하기 위한 공식적 기준을 제공
* 객체지향 도구 시장의 성장을 장려해야 한다.
* 협동, 프레임워크, 패턴, 컴포넌트 등의 고수준의 개발 개념들을 지원한다.
* 산업계의 검증된 최상의 경험들을 통합한다.

# 다이어그램 종류
* Use Case 요구 분석 과정에서 시스템과 외부와의 상호 작용을 묘사하ㅓㅁ
* Activity 업무의 흐름을 모델링하거나 객체의 생명주기를 표현함
* Sequence 객체간의 메세지 전달을 시간적 흐름에서 분석함
* Collaboration 객체와 객체가 주고받는 메세지 중심의 작성함
* Class 시스템의 구조적인 모습을 그림
* Component 소프트웨어 구조를 그림
* Deployment 기업 환경의 구성과 컴포넌트들 간의 관계를 그림


# 클래스 다이어그램
![](https://i.imgur.com/KMbcAmd.png)
![](https://i.imgur.com/jBdIYkK.png)
* 정적 다이어그램으로 클래스의 구성요소 및 클래스간의 관계를 표현하는 대표적인 UML
* 시스템의 일부 또는 전체의 구조를 나타낼 수 있다. 
* 의존관계를 명확히 보게 해주며 순환 의존이 발생하는 지점을 찾아내서 어떻게 이 순환고리를 깰 수 있을지 결정할 수 있게 해준다.
    * 상단 섹션: 클래스 이름
    * 중간 섹션: 클래스 속성
    * 하단 섹션: 클래스 메서드 또는 작업


## 용도
* 문제 해결을 위한 도메인 구조를 나타내어 보이지 않는 도메인 안의 개념과 같은 추상적인 개념을 기술하기 위해 사용
* 소프트웨어의 설계 혹은 완성된 소프트웨어의 구현 설명을 목적으로 사용
    
![](https://i.imgur.com/AjhHOxd.png)

    

클래스 다이어그램의 활용

## 기본 요소
    
![](https://i.imgur.com/Dtruyfp.png)
    
접근제어자
Public +
Private -
Protected #

속성
접근제어자 이름: 타입 = 기본값
Ex) -title: String = “”

메서드
접근제어자 이름(파라미터 속성): 리턴값
Ex) +setTitle(String)
Ex) +getTittle(): String

## 클래스 다이어그램을 이용한 관계 표현
    
![](https://i.imgur.com/O8T3VPE.png)
    
- 일반화는 상속을 하는 클래스를 가리킬때 사용할 수 있다
- 의존은 연관관계가 있는 클래스를 가리킬 때 사용할 수 있다.
- 집합관계는 전체객체, 부분객체로 구분할 수 있다.
- 합성관계는 라이프사이클이 연관되어있어서 강한 집합관계를 뜻한다

# Sequence 다이어그램
순서를 파악하고 싶을 때 사용한다.
![](https://i.imgur.com/8M0ntrG.png)



</div>
</details>

<details>
<summary>Layout Anchor</summary>
<div markdown="1">

단하고 안전한 방법중에 하나인데 한계점이 있다.
Auto Layout을 설정할 때 Anchor를 사용하면 좋은점은 코드가 굉장히 간결하다는 것이다. 그리고 코드 컴파일 타임에 간단하게 오류를 체크할 수 있다는 점이다. 

## translatesAutoresizingMaskIntoConstraints
Auto Layout을 사용하여 View의 크기와 위치를 동적으로 계산하려면 이 프로퍼티를 false로 설정한 다음 View에 모호(ambiguous)하지 않고 충돌하지 않는(Nonconflicting) Constraint 집합을 제공해야 한다.

```swift
class AnchorViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton()
        button.setTitle("Button", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // safeArea의 영역을 나타내주는 가이드
        let safeArea = view.safeAreaLayoutGuide
        
        // constraint를 활성화 해주는 구간. 활성화를 해주지 않으면 무력화가 된다.
        button.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        button.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
        // 코드로 제약을 줄 때는 양수, 음수 어떤 개념으로 들어올지 생각해보고 작성해야한다.
        let safeBottomAnchor = button.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        safeBottomAnchor.isActive = true
        safeBottomAnchor.priority = .init(999)
        let viewBottomAnchor = button.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
        viewBottomAnchor.isActive = true
        
    }
    
}
```

</div>
</details>

<details>
<summary>NSLayoutConstraint</summary>
<div markdown="1">

상세하게 오토레이아웃을 설정해줄 수 있지만 컴파일시 오류를 검출해주지 않는다는 단점이 있다. 그래서 Anchor를 사용하면서 오토레이아웃이 적용이 안되는, 한계점이 왔을 때만 사용해주는 것이 좋다.

```swift
let safeArea = view.safeAreaLayoutGuide
        let leading = NSLayoutConstraint(item: button,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: safeArea,
                                         attribute: .leading,
                                         multiplier: 1,
                                         constant: 16)
        let trailing = NSLayoutConstraint(item: button,
                                          attribute: .trailing,
                                          relatedBy: .equal,
                                          toItem: safeArea,
                                          attribute: .trailing,
                                          multiplier: 1,
                                          constant: -16)
        let bottomSafeArea = NSLayoutConstraint(item: button,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: safeArea,
                                        attribute: .bottom,
                                        multiplier: 1,
                                        constant: -16)
        bottomSafeArea.priority = .defaultHigh
        let bottomView = NSLayoutConstraint(item: button,
                                        attribute: .bottom,
                                        relatedBy: .lessThanOrEqual,
                                        toItem: view,
                                        attribute: .bottom,
                                        multiplier: 1,
                                        constant: -20)
        NSLayoutConstraint.activate([leading, trailing, bottomView, bottomSafeArea])
```


</div>
</details>
<details>
<summary>Size Class</summary>
<div markdown="1">


[Size Class](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/Size-ClassSpecificLayout.html#//apple_ref/doc/uid/TP40010853-CH26-SW1)

![](https://i.imgur.com/Mo1HvY1.png)

크기에 따라 content area에 자동적으로 할당되는 특성을 의미한다.
즉 시스템은 View의 높이와 너비를 설명하는 regulart, compact의 두가지 크기 클래스를 정의한다.
그러나 사실상 이것을 꼭 필요로 하는 앱이 아니면 현업에서는 잘 사용하지 않는 기능이기도 하다.
대체적으로 아이폰이나 아이패드를 스토리보드를 별도로 작업하는 경우가 많다.

따라서 View는 다음과 같은 4가지 조합의 크기 클래스를 가질 수 있다.
* Regular width, regular height
* Regular width, compact height
* Compact width, regular height
* Compact width, compact height

그리고 iOS는 content area의 크기 클래스를 사용자가 장치를 가로방향에서 세로방향으로 회전하면 수직크키 클래스가 compact -> regular로 변경되며 tab bar의 막대가 높아지는 것과 같이 동적으로 layout을 조정하게 된다.

어떤기기가 어떤 크기를 갖게 되는지는 [링크](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout/)에 스펙이 자세히 나와있다.



</div>
</details>

<details>
<summary>Working with scroll Views</summary>
<div markdown="1">
    

![](https://i.imgur.com/F7HaWjY.png)

* Scroll View를 추가하고 제약조건을 추가해줘도 빨간 경고가 뜬다. 이유가 뭘까? 그것은 바로 ‘Scroll View안에 들어갈 Content의 사이즈가 지정이 되지 않았다’ 라는 경고다. 따라서 Scroll View 안에 Content View를 추가해주고 제약을 준다면 해결된다.

## Content Layout Guide와  Frame Layout Guide

![](https://i.imgur.com/sx1zDGK.gif)

### Content Layout Guide
들어오는 컨텐츠에 따라 레이아웃을 변경시켜줄테니 컨텐츠 크기를 나에게 알려줘

### Frame Layout Guide
스크롤과 관계없이 화면 안에 고정되어야 할 요소가 있어? 나에게 위치를 알려줘


* Content Layout Guide에 따라 늘어난 Label의 크기

![](https://i.imgur.com/3TB3CiV.gif)


* Frame Layout Guide와 관계를 맺어 고정되어있는 Label

![](https://i.imgur.com/tlBQ8Am.png)

* Scroll View와 Stack View를 활용한 예제

![](https://i.imgur.com/luejd48.png)

 
```swift
    @IBAction func addView() {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.isHidden = true
        label.text = """
            dasdasd
            asdasdasd
            asda
            dasd
            asdasdsadas
            asdasdasdasd
            asdasdasdas
            asdasdasdasd
            """
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        stackView.addArrangedSubview(label)
        
        UIView.animate(withDuration: 0.3) {
            label.isHidden = false
        }
    }
    
    @IBAction func removeView() {
        guard let last = stackView.arrangedSubviews.last else { return }
        
        UIView.animate(withDuration: 0.3) {
            last.isHidden = true
        } completion: { _ in
            self.stackView.removeArrangedSubview(last)
        }
    }
```


</div>
</details>

<details>
<summary>Dynamic Type</summary>
<div markdown="1">

[Dynamic Type](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography/)
    
![](https://i.imgur.com/KGL4YuW.png)


모든 사용자가 시력이 같진 않다. 어떤 사용자는 글씨를 크게 키워서 앱을 이용할 수도 있는데, 우리가 앱을 개발할때 font 크기를 지정해버리면 사용자가 아무리 글씨를 크게 키운다고 해도 앱의 font 크기는 그대로일 것이다. 그래서 그런 요구사항을 유연하게 충족할 수 있도록 Dynamic Type을 사용한다면 훨씬 더 접근성을 구현하기가 좋아질 수 있겠다.


## 예제를 통해 알아보기

* 레이블을 추가하여 임의의 크기를 지정해보자

![](https://i.imgur.com/v0hFYIf.png)

* Accessibility Inspector를 열어준다.

![](https://i.imgur.com/4msnSRe.gif)

* 그리고 아래와 같이 설정해주면 Dynamic Type 크기를 설정할 수 있는 설정으로 갈 수 있다.

![](https://i.imgur.com/BQDWk8O.gif)

* Dynamic Type의 크기를 변경해주면 임의로 크기를 지정한 Label은 크기가 변하지 않는 것을 확인할 수 있다.

![](https://i.imgur.com/smR4FRt.gif)


## Dynamic Type 적용해보기
* 아래와 같이 Label의 설정을 바꿔준다. 폰트 크기를 Dynamic Type으로 설정해준다. Automatically Adjusts Font는 앱이 실행되는 동안에 글씨 크기가 바꾸는 것을 허용하는지의 대한 것이다. 체크를 해주지 않으면 앱을 끄고 다시켜서 폰트가 커졌는지 확인해야하는 번거로움이 생기기 때문에 체크를 해주는 것이다.

![](https://i.imgur.com/1w4TvUT.gif)

* 앱을 실행해서 확인해보면 폰트 크기가 변하는 것을 확인할 수 있다.

![](https://i.imgur.com/CE1FK1F.gif)

```swift
// NotificationCenter를 이용하여 Button들의 Label 크기를 Dynamic Type으로 정의하기
    @IBOutlet var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(adjustButtonDynamicType), name: UIContentSizeCategory.didChangeNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func adjustButtonDynamicType() {
        buttons.forEach { (button) in
            button.titleLabel?.adjustsFontForContentSizeCategory = true
        }
    }
```


</div>
</details>
&nbsp;

---

- 참고링크
    - [loadviewifneeded()](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621446-loadviewifneeded)
    - [참고한 swift UML 예제](https://github.com/MarcoEidinger/SwiftPlantUML)
    - [class diagram](https://gmlwjd9405.github.io/2018/07/04/class-diagram.html)
