# 211208 Navigation Bar, UIImageView, NSMutableAttributedString, addAttribute
# TIL (Today I Learned)


12월 8일 (수)

## 학습 내용
- 만국박람회 STEP 2 진행

&nbsp;

## 고민한 점 / 해결 방법
**[Navigation Bar 감추기]**
* 스토리보드에서 감추기
    * 네비게이션 컨트롤러를 클릭 후
    * 우측 Inspector에서 Shows Navigation Bar 체크를 해제해준다.
    * ![](https://i.imgur.com/8jpAm1w.png)
* 코드로 감추기
    * 네비게이션 컨트롤러로 Embed In 되어있는 ViewController 내부에 다음과 같은 코드를 추가해준다.
        * `self.navigationController?.isNavigationBarHidden = true`

위와 같은 방법은 Navigation Controller에 연결되어있는 모든 ViewController의 Navigation Bar가 숨겨진다.

특정 ViewController의 Navigation Bar를 숨기려면 다음과 같은 방법이 있다.
해당 방법은 View Life Cycle 메소드를 활용하여
뷰가 화면에 보일 때 Navigation Bar를 숨기고 
다른창으로 넘어갈때 다시 보이게하는 방법이다.
```swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
}

override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
}
```

---

**[Asset에 있는 이미지를 UIImageView에 적용하기]**
* imageLiteral을 활용하여 설정하기
    * ![](https://i.imgur.com/oe4a7HV.png)
    * ImageView.image =  #imageLiteral(resourceName: "image”)
* UIImage init으로 설정하기
    * ImageView.image = UIImage(named: “image”)

---


**[Label의 특정 글자 크기 변경 방법]**
```swift
// 내가 적용하고 싶은 폰트 사이즈
let fontSize = let fontSize = UIFont.systemFont(ofSize: 30)

// label에 있는 Text를 NSMutableAttributedString로 초기화해준다.
guard let text = label.text else {
    return
}
let attributedString = NSMutableAttributedString(string: text)

// 위에서 만든 attributedString에 addAttribute 메소드를 통해 Attribute를 적용해준다.
let range = (text as NSString).range(of: prefix) // 편집하고 싶은 글자의 범위를 구해준다.
attributedString.addAttribute(.font, value: fontSize, range: range)

// 최종적으로 내 label에 속성을 적용한다.
label.attributedText = attributedString
```
* 위 방법을 적용하여 만든 함수
```swift
func editFontSize(of prefix: String ,in label: UILabel) {
    guard let text = label.text else {
        return
    }
    let fontSize = UIFont.systemFont(ofSize: label.font.pointSize + 3)
    let attributedString = NSMutableAttributedString(string: text)
    let range = (text as NSString).range(of: prefix)
    attributedString.addAttribute(.font, value: fontSize, range: range)
    label.attributedText = attributedString
}
```
* 사이즈 외에도 폰트나, 색상을 부분적으로 바꿔줄 수도 있다.
    * NSForegroundColorAttributeName
    * NSStrokeColorAttributeName
    * NSUnderlineStyleAttributeName
    * NSBackgroundColorAttributeName
    * NSStrikethroughStyleAttributeName

---

- 참고링크
    - https://zeddios.tistory.com/300
