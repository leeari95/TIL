# 220113 Cache, pagination
# TIL (Today I Learned)


1월 13일 (목)

## 학습 내용
- 오픈 마켓 프로젝트 STEP 2 피드백 답변 코멘트
- 오픈 마켓 프로젝트 STEP Bonus 진행해보기
- Cache 활동학습

&nbsp;

## 고민한 점 / 해결 방법

**[pagination]**


```swift
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height // 스크롤뷰의 전체 크기
        let yOffset = scrollView.contentOffset.y // 현재 스크롤하고 있는 위치
        let heightRemainBottomHeight = contentHeight - yOffset
        let frameHeight = scrollView.frame.size.height
        if heightRemainBottomHeight < frameHeight ,
           let hasNextPage = page?.hasNext, hasNextPage {
            currentPage += 1
            self.requestProducts()
        }
    }
```

* 현재 스크롤하고 있는 위치, 스크롤 뷰의 전체 크기를 구한다.
* 스크롤뷰 전체 높이 - 현재 스크롤 하고 있는 위치
    * 계산한다. 현재 스크롤하고 있는 yOffset 같은 경우 스크롤을 내릴 때마다 값이 늘어난다.
* 그리고 계산한 해당 값(heightRemainBottomHeight)을 스크롤 뷰의 실제 사이즈(frameHeight)와 비교하여 다음 페이지가 존재하는 경우 네트워킹을 시도하도록 설계하였다.
    * 스크롤을 할 수록 `heightRemainBottomHeight` 값이 적어진다. 
    * `frameHeight` 높이만큼 스크롤을 할 경우 `heightRemainBottomHeight`가 작아지는 순간이 온다.
    * 그때 다음페이지가 존재하는지 확인후 `네트워킹`을 시도하고
    * 네트워킹이 끝나면 콜렉션뷰를 `reloadData`를 호출하여 추가된 데이터를 가지고 셀을 더 추가한다.
    * 추가하고 나면 스크롤뷰의 전체 크기인 `contentHeight`의 크기도 늘어난다.
* 선언한 각 변수를 print를 찍어보며 스크롤을 내려보면 이해가 더 쉽다.
* ![](https://i.imgur.com/mOZGNPY.gif)
* 이 방법은 이미지 캐싱을 처리하지 않으면 버벅이는 단점이 있다. 이미지 캐싱을 처리하면 단점은 완전히 사라지는 것을 확인하였다.

---

**[Cache 활동학습]**

### 캐시란 무엇이고 어떤 역할일까?

- 자주 사용하는 데이터를 임시저장
- 성능 향상
- 데이터를 재사용
- 자주 사용되는 데이터를 임시로 저장해두는 것
- 성능의 향상을 위해 데이터를 임시로 저장해주는 것
- 캐싱된 데이터가 있다면 추가적인 자원을 소모하지 않고 caching Data를 가져다 쓸 수 있기 때문에 자원을 절약할 수 있고 애플리케이션의 처리 속도가 향상된다.

### 몇 가지 기준으로 캐시를 구분해볼까?

- 데이터를 사용하는 빈도
- CPU와의 거리
- 데이터의 특성(큰 크기의 이미지?, 바뀌지 않는 정보)

### 캐시는 클라이언트 서버 구분이 있나?

- 캐시는 구분되어질 수 있을 것 같다
    - 클라이언트는 local에 저장할 수 있는 캐시가 있을 것
    - 서버는 여러 요청에 대해 저장할 수 있는 캐시가 있을 수 있을 것
        - 서버 부하를 줄이기 위해 서버에 자주하는 요청을 캐싱해둔다.

### 캐시는 어디에 저장할까?

- CPU 레지스터
- Ram 메모리
    - 어플리케이션의 메모리 영역의 일부분을 캐싱에 사용하는 것을 의미
- 디스크
    - 데이터를 파일 형태로 디스크에 저장하는 것을 의미
    - 앱 내부 디스크(UserDefaults, CoreData)

### 또 다른 기준이 있나?

- 데이터가 저장되는 계층에 따른 구분
    - L1, L2, L3 캐시 (비용, 속도, 용량에 따른 구분)
- 읽기 및 쓰기에 따른 구분
    - 읽기 캐시
        - 한번 읽어들인 데이터를 캐시에 저장 후 추후 read시 사용
    - 쓰기 캐시
        - 읽기 캐시의 기능 뿐 아니라 write시 디스크에 바로 올리지 않고 캐시에 임시로 저장후 추후 캐시 데이터를 모아 한번에 디스크에 저장
            - 매번 변경 시 디스크에 여러번 저장할 필요가 없다.

### 캐시를 구현할 때 고려해야 하는 캐시 운용 정책에는 어떤것들이 있을까?

- 보안성
    - 캐시 접근 및 저장 관련
- 데이터 수명
- 캐시 교체 정책 (Cache Replacement Policy)
    - 데이터 사용시간에 따른 교체 (사용시간 작은 것 부터)
    - LRU, FIFO, LFU 구조에 따라 교체
    - Random, NUR, Optional 등등
- 저장하는 시점에 따른 정책

### iOS 환경에서 캐싱하는 방법에는 무엇무엇이 있을까?

- 메모리 캐싱 방법 : NSCache, URLCache 등등..
    - 어플리케이션의 메모리 영역의 일부분을 캐싱에 사용하는 것을 의미
    - 어플리케이션이 종료되어 메모리에서 해제되면 이 영역에 있던 리소스들은 OS에 반환되면서 메모리 캐싱되어있던 리소스들은 사라지게 된다.
- 디스크 캐싱 방법 : FileManager 를 통해서 Cache 디렉토리를 관리할 수 있다.
    - 어플리케이션을 껐다 켜도 데이터가 사라지지 않지만 디스크 캐싱이 반복적으로 발생하면 어플리케이션이 차지하는 용량이 커진다.
        - ex) 카카오톡에서 이미지나 동영상을 디바이스에 저장하지 않더라도 눈으로 보기 위해서는 파일을 다운로드 받아야하는데, 이때 다운로드 받은 파일들이 Disk Caching되어 앱을 종료했다가 실행해도 볼 수 있다.

---

### - AlamofireImage 라이브러리와 Kingfisher 라이브러리의 캐시 정책은 어떤 차이가 있나요?

- AlamofireImage
    - AutoPurgingImageCache는 CachedImages라는 Array를 들고 있다. disk는 사용하지 않는다.
    - memory warning notification을 받으면 AutoPurgingImageCache의 removeAllimages를 호출한다.
    - AutoPurgingImageCache에 이미지를 add했을 때 메모리 용량을 설정값보다 많이 차지하고 있는 경우 lastAccessData로 정렬하여 지운다. - LRU(Least Recently Used) 방식
    - URLCache는 지워주는 부분이 따로 없기 때문에 직접 지워줘야 한다.
    - expire 정책이 없다.
    - [https://github.com/Alamofire/AlamofireImage#image-cache](https://github.com/Alamofire/AlamofireImage#image-cache)
    - GIF 처리를 별도로 할수 없다.
        - 직접 Custom Alamofire Response Serializer를 만들도록 안내하고 있다.
- Kingfisher
    - 메모리와 디스크 모두를 위한 하이브리드 캐시
        - 열거형으로 디스크와 메모리가 정의되어있음.
    - 만료날짜 및 크기 제한 설정 가능
    - 이미지의 URL만 알고 있다면 킹피셔를 이용하여 코드 두줄로 이미지를 캐싱할 수 있다.
        
        ```swift
        let url = URL(string: "https://example.com/image.png")
        imageView.kf.setImage(with: url)
        ```
        
    - memory warning notification을 받았을 때는 clearMemoryCache를 호출한다.
        - memoryCache에 있는 것들을 전부 지운다.
        - 앱이 꺼지거나 백그라운드 진입했을 때는 clearExpiredDiskCache를 호출한다.
            - expire 된 것들을 지운 다음 여전히 디스크 용량이 많이 차지하고 있으면 contentAccessData로 정렬해서 지운다
    - GIF 처리를 할 수 있다.
        - AnimatedImageView를 사용하면 메모리 로드를 줄일 수 있지만 CPU load가 크다.

### - 각 라이브러리에서 캐시 기능을 지원하기 위해 활용하는 Cocoa Layer의 주요 기능(클래스, 구조체 등)은 무엇이 있나요?

* 기본 기능들을 가지고 어떻게 조합되어있는지?

- AlamofireImage
    - URLCache (클래스)
    - URLSession
    - URLSessionDataTask
    - CachedURLResponse
- Kingfisher
    - URLSession
    - NSCache
    - NSLock
    - FileManager

### - 만약 라이브러리에서 on disk cache를 지원한다면, 캐시를 저장하는 디스크 영역은 어디인가요?

- `let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]`

### 추가미션 : 저번 네트워크 프로젝트에서 이미지 캐싱을 적용해보자.

```swift
class MyCell: UITableViewCell {
... 
    override func prepareForReuse() { // 이미지를 지우도록 설정
        picture.image = nil
    }
}

class ViewController: UIViewController, UITableViewDataSource {
...
    let cache = NSCache<NSString, UIImage>() // 캐시 인스턴스 생성
...

// UITableViewDataSource 프로토콜 채택후 테이블뷰 메소드 내부...
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

...

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            
            if indexPath == tableView.indexPath(for: cell) {
                if let cachedData = self.cache.object(forKey: NSString(string: imageURL)) {
                    DispatchQueue.main.async {// 캐싱된 데이터가 존재하는지 확인
                        cell.picture.image = cachedData
                    }
                    return
                }
            }
            
            if let error = error {
                print("오류!!!!!!!!!! ", error.localizedDescription)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      print("오류!!!!!!!!!!")
                      return
                  }
            guard let data = data, let image = UIImage(data: data) else {
                print("데이터 변환 오류!!")
                return
            }
            
            if indexPath == tableView.indexPath(for: cell) { // indexPath 확인하고있음.
                self.cache.setObject(image, forKey: NSString(string: imageURL)) // 이미지 캐싱하고
                DispatchQueue.main.async {
                    // 캐싱이 되어있지 않다면,
                    cell.picture.image = image // 이미지 대입
                }
            }
        }
        
        task.resume()
        
        return cell
    }
}
```
---

- 참고링크
    - https://green1229.tistory.com/57
    - https://ios-development.tistory.com/658
    - https://ios-development.tistory.com/715
