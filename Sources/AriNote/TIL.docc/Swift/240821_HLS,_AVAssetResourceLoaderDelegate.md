# 240821 HLS, AVAssetResourceLoaderDelegate


스트리밍 되고 있는 방송이 종료되었는지 여부를 인지할 수 있는 방법.


8월 21일 (수)


# 학습내용

스트리밍 중인 방송의 종료 여부를 어떻게 판단할 수 있을까?
일단 HLS는 뭔지 잘... 모르겠다. 알아보자!

## HLS(HTTP Live Streaming)

* Apple이 개발한 스트리밍 프로토콜
* 비디오와 오디오 콘텐츠를 인터넷을 통해 실시간으로 전송하기 위해 설계되었음.
* HLS는 특히 대규모 시청자들에게 안정적인 스트리밍 서비스를 제공할 수 있도록 최적화되어 있으며 네트워크 환경이 다양할 때에도 유연하게 동작함.
* 현재 대부분의 플랫폼에서 지원되며, 특히 iOS, macOS 기기에서 기본적으로 지원함.

### HLS 작동 원리

* 미디어 파일 분할
    * 원본 비디오 파일은 짧은 조각(segment)으로 분할된다.
    * 각 조각은 독립적인 MPEG-TS(Transport Stream)파일로 저장되며, 클라이언트가 어떤 순서로든 조각을 요청하고 재생할 수 있다.
* 플레이 리스트 생성
    * HLS는 미디어 세그먼트를 관리하기 위해 `m3u8` 확장자를 가진 텍스트 파일인 플레이 리스트 파일을 사용한다.
    * 이 파일은 세그먼트의 URL과 메타데이터를 포함하며 클라이언트가 어떤 세그먼트를 재생할지 결정할 때 참고한다.
* 클라이언트 요청
    * 클라이언트(브라우저 또는 앱)는 플레이리스트 파일을 다운로드하고 미디어 세그먼트의 URL을 추출한 후 순차적으로 세그먼트를 요청하여 재생한다.
    * 클라이언트는 네트워크 상태에 따라 적절한 비트레이트와 스트림을 선택할 수 있다.
* 실시간 적용
    * 네트워크 조건에 따라 클라이언트는 자동으로 다른 비트레이트와 스트림으로 전환할 수 있다.
    * 네트워크 속도가 느려지면 클라이언트는 더 낮은 비트레이트의 스트림을 선택하여 버퍼링을 최소화한다.


## HLS 구조

#### 미디어 세그먼트

미디어 파일은 일정한 길이의 세그먼트로 분할하며 각 세그먼트는 독립적으로 인코딩되어 있고 클라이언트는 이를 개별적으로 다운로드하고 재생할 수 있다.

* MPEG-TS (Transport Stream): HLS에서 사용하는 미디어 파일 포맷으로, 각각의 세그먼트는 독립적인 MPEG-TS 파일이다. 이 파일 포맷은 낮은 오버헤드와 실시간 전송에 적합하다.

#### 재생 목록 (playlist)

* .m3u8 파일 (플레이리스트 파일): 세그먼트의 위치와 메타데이터를 설명하는 텍스트 파일이다. 이 파일은 클라이언트가 어떤 미디어 파일을 재생할지 결정하는 데 중요한 역할을 한다.

재생 목록의 종류는 아래와 같다:

* Master Playlist: 여러 버전(예: 다양한 비트레이트, 해상도)의 스트림을 제공할 때 사용되며, 각 스트림의 플레이리스트 파일에 대한 참조를 포함합니다.
* Media Playlist: 각 개별 스트림(특정 비트레이트와 해상도)에 대한 세그먼트 리스트를 포함합니다.

```m3u8
// 마스터 플레이 리스트 예시

#EXTM3U
#EXT-X-STREAM-INF:BANDWIDTH=1280000,RESOLUTION=640x360,CODECS="avc1.420029,mp4a.40.2"
http://example.com/low.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=2560000,RESOLUTION=1280x720
http://example.com/mid.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=5120000,RESOLUTION=1920x1080
http://example.com/high.m3u8
```

```m3u8
// 미디어 플레이 리스트 예시

#EXTM3U
#EXT-X-TARGETDURATION:10
#EXT-X-VERSION:3
#EXT-X-MEDIA-SEQUENCE:0

#EXTINF:10.0,
http://example.com/segment0.ts
#EXTINF:10.0,
http://example.com/segment1.ts
#EXTINF:10.0,
http://example.com/segment2.ts
#EXTINF:10.0,
http://example.com/segment3.ts

#EXT-X-ENDLIST
```

### 플레이 리스트 태그

* `#EXTM3U`: 파일의 시작을 나타내는 태그.
* `#EXT-X-STREAM-INF`: 스트림 정보(비트레이트, 해상도 등)를 나타내는 태그.
* `#EXTINF`: 각 세그먼트의 길이를 나타내는 태그.
* `#EXT-X-ENDLIST`: 재생 목록의 끝을 나타내는 태그.
* `BANDWIDTH`: 스트림의 평균 비트레이트를 나타냄(단위: bps)
* `RESOLUTION`: 비디오 해상도
* `CODECS`: 비디오와 오디오 트랙의 코덱을 명시.
* `#EXT-X-TARGETDURATION`: 각 세그먼트의 최대 길이를 지정한다(초 단위).
* `#EXT-X-VERSION`: 플레이리스트 파일의 HLS 버전
* `#EXT-X-MEDIA-SEQUENCE`: 플레이리스트에서 첫 번째 세그먼트의 시퀀스 번호를 지정한다.

자주 사용되는 코덱은 다음과 같다:

| **속성**               | **avc1.420029, mp4a.40.2**                          | **avc1.4d401f, mp4a.40.2**                          |
|------------------------|----------------------------------------------------|-----------------------------------------------------|
| **비디오 코덱**        | H.264/AVC                                           | H.264/AVC                                            |
| **비디오 프로파일**    | Baseline Profile (`42`)                             | Main Profile (`4d`)                                  |
| **비디오 레벨**        | Level 4.1 (`29`)                                    | Level 3.1 (`1f`)                                     |
| **오디오 코덱**        | MPEG-4 AAC (`mp4a`)                                 | MPEG-4 AAC (`mp4a`)                                  |
| **오디오 프로파일**    | AAC LC (Low Complexity) (`40.2`)                    | AAC LC (Low Complexity) (`40.2`)                     |
| **사용 사례**          | 저전력, 저대역폭 장치에 적합 (모바일 기기 등)      | 고화질, 고해상도 비디오 재생에 적합 (데스크톱, TV 등)|

## HLS 장점과 단점

* 장점
    * 대부분의 기기와 브라우저에서 기본적으로 지원된다.
    * 네트워크 상태에 따라 스트림의 비트레이트를 자동 조절하며 끊김 없이 스트리밍을 즐길 수 있다.
    * HLS는 콘텐츠를 작은 세그먼트로 나누어 전송하기 때문에 서버는 다수의 클라이언트에 효과적으로 스트림을 제공할 수 있다. 또한, CDN(Content Delivery Network)과 쉽게 통합되어 대규모 배포가 가능하다.
    * HLS는 DRM(Digital Rights Management)과 암호화를 지원하여 콘텐츠를 보호할 수 있다. 예를 들어, Apple의 FairPlay 스트리밍 기술을 통해 비디오 콘텐츠를 보호할 수 있다.
* 단점
    * HLS는 세그먼트를 다운로드하고 재생하는 방식이기 때문에 라이브 스트리밍의 경우 지연시간이 발생할 수 있다. 세그먼트의 길이가 길수록 지연 시간이 더 길어질 수 있다.
    * 초기 재생 시 여러 세그먼트를 미리 로드해야 하므로, 다른 스트리밍 프로토콜에 비해 초기 버퍼링 시간이 길어질 수 있다.
    * HLS는 Apple이 개발한 기술로 Apple 생태계에서의 지원이 강력하지만 일부 플랫폼에서는 다른 스트리밍 프로토콜(DASH)이 더 선호될 수 있다.


# 

여기까지 HLS에 대해서 한번 간단히 알아보았다.
그렇다면 iOS에서 HLS를 사용하는 경우 스트리밍의 종료 시점을 감지하는 방법에 대해서 알아보자.

## 태그를 활용하는 방법

HLS에서 `m3u8` 플레이리스트의 마지막에 `#EXT-X-ENDLIST` 태그가 포함되어 있는 경우 스트림이 끝났음을 나타낼 수 있다. 

## HTTP 상태 코드 활용하기

HLS 스트리밍에서 서버가 라이브 스트리밍의 종료를 클라이언트에게 알리기 위해 사용되는  방법 중 하나다.

스트리밍이 종료되면 HTTP 상태 코드(예: 404, 410)을 반환하여 스트리밍이 더이상 제공되지 않음을 알려줄 수 있다.

스트리밍이 종료되면 서버가 더이상 플레이리스트를 제공하지 않으며, 클라이언트가 요청을 보낼때 404 오류를 반환하게 된다.

## AVAssetResourceLoaderDelegate 사용

iOS에서 위와 같이 태그나 HTTP 상태 코드를 활용해 라이브 스트림이 종료됨을 감지하려면 AVPlayer와 관련된 네트워크 요청을 모니터링해야 한다.

일반적으로 AVPlayer는 내부적으로 네트워크 요청을 관리하므로 직접적으로 HTTP 상태 코드를 확인하는 것은 어려울 수 있지만, AVAssetResourceLoaderDelegate를 사용하면 네트워크 요청을 가로채고 HTTP 응답을 분석할 수 있다.

아래는 구현 예시이다:

```swift
class StreamResourceLoaderDelegate: NSObject, AVAssetResourceLoaderDelegate {
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        
        guard let url = loadingRequest.request.url else {
            return false
        }
        
        // 플레이리스트 파일을 요청하는 경우에만 처리
        if url.absoluteString.hasSuffix(".m3u8") {
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    // HTTP 상태 코드 확인
                    if httpResponse.statusCode == 404 || httpResponse.statusCode == 410 {
                        print("Stream has ended with status code: \(httpResponse.statusCode)")
                        // 여기서 스트리밍 종료를 처리
                        loadingRequest.finishLoading(with: URLError(.badServerResponse))
                    } else if let data = data {
                        // 정상적으로 데이터를 수신한 경우
                        // 여기서 태그를 분석해볼 수 있다.
                        loadingRequest.dataRequest?.respond(with: data)
                        loadingRequest.finishLoading()
                    }
                } else if let error = error {
                    // 오류 발생 시 처리
                    print("Error loading resource: \(error)")
                    loadingRequest.finishLoading(with: error)
                }
            }
            task.resume()
            
            return true
        }
        
        return false
    }
}

```


이후 AVURLAssets을 생성할 때 `resourceLoader.delegate`를 설정하여 모든 리소스 로딩 요청이 해당 delegate를 통해 처리되도록 한다.

```swift
        // 스트리밍 URL 설정 (https를 customscheme으로 변경)
        guard let url = URL(string: "https://example.com/live/playlist.m3u8") else { return }
        
        // URL의 스킴을 "customscheme"으로 변경
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.scheme = "customscheme"
        
        guard let customSchemeURL = components?.url else { return }
        
        // AVURLAsset 생성 및 delegate 설정
        let asset = AVURLAsset(url: customSchemeURL)
        asset.resourceLoader.setDelegate(resourceLoaderDelegate, queue: DispatchQueue.main)
        
        // AVPlayerItem 생성
        let playerItem = AVPlayerItem(asset: asset)
```

여기서 스킴을 임의로 변경하고 있는데, 그 이유는 다음과 같다:

* `http`, `https` 스킴을 사용하면 `AVPlayer`, `AVURLAsset`이 시스템의 표준 네트워크 스택을 통해 리소스를 로드한다.
* 즉 `AVAssetResourceLoaderDelegate`가 개입하지 않고 시스템이 직접 URL 요청을 수행한다.
* `AVAssetResourceLoaderDelegate`는 주로 비표준 스킴이나 DRM 보호된 콘텐츠처럼 시스템이 기본적으로 처리하지 않는 리소스 로딩을 처리할 수 있도록 설계되었다.

따라서  `http`, `https` 스킴을 사용하면 `AVFoundation`이 네트워크 요청을 직접 처리하므로, 커스텀 스킴을 통해 `AVAssetResourceLoaderDelegate`를 통해 네트워크 요청을 가로채거나 처리하도록 해주어야 한다.

---


# 참고 링크

- [https://developer.apple.com/documentation/avfoundation/avassetresourceloaderdelegate](https://developer.apple.com/documentation/avfoundation/avassetresourceloaderdelegate)
- [https://developer.apple.com/documentation/http-live-streaming](https://developer.apple.com/documentation/http-live-streaming)
- [https://developer.apple.com/documentation/http-live-streaming/live-playlist-sliding-window-construction](https://developer.apple.com/documentation/http-live-streaming/live-playlist-sliding-window-construction)
- [https://developer.apple.com/documentation/http-live-streaming/video-on-demand-playlist-construction](https://developer.apple.com/documentation/http-live-streaming/video-on-demand-playlist-construction)
