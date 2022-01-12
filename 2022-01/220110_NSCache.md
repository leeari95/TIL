# 220110 NSCache
# TIL (Today I Learned)


1월 11일 (화)

## 학습 내용
- 오픈 마켓 프로젝트 STEP 2 PR 작성
- NSCache이란?


&nbsp;

## 고민한 점 / 해결 방법

**[NSCache]**

* 캐시메모리(Cache Memory)란?
    * 캐시 메모리는 메인 메모리와 CPU간의 데이터 속도 향상을 위한 중간 버퍼 역할을 하는 CPU 내 또는 외에 존재하는 메모리
    * 실제 메모리와 CPU 사이에서 빠르게 전달하기 위하여 프로세서가 단기간에 필요로 할 가능성이 높은 정보를 임시로 저장할 목적으로 사용한다.
    * 일반적으로 용량이 더 큰 저장장치들은 용량이 작은 저장장치들보다 속도가 느린데 속도차이에 따른 병목현상을 줄이기 위한 범용 메모리이다.
    * 지역성을 이용하여 CPU가 어떤 데이터를 원할 것인가를 어느정도 예측하여 캐시메모리에 데이터를 저장한다.
* 지역성(Locality)
    * CPU에서 명령어를 수행하면서 매번 Cache Memory를 참조하게 되는데 이때 Hit률이 지역성을 갖는다.
    * 지역성(Locality Of Reference)은 프로세스들이 기억장치 내의 정보를 균일하게 액세스하는 것이 아니라 어느한 순간에 특정부분을 집중적으로 참조하는 것을 말한다.
    * 지역성 메모리의 위치와 접근 시간에 따라서 공간적, 시각적인 특성을 보인다.
    * 공간적 지역성(Spatial Locality)
        * 최근에 참조된 주소의 인접한 데이터가 참조될 가능성이 높은 특성
        * a[0], a[1] 처럼 같은 데이터 배열에 연속적으로 접근할 때 참조된 데이터 근처에 있는 데이터가 잠시 후 사용될 가능성이 높다.
    * 시간 지역성(Temporal Locality)
        * 최근에 참조된 주소의 내용이 재 참조될 가능성이 높은 특성
        * For, While 같은 반복문에 사용되는 조건 변수처럼 한번 참조된 데이터는 잠시 후 참조될 가능성이 높다.
* 캐시에 데이터를 저장할 때는, 참조 지역성(공간)을 최대한 활용하기 위해 해당 데이터뿐만 아니라 옆 주소의 데이터도 같이 가져와 미래에 쓰일 것을 대비해야 한다.
* 캐시 미스(Cache miss)란?
    * CPU가 데이터를 요청했을 때 캐시 메모리가 해당 데이터를 가지고 있다면 이를 캐시히트라고 부르며, 해당 데이터가 없어서 DRAM에 접근해야 한다면 캐시 미스 라고 한다.
    * 캐시미스 유형엔 3가지가 있다.
        * Cold start miss(Compulsory miss)
            * 데이터에 처음 접근 시 캐시에 데이터를 올리기 위해 발생하는 캐시미스
        * Capactiy miss
            * 캐시의 용량이 부족하여 발생하는 미스
            * 즉 프로그램 수행시 접근하는 데이터의 양이 캐시의 사이즈를 넘어갈 경우 발생한다.
            * 예를 들어 32K direct mapped cache를 달고 있는 컴퓨터에서 128k array data를 접근하는 경우 캐시는 array data를 모두 저장할 수 없으므로 용량 부족에 의한 캐시미스가 발생한다. 이러한 미스를 capacity miss라 한다.
        * Conflict miss
            * 캐시 메모리에 A와 B 데이터를 저장해야하는데, A와 B가 같은 캐시 메모리 주소에 할당되어서 나는 캐시미스.
            * 캐시미스 비율은 대체로 평균 10% 안쪽이기 때문에 캐시 메모리를 통해 컴퓨터 시스템의 평균 성능을 크게 향상 시킬 수 있으며, 클럭 속도, 코어 개수와 함께 컴퓨터 성능에서 매우 큰 비중을 차지한다.
            * 그러나 많은 사람들이 캐시 메모리에 대해 잘 모르며 실제 캐시 메모리가 없이 클럭 속도가 더 높은 CPU가 클럭속도는 낮지만 캐시메모리가 있는 CPU보다 대체로 더 나쁜 성능을 보여준다.
* 요약
    * 캐시는 재사용될 수 있을만한 자원을 특정 영역에 저장해놓는 것을 의미한다.
    * 캐싱된 데이터가 있다면 추가적인 자원을 소모하지 않고 caching Data를 가져다 쓸 수 있기 때문에 자원을 절약할 수 있고 애플리케이션의 처리 속도가 향상된다.
    * Caching은 웹 브라우저부터 웹 서버, 하드 디스크 및 CPU에 이르기까지 다양한 방면에서 적용되고 있다.
    * iOS에서 캐싱은 memory caching과 disk caching 2가지 방법이 있다.
* Memory Caching
    * 어플리케이션의 메모리 영역의 일부분을 캐싱에 사용하는 것을 의미한다.
    * 하지만 어플리케이션이 종료되어 메모리에서 해제되면 이 영역에 있던 리소스들은 OS에 반환되면서 메모리 캐싱되어있던 리소스들은 사라지게 된다.
* Disk Caching
    * 데이터를 파일 형태로 디스크에 저장하는 것을 말한다.
    * 어플리케이션을 껐다 켜도 데이터가 사라지지 않지만, 디스크 캐싱이 반복적으로 발생하면 어플리케이션이 차지하는 용량이 커진다.
        * ex) 카카오톡에서 이미지나 동영상을 디바이스에 저장하지 않더라도 눈으로 보기 위해서는 파일을 다운로드 받아야하는데, 이때 다운로드 받은 파일들이 Disk Chching되어 앱을 종료했다가 실행해도 볼 수 있다.
* 특이 iOS에서는 NSCache를 제공하는데, 주로 메모리 캐싱에 사용되는 클래스이다.
* NSCache
    * 주로 메모리 캐싱에 사용되는 클래스
    * 메모리에서 해제될 때 자동으로 캐시된 내용이 제거되며, 메모리 자원이 부족해도 삭제 대상이 된다.
    * NSCache는 Thread-Safe하기 때문에 여러 스레드에서 접근할 때에도 Cache에 lock을 걸어줄 필요가 없다.
    * key-value 형태의 데이터를 임시로 저장하는 데 사용할 수 있는 가변 컬렉션을 말한다.
    * 특징
        * Linked List를 사용하여 데이터 추가 및 삭제에 효율적으로 동작한다. (탐색 시간 복잡도 O(n))
        * 별도의 Dictionary를 두어 데이터 접근에도 용이하다 (데이터 접근 시간 복잡도 O(1))
* NSDictionary와의 차이점
    * 자동 메모리 관리(기본 제공)
        * 먼저 NSCache는 시스템 메모리가 꽉 차면 자동으로 캐시의 메모리를 정리해준다.
        * 앱에서 메모리가 부족한데 메모리를 더 사용하려고 하면 데이터를 지우고 메모리를 해제하는 것
        * 만약 NSDictionary를 Cache 용도로 사용하려고 한다면 메모리가 부족하다는 시스템 경고를 받았을 때 사전이 이용한 메모리를 정리하는 코드를 미리 직접 작성해야한다.
    * Thread-Safe
        * NSCache는 Thread-Safe하기 때문에 캐시데이터를 읽고 쓰고 지울때마다 따로 lock을 해줄 필요가 없다.
            * 동시에 여러 Thread가 접근하더라도 각자 lock을 잡아줄 필요가 없다.
        * 하지만 NSDictionary는 Thread-safe하지 않으므로 데이터가 접근할 때 따로 처리해줘야 한다.
    * Retain Key
        * NSCache는 key를 복사하지 않고 리테인한다.
        * key가 복사를 지원하지 않는 객체일 수 있기 때문에 이러한 객체도 포용하기 위해서이다.
        * 따라서 복사를 지원하지 않는 객체와도 잘 동작한다.
* NSCache Declaration
```swift
class NSCache<KeyType, ObjectType> : NSObject where KeyType : AnyObject, ObjectType : AnyObject
```
* NSCache Property
    * Cache 객체에는 다양한 자동 제거 정책이 있으며 이들을 통합하여 일부 항목을 제거한다.
    * 이러한 자동 제거 정책에는 캐시 객체의 최대 개수를 제한하고 모든 캐시 객체의 최대 cost를 제한하는 두 가지 프로퍼티가 있다.
    * `var countLimit: Int`
        * 캐시가 가질 수 있는 최대한의 객체 수
        * 위 프로퍼티를 통해 캐싱하는 데이터의 개수를 제한할 수 있다.
        * 만약 countLimit가 10으로 설정되어있는데, 11개의 데이터를 NSCache에 넣게 되면 1개는 자동으로 버린다.
        * 기본값은 0으로 개수 제한이 없다.
    * `var totalCostLimit: Int`
        * 객체를 제거하기 전에 캐시가 보유할 수 있는 최대 비용
        * 객체를 추가할 때 cost(Int)를 함께 설정할 수 있다.
        * 이 때, totalCostLimit은 cost들의 총합의 최댓값이다.
        * 즉 NSCache에 추가된 데이터들의 cost가 totalCostLimit에 도달하거나 넘게되면 NSCache는 데이터를 버린다.
        * 기본값은 0으로 비용 제한이 없다.
    ```swift
    <예시>
    let cache: NSCache<NSString, UIImage> = NSCache()
    cache.countLimit // 허용하는 key의 개수
    cache.totalCostLimit // cost 합계의 최댓값
    ```
    * `var evictsObjectsWithDiscardedContent: Bool`
        * NSCache는 시스템에서 메모리를 너무 많이 사용하지 않도록 디자인되어 있다.
        * 그래서 캐싱된 데이터를 자동으로 지우는 다양한 정책을 사용하고 있고, 캐싱된 데이터가 너무 많은 메모리를 사용하면 시스템은 캐싱된 데이터를 삭제한다.
        * `protocol NSDiscardableContent`
            * 클래스 내 객체의 하위 구성 요소가 사용되지 않을 때 삭제되어도 된다면 이 프로토콜을 채택함으로써 응용 프로그램의 메모리 사용 공간을 줄일 수 있다.
        * `func object(forKey: KeyType) -> ObjectType`
            * 주어진 key와 연결된 값을 반환한다.
* NSDiscardableContent
    * NSCache는 자동으로 객체의 캐싱 및 제거를 처리하지만 객체를 제거할 시기를 제어할 수는 없다.
    * 더이상 필요하지 않은 객체를 제거하는 경우 NSPurgeableData, NSDiscardableContent 프로토콜을 채택한 타입을 사용할 수 있다.
    * NSDiscardableContent는 필요한 순간에 사용하던 메모리를 반납해야하는 객체를 위한 인터페이스를 정의하는 프로토콜이다.
    * NSDiscardableContent 프로토콜은 내부족으로 객체의 life cycle을 다루는 Counter 변수가 있다.
    * Counter 변수는 현재 객체가 다른 객체에서 사용중인지 여부를 추적하는 용도 사용된다.
    * 기본적으로 Counter 변수는 1로 초기화 된다.
    * beginContentAccess() 메소드를 호출하면 1씩 증가하게 되고 endContentIfPossible() 메소드를 호출하여 해당시점에 관련 메모리가 해제된다.
* NSPurgeableData
    * 해당 클래스는 더이상 필요하지 않을 때 사용한 메모리를 반납해야하는 mutable data 객체이다.
    * 이 객체는 자동 반납되는 데이터(autopurging data)를 제공한다.
    * 이 기능은 이 객체가 자동으로 반납되면 캐시에서도 자동으로 제거된다는 것을 말한다.
    * class NSPurgeableData: NSMutableData
        * 이 클래스는 NSDiscardableContent 프로토콜을 준수하는 NSMutableData의 서브클래스다
        * NSPurgeableData는 NSDiscardableContent 프로토콜의 기본 구현이 되어있다.
        * NSPurgeableData 객체가 NSCache에 추가되었다면 반납될 수 있는 데이터 객체가 반납되면 자동으로 캐시에서 제거된다.
        * 반납될 수 있는 데이터 객체에 접근해야 한다면, 사용하는 동안 반납되는 것을 막기 위해 beginContentAccess()를 호출해야한다.
        * 그리고 객체 사용이 끝났을 경우 객체의 메모리를 반납해도 된다고 알리는 endContentAccess()를 호출해야 한다.
* NSCache 구현
    * 연결리스트로 데이터를 캐싱하는 이유에 대해서 명확히 서술되어 있지는 않지만, 캐시는 중간에 있는 데이터를 추가, 삭제하는 것이 빈번하기 때문에 이를 효율적으로 하기 위해(배열로 해당 작업을 수행시 데이터를 앞으로 당기거나 뒤로 데이터를 모두 밀어아하는 작업이 추가적으로 발생한다.) 연결리스트로 구현된 것이라고 생각해볼 수 있다.
    * 또한 NSCache는 별도로 Dictionary를 두어 데이터의 접근도 O(1)에 수행할 수 있도록 제공하고 있다.
```swift
// NSCache
open class NSCache<KeyType : AnyObject, ObjectType : AnyObject> : NSObject {

    private var _entries = Dictionary<NSCacheKey, NSCacheEntry<KeyType, ObjectType>>()
    private var _head: NSCacheEntry<KeyType, ObjectType>?
}
```
---

- 참고링크
    - https://velog.io/@ryalya/iOS-CS-Study-Cache-Memory%EB%9E%80
    - https://hcn1519.github.io/articles/2018-08/nscache
    - https://developer.apple.com/documentation/foundation/nscache
