# 220520 URLSession, NSCache, 셀 재사용

# TIL (Today I Learned)

5월 20일 (금)

## 학습 내용

- 이미지 캐싱 중 깜빡거리는 현상 문제 해결

&nbsp;

## 고민한 점 / 해결 방법

> 서포터즈 활동 중, 두두와 사파리의 질문으로 나도 처음으로 겪은 문제를 기록하려고 한다.

### 상황

![https://i.imgur.com/xH0xH3k.gif](https://i.imgur.com/xH0xH3k.gif)

- cell을 엄!!!청!!! 빠르게 스크롤해서 내릴때 
사라진 셀에서 시작된 이미지 다운로드가 멈추지 않아서
이미지가 깜빡 거리는 현상이 나타나는 듯 보였음.
- 즉 빠르게 스크롤 하게 되면, 
이미지 다운로드가 모두 멈추지않고 진행되면서
 이미지가 깜빡거리는 현상이 있었음.
    - 이미지가 계속 다운로드 되면서 이미지뷰의 이미지를 계속 할당하는 현상.
    
#

### 해결 방법

- 이미지 다운 받는 작업(Task)을 프로퍼티로 따로 선언해준다.
- prepareForReuse()에서 Task를 중지, 취소를 하는 작업을 추가해준다. (suspend, cancel)

```swift
private var imageDownloadTask: URLSessionDataTask?

private func downloadImage(imageURL: String?) {
   imageDownloadTask = ImageManager.shared.downloadImage(urlString: imageURL) { [weak self] result in
        switch result {
        case .success(let image):
            DispatchQueue.main.async {
                self?.thumbnailImageView.image = image
            }
        case .failure(_):
            break
        }
    }
}
```

```swift
override func prepareForReuse() {
    super.prepareForReuse()
    // 문서에 중단된 작업들만 취소할 수 있다고 나와있음!
    imageDownloadTask?.suspend()
    imageDownloadTask?.cancel()
}
```

> 이렇게해서 이미지가 다운로드 중이여도 prepareForReuse가 호출된다면 작업이 중지, 취소되기 때문에 이미지가 깜빡거리는 현상을 해결할 수 있게 되었다.

#

### 소감

그냥 의견 제시만 했을 뿐인데… 뚝딱 스무스하게 해결해버리셨다;;; 멋져부러…
나도 처음 겪는 문제라 메모해놔야징...ㅎ


---

- 참고링크
    - https://developer.apple.com/documentation/uikit/uitableviewcell/1623223-prepareforreuse
    - https://developer.apple.com/documentation/foundation/urlsessiontask/1411565-suspend
    - https://developer.apple.com/documentation/foundation/urlsessiontask/1411591-cancel
