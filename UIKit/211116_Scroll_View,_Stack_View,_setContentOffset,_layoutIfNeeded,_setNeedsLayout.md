# 211116 Scroll View, Stack View, setContentOffset, layoutIfNeeded, setNeedsLayout
# TIL (Today I Learned)


11월 16일 (화)

## 학습 내용
- 계산기 프로젝트 STEP 3 구현해보기
- Scroll View, Stack View
- 계산내역이 상단 공간을 넘어 이어지는 경우 자동 스크롤 하는 방법
    - STEP 3에 대한 스포일러가 있으니 주의하세요.
&nbsp;

## 고민한 점 / 해결 방법
- ### Stack View란?
    - ![](https://i.imgur.com/UztL3Aj.png)
    - Auto Layout을 이용해 열 또는 행에 View들의 묶음을 배치할 수 있는 간소화 된 인터페이스
    - Stack View는 Arranged Subviews 프로퍼티에 들어있는 모든 뷰의 레이아웃을 관리한다. 이 뷰들은 StackView의 arrangedSubviews 배열의 순서에 따라 StackView의 축(axis)을 따라 배치된다.
    - 레이아웃은 StackView의 축(axis), 분배(Distribution), 정렬방식(alignment), 여백(spacing)에 따라 배치된다.
    - StackView의 내부 콘텐츠로 StackView를 resize할 수 있고, 반대로 StackView의 프로퍼티를 조정하므로써 내부 콘텐츠들의 크기를 조절할 수도 있다.
    - 주의사항은 StackView의 position과 size(옵션)를 정의해줘야 한다. 그래야 StackView가 콘텐츠들의 레이아웃과 사이즈를 조정할 수 있다.
- ### 코드로 Stack View 구현해보기
    ```swift
    // 스택 뷰 생성
    let stackView = UIStackView()
    stackView.axis = .horizontal // 가로축
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 5
    ```
- ### Scroll View란?
    - 포함된 View의 scrolling하고 zooming을 허용하는 View이다.
    - UIScrollView는 `UITableView`, `UITextView`, `UICollecctionView`을 포함하여 몇가지 UIKit 클래스들의 superclass이다. 주로 사진 확대 축소할 때 많이 사용된다고 한다.
    - 스크롤 뷰는 스크롤되는 뷰들을 담고 있는 `Content Layout`과 화면에 보여지는 `Frame Layout`으로 나뉘어 진다.
    - ### Content Layout Guide
        들어오는 컨텐츠에 따라 레이아웃을 변경시켜줄테니 컨텐츠 크기를 나에게 알려줘
    - ### Frame Layout Guide
        스크롤과 관계없이 화면 안에 고정되어야 할 요소가 있어? 나에게 위치를 알려줘
    ```swift
    //콘텐츠뷰의 크기
    var contentSize: CGSize { get set }

    //콘텐츠뷰의 원점이 스크롤뷰의 원점에서 오프셋 된 지점
    var contentOffset: CGPoint { get set }

    //스크롤뷰의 원점에 대한 콘텐츠뷰의 오프셋 설정.
    func setContentOffset(_ contentOffset: CGPoint, animated: Bool)
    ```

![](https://i.imgur.com/WndyZXB.png)

* Scroll View를 추가하고 제약조건을 추가해줘도 빨간 경고가 뜬다. 이유가 뭘까?
    * 그것은 바로 ‘Scroll View안에 들어갈 Content의 사이즈가 지정이 되지 않았다’ 라는 경고다. 따라서 Scroll View 안에 Content View를 추가해주고 제약을 준다면 해결된다
* Content Layout의 크기가 Label들의 크기에 맞게 늘어난 형태이다.
    
    ![](https://i.imgur.com/WKgK57b.gif)
    
* Frame Layout Guide와 관계를 맺어 고정되어있는 Label

    ![](https://i.imgur.com/J1tfyNA.png)

* Scroll View와 Stack View를 활용한 예제를 만들어보았다.

    ![](https://i.imgur.com/N8jzWMc.png)
    
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
- ### 자동 스크롤 구현해보기
    - 스크롤 뷰의 콘텐츠 뷰 원점을 설정하는 메소드를 활용해보았다.
    ```swift
    let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
    scrollView.setContentOffset(bottomOffset, animated: false)
    ```
    - 그러나 스크롤 바가 생길때 약간 움직이면서 스크롤이 안되는...[?] 멍청해보이는 애니메이션을 취하는 문제가 발생했다.
    
    ![](https://i.imgur.com/v4OYFOe.gif)
    
    - 이 문제를 해결해보기 위해서 1차적으로 구글링을 통해 찾아보았고, 찾는데 어려움이 있어 3기 캠퍼 선배분들에게도 질문해보았지만 해결방법을 찾지 못했다.
    - 3기 캠퍼 `수박`의 도움으로 LLDB를 활용하여 처음 y좌표가 어떤 값으로 찍히는지 확인해보았으나, StackView가 추가되고 난 후 업데이트 되어 y값 좌표가 계산이 되어야 하는데, 버튼을 누르기 이전의 y좌표가 찍히는 것이 확인되었다.
    - 타이머나 비동기적으로 해당 부분을 해결해보려고 해보았으나 발만 담궈봤지 제대로 배워보지 않은 지식이라 해결하는데 많은 어려움이 있었다.
    - 이후 서포터즈 `Wody`에게 질문해보았고 얼마 지나지 않아 해결을 할 수 있게 되었다.
    - 정상적으로 하단으로 자동 스크롤이 되는 모습

    ![](https://i.imgur.com/uUW8GWB.gif)

    - `layoutIfNeeded()`라는 메소드를 활용하여 해결하게 되었다. (`도움을 주신 갓wody에게 감사의 인사를 드립니다.`) 이 메소드는 `setNeedsLayout()`과 같이 수동으로 layoutSubviews를 예약하는 행위이지만 해당 예약을 바로 실행시키는 동기적으로 작동하는 메소드다. update cycle이 올 때 까지 기다려 layoutSubviews를 호출시키는 것이 아니라 그 즉시 layoutSubviews를 발동시키는 메소드다.
    - 만일 main run loop에서 하나의 View가 setNeedsLayout을 호출하고 그 다음 layoutIfNeeded를 호출한다면 layoutIfNeeded는 그 즉시 View의 값이 재계산되고 화면에 반영하기 때문에 setNeedsLayout이 예약한 layoutSubviews 메소드는 update cycle에서 반영해야할 변경된 값이 존재하지 않기 때문에 호출되지 않는다.
    - 이러한 동작 원리로 `layoutIfNeeded()`는 그 즉시 값이 변경되어야 하는 애니메이션에서 많이 사용된다고 한다.
&nbsp;
## 추가로 공부해보아야할 것
- `setNeedsLayout()`
- `Main Run Loop`
- `Update Cycle`
- `UIView methods`
&nbsp;

---

- 참고링크
    - [UIStackView](https://developer.apple.com/documentation/uikit/uistackview)
    - [UIScrollView](https://developer.apple.com/documentation/uikit/uiscrollview)
    - [setNeedsLayout vs layoutIfNeeded](https://baked-corn.tistory.com/105)
