# 220118 UITextField, Keyboard, UITextView, ScrollView, touchesBegan, Recognizer, UIImage
# TIL (Today I Learned)


1월 18일 (화)

## 학습 내용
- UITextField
    - 키보드 타입 설정하기
    - 키보드가 화면가리는 문제를 해결하기
    - 키보드를 화면에서 내리는 방법
- 이미지의 사이즈를 줄이는 방법

&nbsp;

## 고민한 점 / 해결 방법

**[키보드 타입 설정하기]**

* 정말 간단하다. 
```swift
func setUpKeyboardType() { // 원하는 타입을 대입해주면 끝~
    nameTextField.keyboardType = .namePhonePad
    priceTextField.keyboardType = .decimalPad
    discountedPriceTextField.keyboardType = .decimalPad
    stockTextField.keyboardType = .numberPad
}
```

---

**[키보드가 콘텐츠를 가리지 않도록 하는 방법]**

* ScrollView를 활용하기
    * 키보드의 위치만큼 스크롤의 위치를 바꿔주는 방식
* NotificationCenter 활용
    * 키보드가 나타나고 사라질 때마다 Notification의 알림을 받기
    * iOS 9 이상 버전을 타겟으로 앱을 만든다면 자동으로 removeObserver를 해준다. 따라서 신경쓰지 않아도 된다!
        * https://useyourloaf.com/blog/unregistering-nsnotificationcenter-observers-in-ios-9/
```swift
private func setUpNotification() {
    NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillShow(_:)),
        name: UIResponder.keyboardWillShowNotification, // show
        object: nil
    )
    NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillHide(_:)),
        name: UIResponder.keyboardWillHideNotification, // hide
        object: nil
    )
}

```
* 알림을 받았을 때 호출할 메소드 구현하기
```swift
@objc private func keyboardWillShow(_ notification: Notification) {
    guard let userInfo = notification.userInfo as NSDictionary?,
          var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
          let scrollView = self.superview?.superview as? UIScrollView,
          let view = self.superview?.superview?.superview else {
              return
          }
    var contentInset = scrollView.contentInset
    contentInset.bottom = keyboardFrame.size.height
    scrollView.contentInset = contentInset
    scrollView.scrollIndicatorInsets = scrollView.contentInset
}

@objc private func keyboardWillHide(_ notification: NSNotification) {
    guard let scrollView = self.superview?.superview as? UIScrollView else {
        return
    }
    scrollView.contentInset = UIEdgeInsets.zero
    scrollView.scrollIndicatorInsets = scrollView.contentInset
}
```
* Noti로 받은 keyboardFrame을 바인딩 한다.
* 콘텐츠의 상하좌우로 안쪽 여백을 주는 contentInset의 bottom을 keyboardFrame.size의 높이로 대입해준다.
    * ScrollView의 서브뷰 크기를 변경하지 않고 스크롤 뷰 크기를 확장한다는 의미
    * ![](https://soulpark.files.wordpress.com/2012/12/ec8aa4ed81aceba6b0ec83b7-2012-12-30-ec98a4ed9b84-5-12-32.png)
    * 키보드로 인해 가려지는 부분을 스크롤뷰 아래쪽으로` keyboardFrame 사이즈의 높이만큼 버퍼를 추가`하여 스크롤뷰를 확장함으로써 키보드 가림현상을 해결하는 것이다.
* contentInset을 변경하면 `scrollIndicatorInsets`에도 영향을 미친다.
    * 스크롤 시 보이는 스크롤 표시를 말한다.
* `scrollIndicatorInsets`가 `contentInset으로` 추가한 버퍼공간에도 표시가 된다.
    * 이를 방지하기 위해서는 `scrollIndicatorInsets` 속성도 같이 변경해주어야 한다.
* ![](https://i.imgur.com/xywzYXO.gif)
* 이렇게 스크롤뷰를 활용하면 키보드가 화면가리는 현상을 손쉽게 해결할 수 있다.

---

**[그럼.. UITextView는...어떻게?]**

* 텍스트 필드는 위 방법으로 해결이 되었지만 UITextView는 어떻게 스크롤이 따라오게 만들까?
    * 이 부분은 텍스트뷰의 스크롤 기능을 false로 제거한다.
        * `TextView.isScrollEnabled = false`
    * 그리고 오토레이아웃으로 TextView의 높이가 늘 고정되어있는 것이 아니라 늘어날 수도 있도록 `priority`를 조절해주면 된다.
* 위와 같이 세팅한다면, 텍스트뷰가 안에 Text가 길어질 수록 높이가 늘어나고, 그에 따라 스크롤도 자동으로 내려온다.
    * 해결해보면서 메모장도 이런 방식인건가? 했다...!
* ![](https://i.imgur.com/P3z2Ydx.gif)

---

**[키보드를 화면에서 없애는 방법]**

* 삽질을 좀 해본 결과 여~러 방법이 있었다.
    * Recognizer를 등록해서 터치시 키보드를 사라지도록 하기.
    ```swift
    // Recognizer를 활용해서 뷰컨을 터치하면 키보드 사라지는 코드
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    ```
    * touchesBegan 메소드를 활용하여 View를 터치시 키보드를 사라지게 하기.
    ```swift
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.endEditing(true)
    }    
    ```    
    * ScrollView에 keyboardDismissMode를 drag로 설정해주기
        * `scrollView.keyboardDismissMode = .onDrag`
* 이번 프로젝트에서는 touchesBegan과 ScrollView에 keyboardDismissMode를 활용하여 키보드를 내릴 수 있도록 해주었다.
* addGestureRecognizer는 실험해보았는데, 이걸 등록했을 때 같은 뷰컨에 있는 collectionView의 delegate 메소드가 호출되지 않는 현상을 발견하게 되었다.
    * 열심히 구글링 해보았지만 잘모르겠다....

---

**[이미지를 리사이즈 하는 방법]**

* 크기를 줄이고, 화질을 낮춰서 압축을 한다.
* UIImage를 extension하여 기능을 구현했다.
* 최대 파일 크기를 지정하고 그 이하가 될 때까지 반복하며 이미지의 크기를 줄인다.

```swift
extension UIImage {
    func resized(percentage: CGFloat) -> UIImage { // 사이즈를 퍼센트만큼 리사이즈하는 메소드
        let size = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }

    func compress() -> UIImage { // 호출시 Data의 count를 기준으로 용량에 맞게 화질을 낮춘다.
        var compressImage = self
        var quality: CGFloat = 1 // 화질
        let maxDataSize = 307200 // 최대크기
        guard var compressedImageData = compressImage.jpegData(compressionQuality: 1) else {
            return UIImage()
        }
        while compressedImageData.count > maxDataSize {
            quality *= 0.8 // 20퍼센트 씩 감소
            compressImage = compressImage.resized(percentage: quality)
            compressedImageData = compressImage.jpegData(compressionQuality: quality) ?? Data()
        }
        return compressImage
    }
}
```
---

**[추가로 공부가 필요한 부분]**

- touchesBegan vs TapGestureRecognizer
    - https://velog.io/@wonhee010/touchesBegan-vs-TapGestureRecognizer
- Cell별로 내용에 맞춰서 dynamic height 정하기
    - https://i-colours-u.tistory.com/8
    - https://www.vadimbulavin.com/collection-view-cells-self-sizing/
- 아래로 당겨서 새로고침 하기
    - https://hyongdoc.tistory.com/367
- 페이지 컨트롤 활용방법
    - https://moonibot.tistory.com/29

---

- 참고링크
    - https://developer.apple.com/documentation/uikit/uikeyboardtype
    - https://stackoverflow.com/a/32583809
    - https://stackoverflow.com/questions/68714952/how-to-achieve-a-responsive-auto-scrolling-when-uitextview-is-placed-in-uiscroll/68728597#68728597
    - https://stackoverflow.com/questions/37028511/dismiss-keyboard-in-textview-while-scroll
    - https://soulpark.wordpress.com/2012/12/30/contentinset-and-scrollindicatorinsets-properties-of-uiscrollview/
    - https://soulpark.wordpress.com/2012/11/30/uiview-frame-bounds-coordinate-conversion/
