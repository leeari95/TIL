# 220923 URLSession, CachePolicy

# TIL (Today I Learned)

9월 23일 (금)

## 학습 내용

- 네트워크 요청 시 Response 캐시 적용 하지 않는 방법 (`문제 해결`)

&nbsp;

## 고민한 점 / 해결 방법
 
>![](https://i.imgur.com/4EWNm90.gif)
>
> 스타 체크 후 새로고침 시 이전 데이터를 불러와서 제대로 업데이트 되지 않는 현상

* `문제 상황` Github API로 스타표시를 한 후, 사용자의 스타 체크한 레파지토리 목록을 불러올 때, 업데이트 된 목록이 아니라 기존에 불러왔었던 Response를 불러오는 문제로 레파지토리 목록이 업데이트가 제대로 되지 않는 현상이였다. (PUT > GET)
	* `추측해보기` 왜 PUT 이후 GET을 요청했을 때, 업데이트 된 레파지토리 목록을 불러오는데 시간이 걸릴까? > API 자체적인 문제인가? 포스트맨으로도 테스트 해보자! > 정상이다. 혹시 리스폰스를 캐시처리 하나...?
* `이유` 내 생각에는 기존에 요청해서 받았던 리스폰스가 캐싱되어 새롭게 업데이트 된 데이터를 불러오는 것이 아니라 캐시처리 되어있는 리스폰스를 불러오는 것 같다는 생각이 들었다.
*  `첫 번째 시도` URLSessionConfiguration의 속성을 ephemeral로 할당한 후 테스트 해본 결과, 정상적으로 새롭게 업데이트 된 레파지토리를 받아왔다.
	* 하지만 이걸로 해결되었다고 결론내기가 찝찝했다. 그 이유는 ephemeral 속성의 경우 다른 네트워크 요청들도 캐시가 적용되지 않는다는 점이다. 이미지의 경우는 캐시처리가 되는 것이 더 도움이 될탠데... 하는 생각이 들어서 특정 요청만 캐시처리를 하지 않도록 하고 싶었다.
*  그래서 다시 찾아본 결과 URLRequest 내부 속성중에는 캐시정책을 설정할 수 있는 속성이 있었다.
	*  https://developer.apple.com/documentation/foundation/nsurlrequest/cachepolicy
* 또한 아예 헤더에 Cache-Control을 할당해서 리스폰스를 캐시하지 않겠다고 하고 네트워크를 요청할 수도 있다.
	* https://www.blog-dreamus.com/post/cache-control-%EC%9D%B4-%ED%95%84%EC%9A%94%ED%95%9C-%EC%9D%B4%EC%9C%A0
* `해결 방법` 위와 같이 URLRequest 속성중 `cachePolicy`를 `.reloadIgnoringLocalCacheData`로 할당해주어서 해결하였다. 헤더에 Cache-Control를 할당주어 데이터를 요청 시에 Cache 관련 제어를 하는 방법도 있지만 하드코딩이라는 생각이 들어서 이러한 방법으로 해결하게 되었다.

> Header를 통한 해결 방법

```swift
var headers: [String : String]? {
        return [
            "Authorization": "token \(KeyChainManager.shard.load(GithubAuthorize.token) ?? "")",
            "Cache-Control": "no-store" // 이 부분을 추가하여 리스폰스를 캐시처리 하지 않도록 요청
        ]
    }
```

> URLRequest의 프로퍼티를 이용한 해결 방법

```swift
var request = URLRequest(url: url)

// 캐시 정책 할당 (로컬 캐시 데이터 무시)
request.cachePolicy = .reloadIgnoringLocalCacheData 
```


---

- 참고링크
    * https://developer.apple.com/documentation/foundation/urlsessionconfiguration
    * https://developer.apple.com/documentation/foundation/nsurlrequest/cachepolicy
    * https://medium.nextlevelswift.com/urlrequest-cache-policy-f7c30a96b698
    * https://www.blog-dreamus.com/post/cache-control-%EC%9D%B4-%ED%95%84%EC%9A%94%ED%95%9C-%EC%9D%B4%EC%9C%A0
