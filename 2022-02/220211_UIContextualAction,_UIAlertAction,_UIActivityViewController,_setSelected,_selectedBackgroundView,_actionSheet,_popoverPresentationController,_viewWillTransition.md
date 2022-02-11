# 220211 UIContextualAction, UIAlertAction, UIActivityViewController, setSelected, selectedBackgroundView, actionSheet, popoverPresentationController, viewWillTransition
# TIL (Today I Learned)

2월 11일 (금)

## 학습 내용
- UIContextualAction
- UIAlertAction
- UIActivityViewController
- UITableViewCell - `setSelected`, `selectedBackgroundView`
- iPad에서 ActionSheet를 Present를 하면 크래쉬가 발생
    - popoverPresentationController
    - viewWillTransition

&nbsp;

## 고민한 점 / 해결 방법

**[UIContextualAction에 텍스트말고 아이콘 삽입하는 방법]**

```swift
let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completeHandeler in
    self.deleteCell(indexPath: indexPath)
    completeHandeler(true)
}
deleteAction.image = UIImage(systemName: "trash.fill")
```
* 먼저 UIContextualAction 인스턴스를 생성한다.
* 생성할 때 title이 nil인게 포인트이다.
* 이후 생성한 UIContextualAction에 image를 대입해주면 된다.

> 적용된 모습

![](https://i.imgur.com/SdZTntY.png)

> `의문점`
> UIContextualAction 파라미터 중 handler의 용도는 무엇일까?
https://developer.apple.com/documentation/uikit/uicontextualaction/handler

* handler의 작업이 실제로 수행된 경우 핸들러에 true를 전달하여 작업이 완료되었다는 것을 알려주는 용도라고 한다.
* 지금같이 간단한 로직인 경우 그냥 true로 기입해주면 되겠지만, 만약 복잡한 로직이 추가되어 에러처리를 해줘야하는 경우에는 false를 전달하여 작업이 완료되지 않았다는 것을 알리는 용도인 것 같다.
* https://developer.apple.com/forums/thread/129420
* 여기 글을 참고하니 현재는 completeHandeler를 사용하지 않지만, 나중에 사용할 수 있으므로 적절한 값을 전달하는 것을 권장한다는 답변이 있다.
* 그래서 팀원들과 의논하여 true로 기입해주기로 하였다.

---

**[UIAlertAction 편집하기]**

> 단순한 글자말고 여기에도 아이콘같은걸 추가할 수 있을까? 
```swift
let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: deleteHandler)
let deleteImage = UIImage(systemName: "trash.fill")
deleteAction.setValue(deleteImage, forKey: "image")
deleteAction.setValue(0, forKey: "titleTextAlignment")
```
* setValue 메소드를 통해서 지정해줄 수 있었다.
* 단순하게 이미지와 텍스트의 alignment를 지정해주었다.
    * 0 - left
    * 1 - center
    * 2 - right

> 적용된 모습

![](https://i.imgur.com/ke4Oujp.png)

---

**[Cell이 select 되었을 때 background 색깔 입혀주기]**

> 메모를 선택하고 수정하고 있을 때 선택한 Cell의 배경색을 입혀주어 선택한 셀을 수정하고 있다는 느낌을 주고 싶었다.

* 먼저 커스텀한 UITableViewCell 클래스에서 [setSelected(_:animated:)](https://developer.apple.com/documentation/uikit/uitableviewcell/1623255-setselected) 메소드를 오버라이드 해주자.
* 그리고 selected 여부에 따라 뷰의 변화를 주는 로직을 추가한다.
```swift
override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    if selected {
        titleLabel.textColor = .white
        dateLabel.textColor = .systemGray6
        bodyLabel.textColor = .systemGray6
    } else {
        titleLabel.textColor = .label
        dateLabel.textColor = .systemGray
        bodyLabel.textColor = .systemGray
    }
}
```
* 그리고 Cell이 초기화 될 때 selectedBackgroundView도 할당해준다.
```swift
private func setUpViews() {
    ...
    let selectedBackgroundView = UIView()
    selectedBackgroundView.backgroundColor = .systemOrange
    self.selectedBackgroundView = selectedBackgroundView
}
```
> **메모**
> setSelected를 오버라이드 하지 않고 단순히 selectedBackgroundView만 할당해준다면, 셀을 선택해도 배경색이 바뀌지 않는다.

* ### 완성된 모습

![](https://i.imgur.com/pli9vhF.gif)

---

**[iPad에서 UIAlertController의 actionSheet 사용시 발생하는 오류]**

> 오류메세지

* UIActivityViewController를 present를 해주려는데 아래와 같은 오류메세지가 떴다.
```
Thread 1: "Your application has presented a UIAlertController (<UIAlertController: 0x10d813a00>) of style UIAlertControllerStyleActionSheet from CloudNotes.SplitViewController (<CloudNotes.SplitViewController: 0x11f7068f0>).
The modalPresentationStyle of a UIAlertController with this style is UIModalPresentationPopover. 
You must provide location information for this popover through the alert controller's popoverPresentationController.
You must provide either a sourceView and sourceRect or a barButtonItem. 
If this information is not known when you present the alert controller, you may provide it in the UIPopoverPresentationControllerDelegate method -prepareForPopoverPresentation."
```
* 간단히 해석하자면 iPad에서 액션시트를 present를 할 경우 모달스타일이 UIModalPresentationPopover이고, 이걸 사용할 때는 barButtonItem 또는 해당 창의 대한 위치를 설정해주어야 한다고 되어있다.
* 따라서 설정해주어야 하는 것은 2가지중 하나이다.
    * 필수적으로 sourceView 지정해주기
    * popoverPresentationController에 sourceRect 또는 barButtonItem 할당해주기

> 해결 방법

얼럿을 present 해주기 전에 다음과 같은 if문을 추가해주자!

* UIBarButtonItem에 추가해주는 방법
```swift
// UIViewController extension 내부...
if let popoverController = activityViewController.popoverPresentationController {
    popoverController.sourceView = self.splitViewController?.view
    popoverController.barButtonItem = sender // 메소드 내부라서 파라미터로 barButtonItem 전달받아 할당해주었다.
}
```
* 위치를 정해주는 방법
```swift
if let popoverController = activityViewController.popoverPresentationController {
    popoverController.sourceView = self.splitViewController?.view // present할 뷰 지정
    popoverController.sourceRect = CGRect( // 뷰의 정 가운데 위치로 지정
        x: self.splitViewController?.view.bounds.midX,
        y: self.splitViewController?.view.bounds.midY,
        width: 0,
        height: 0
    )
    popoverController.permittedArrowDirections = [] // 화살표를 빈배열로 대입
}
```
> ### 의문점
> 위치를 지정하고 나서 화면을 돌렸는데... 가운데 위치에 안있고 요상한 곳에 있다....
> ![](https://i.imgur.com/9Dk3gSK.gif)

* 해결방법
* 화면이 돌아갈 때마다 포지션을 다시 잡아주면 된다. 그걸 위해 [viewWillTransition](https://developer.apple.com/documentation/uikit/uicontentcontainer/1621466-viewwilltransition) 메소드를 활용해보겠다.
    * 이 메소드는 ViewController의 뷰 크기를 변경하기 전에 호출이 된다.
* 일단 얼럿을 present하는 뷰에 popoverController라는 변수를 만들어준다.
```swift
class SplitViewController: UISplitViewController {
    ...
    var popoverController: UIPopoverPresentationController?
```
* 그리고 viewWillTransition 메소드를 오버라이드하여 위치를 고쳐주는 로직을 추가한다.
```swift
if let popoverController = self.popoverController {
    popoverController.sourceRect = CGRect(
    x: size.width * 0.5,
    y: size.height * 0.5,
    width: 0,
    height: 0)
}
```
* UIViewController extension으로 만들어준 메소드 내부(맨 처음 얼럿을 생성하여 present하는 곳)에도 popoverController를 할당해주도록 해주었다.
```swift
let splitViewController = self.splitViewController as? SplitViewController
splitViewController?.popoverController = popoverController
```
> ### 해결된 모습
> ![](https://i.imgur.com/uy2XqZj.gif)


---

- 참고링크
    - https://stackoverflow.com/questions/30056236/uialertaction-list-of-values
    - https://royhelen.tistory.com/53
    - https://devsc.tistory.com/76
