# 211119 viewDidLoad, LocalizedError, ScrollView bar hide, addSubView, IBInspectable, cornerRadius, viewWillLayoutSubviews, private extension
# TIL (Today I Learned)


11월 19일 (금)

## 학습 내용
- 계산기 프로젝트 STEP 3 피드백 반영
- `viewDidLoad()` 내부에 super는 꼭 호출해야할까?
- `protocol LocalizedError`
- ScrollView에서 스크롤바 없애기
- 인터페이스 빌더에 속성을 추가하는 방법
- 둥근 버튼 만드는 방법
- `func viewWillLayoutSubviews()`
- private extension?
&nbsp;

## 고민한 점 / 해결 방법
- ### `viewDidLoad()` 내부에 super는 꼭 호출해야할까?
    - 사실 그동안은 기본적으로 super를 호출하게끔 구현이 되어있어서 넘어갔던 사실인데, 엘림이 해당 호출이 꼭 필요한지 물어봐서 알아보게 되었다.
    - 슈퍼클래스에 이미 선언되어있는 함수라 만든 클래스가 자동적으로 물려받아 코드를 쓰지 않아도 실행에는 문제가 없다.
    - 하지만 viewDidLoad 메서드가 실행될 때 하고싶은 동작이 있다면 viewDidLoad 메서드 내부에 써주어야 하는데, 이미 슈퍼클래스에 선언되어져 있는 메서드를 하위클래스에서 사용하려면 override 전치자를 써주어야 한다.
    - super라는게 어쨌건 부모 클래스의 메소드를 사용하겠다는 뜻이다.
    - 그래서 super.viewDidLoad()를 해줘서 어떤 기초적인 설정들을 `마무리`해주는 작업을 하고 그 이후에 우리가 하고싶은 작업들을 하면 된다.
    - 만약에 super.viewDidLoad()를 적지 않고 어떤 작업들을 해주게 된다면 아직 viewDidLoad 설정이 끝나지 않은 상태에서 어떤 작업들이 이루어지므로 이상한 버그와 동작이 발생할 수 있다.
- 정리하자면 viewDidLoad 후 추가 작업이 필요하다면 super 호출은 필수적이다.
- LocalizedError의 용도
    - 오류 및 발생한 이유를 설명하는 메세지를 제공하는 프로토콜이다. 따라서 에러에 따라 다양한 메세지를 보여주고 싶을 때 사용하면 적절한 프로토콜 같다. 프로퍼티들이 정의되어있는데 직관적인 이름으로 설명하지 않아도 무엇인지 알 수 있다.
- ### 엘림에게 도전과제를 받아서 해결해보았다.
- ### 스크롤바 없애기

    ![](https://i.imgur.com/fPcCuik.png)

    - 코드로 설정하기
    ```swift
    scrollView.showsHorizontalScrollIndicator = false 
    scrollView.showsVerticalScrollIndicator = false
    ```
    - 인터페이스 빌더에서 없애기
    
    ![](https://i.imgur.com/rOkoBw3.png)
    
    위 사진에서 체크를 풀어주면 된다.
- ### 직사각형 버튼을 둥근 버튼으로 만들기
    다양한 방법이 있는데.. 코드로 해주거나 인터페이스 빌더에서 해줄 수 있다. 인터페이스 빌더에서 해주려면  
    ```swift
    extension UIView {
        @IBInspectable var cornerRadius: CGFloat {
            get {
                return layer.cornerRadius
            }
            set {
                layer.cornerRadius = newValue
                layer.masksToBounds = newValue > 0
            }
        }
    }
    ```
    위와 같이 extension을 해서 IBInspectable를 추가해주는 방법이 있다. 하지만 하드코딩이라는 생각이 들어서 아래처럼 코드로 바꿔주는 방식으로 바꾸었다.
    ```swift
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calculatorButtons.forEach { button in
            button.layer.cornerRadius = button.layer.frame.size.width / 2
        }
    }
    ```
    버튼의 너비 / 2를 해서 cornerRadius를 설정해준 코드다.
    이때 `viewWillLayoutSubviews` 메소드를 써준다.
- ### `viewWillLayoutSubviews()`?
    - 뷰의 바운드가 최종적으로 결정되는 최초 시점
    - 제약이나 오토레이아웃을 사용하지 않았다면, 서브뷰의 레이아웃을 업데이트하기 적합한 시점이다.
    - 여러번 중복으로 호출될 수 있다.
        - 메인뷰의 서브뷰가 로드되는 경우
    - 이번 계산기 프로젝트에서는 버튼의 cornerRadius를 설정해주기 위해 해당 메소드를 활용해보았다. (제이티 짱...😇)
- ### 커스텀 뷰는 도대체 어떻게 만드는 거야?
    ![](https://i.imgur.com/qs5GqaX.png)

    - 만드는 과정에서 addArrangedSubview와 addSubView의 용도가 헷갈렸다.
    - addArrangedSubview는 정렬된 스택뷰의 뷰들 리스트라고 한다.
    - 따라서 `arrangedSubviews 배열` 끝에 뷰를 추가하는 메서드인 것이다.
    - 그러나 addSubview는 UIView에 정의되어있는 메소드로 다른 View 상단에 서브뷰가 추가된다고 정의되어있다. 그래서 StackView내부에서 addSubview를 해도 반응이 없었던 것이다.
    - 정리하자면 StackView에서 subview를 추가하고 싶다면 addArrangedSubview 메소드를 사용해야한다.
    ```swift
    // 우여곡절 끝에 만든 커스텀 뷰!!!!!
    class FormulaStackView: UIStackView {
        private(set) var element = [String]()
        // 초기화시 스택뷰 설정을 하는게 전부다.
        override init(frame: CGRect) {
            super.init(frame: frame)
            loadView()
        }
        
        required init(coder: NSCoder) {
            super.init(coder: coder)
            loadView()
        }
        // 이름 대충지었네...참ㅋ 걍 스택뷰 설정메소드....
        private func loadView() {
            self.axis = .horizontal
            self.alignment = .fill
            self.distribution = .fill
            self.spacing = 8
        }
        // label을 생성하여 스택뷰 하위뷰에 추가한다.
        func addLabel(_ text: String) {
            let label = UILabel()
            label.font = .preferredFont(forTextStyle: .title3)
            label.textColor = .white
            label.adjustsFontForContentSizeCategory = true
            label.text = text
            self.addArrangedSubview(label)
            element.append(text.replacingOccurrences(of: ",", with: ""))
        }
    }
    ```
- ### private extension을 하면 private 해지지않나?

    ![](https://i.imgur.com/cAOeXUt.png)

    - 나무와 이야기를 나누다가 발견한 것인데, 기존에 내가 알고있던 것은 private extension을 하면 그 내부 요소들의 접근제어가 private으로 붙는 것으로 알고있었다.
    - 그러나 [공식문서](https://docs.swift.org/swift-book/LanguageGuide/AccessControl.html#ID25)를 확인해보니 private extension을 하고 동일한 파일 내부에서는 fileprivate과 같은 접근제어로 인식해서 private extension을 사용해도 **동일한 파일 내에서는 접근**할 수 있다는 사실을 알게되었다.

&nbsp;

## 느낀점
- 엘림에게 깜짝 과제를 받고도 뚱뚱해져있는 ViewController를 해결할 수 없었다. 좀더 역할 분담을 할 수 있도록 설계하는 과정에 힘을 써야겠다.
- 공부도 중요하지만 복습도 틈틈히 하자.
- 아맞다리드미!

&nbsp;

---

- 참고링크
    - [블로그 addArrangedSubview](https://velog.io/@wonhee010/stack.addArrangedSubview)
    - [StackView에 대해서](https://bannavi.tistory.com/261)
    - [공식문서 viewWillLayoutSubviews()](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621437-viewwilllayoutsubviews)
    - [공식문서 addSubview](https://developer.apple.com/documentation/uikit/uiview/1622616-addsubview)
    - [공식문서 addArrangedSubview](https://developer.apple.com/documentation/uikit/uistackview/1616227-addarrangedsubview)
    - [블로그 인터페이스 빌더 추가하기](https://parkbi.tistory.com/20)
    - [블로그 둥근버튼 만들기](https://nexthops.tistory.com/62)
    - [How to hide/remove the scrollbar in UIScrollview in iPhone?](https://stackoverflow.com/questions/9837003/how-to-hide-remove-the-scrollbar-in-uiscrollview-in-iphone/9837117)
