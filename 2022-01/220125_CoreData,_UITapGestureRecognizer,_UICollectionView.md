# 220126 CoreData, UITapGestureRecognizer, UICollectionView
# TIL (Today I Learned)


1월 25일 (화)

## 학습 내용
- 오픈마켓2 STEP 2
- UITapGestureRecognizer + UIScrollView
- CollectionView의 Cell 포커스를 이동시키기


&nbsp;

## 고민한 점 / 해결 방법

**[2번 탭했을 때 이미지 확대/축소하기]**

* 먼저 2번 탭했을 때 메소드를 실행하기 위해 UITapGestureRecognizer를 선언한다.
```swift
private lazy var zoomingTap: UITapGestureRecognizer = {
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
    tap.numberOfTapsRequired = 2
    return tap
}()
```

```swift
@objc private func handleZoomingTap(_ sender: UITapGestureRecognizer) {
    let location = sender.location(in: sender.view) // 터치한 부분의 뷰의 좌표를 반환하는 메소드
    zoom(point: location, animated: true) // 지정한 좌표 부분을 zoom 해주는 메소드 호출
}

private func zoom(point: CGPoint, animated: Bool) {
    let currectScale = scrollView.zoomScale // 현재 줌 스케일
    let minScale = scrollView.minimumZoomScale 
    let maxScale = scrollView.maximumZoomScale

    let finalScale = currectScale == minScale ? maxScale : minScale // 현재 스케일이 minimum이면 확대, 아니라면 축소
    let zoomRect = zoomRect(scale: finalScale, center: point) // 스케일에 따른 rect를 설정하는 메소드 호출
    scrollView.zoom(to: zoomRect, animated: animated) // 설정한 rect에 확대, 혹은 축소를 해주는 메소드 호출
}

private func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
    var zoomRect = CGRect.zero
    let bounds = scrollView.bounds // 스크롤뷰의 bounds를 구한다.

    // zoomRect의 크기를 설정
    zoomRect.size.width = bounds.size.width / scale
    zoomRect.size.height = bounds.size.height / scale

    // zoomRect의 위치를 설정
    zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
    return zoomRect
}
```
* 2번 탭했을 때 Scale, width, height, origin.x, origin.y 모두를 계산하고 설정하는 기능을 구현하여 해당 기능을 구현해주었다.
    * 자세한건.. 주석 메모 참고... 맞게 적었는지[?]는 잘모르겠지만, 일단 이해한대로 적어보았다.
* 좀더 생각해봐야할 부분
    * zoom이 되었을 때 이미지가 스크롤 바깥으로 빠져나가지 못하도록 하는 방법 더 고민해보기

---

**[지정한 indexPath로 CollectionView를 이동시키기]**

```swift
let indexPath = IndexPath(item: self.currentPage, section: 0) // 현재 페이지에 대한 값을 프로퍼티로 정의하여 활용
collectionView.scrollToItem(
    at: indexPath,
    at: [.centeredHorizontally, .centeredVertically], // 스크롤의 방향을 설정
    animated: false // 이걸 true로 하면 스크롤 되는게 눈에 보여서 false로 꺼버림
)
```
* scrollToItem 메소드를 활용하여 view가 load되는 시점에 지정한 indexPath로 scroll을 해주는 방식으로 구현하였다.

---

- 참고링크
    - https://www.youtube.com/watch?v=YpVZgQW1TvQ
    - https://developer.apple.com/documentation/uikit/uicollectionview/1618046-scrolltoitem
