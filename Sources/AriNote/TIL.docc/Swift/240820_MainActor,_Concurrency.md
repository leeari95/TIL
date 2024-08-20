# 240820 MainActor, Concurrency

MainActor.run와 @MainActor의 차이가  궁금해!

8월 20일 (화)

# 학습내용

Swift의 Concurrency 환경에서 비동기로 데이터를 처리한 후 UI를 업데이트 할때 메인스레드에서 처리하도록 하기 위해서 방법을 찾아보았다. 여러 방법이 있어서 차이가 뭔지 궁금해서 알아보았다.

## MainActor.run와 @MainActor의 차이

`MainActor.run`은 메인 스레드에서 특정 클로저를 실행하기 위해 사용된다.
메인 스레드에서 실행되길 원하는 코드가 있을 때 호출할 수 있는 명령형(Imperative) 방식이다.

```swift
MainActor.run {
    // 메인 스레드에서 실행될 코드
}
```

`@MainActor`는 특정 함수, 메서드, 클래스 또는 구조체가 메인 스레드에서 실행되도록 지정하는 방법이다. 해당 어노테이션을 사용하면 자동으로 코드가 메인 스레드에서 실행되도록 관리한다.

```swift
@MainActor
func updateUI() {
    // UI 업데이트 코드
}
```

## 성능적인 차이


### MainActor.run
`MainActor.run`은 메인 스레드에서 실행되어야 할 코드 부분을 명시적으로 메인 스레드에서 실행하도록 지정한다.
그러나 `MainActor.run`는 메인 스레드로의 전환을 동적으로 처리한다. 이 과정에서 컴파일러는 스레드 전환을 위한 추가적인 런타임 코드를 생성하며, 이는 SIL 코드의 양을 증가시킨다. 매번 `MainActor.run`을 호출할 때마다 메인 스레드로의 전환을 처리하기 위한 코드가 생성되고 이러한 추가적인 컨텍스트 스위칭은 성능 저하의 원인이 될 수 있다.

> MainActor.run을 사용하면 컴파일러가 메인 스레드로의 전환을 위해 추가적인 Swift Intermediate Language(SIL) 코드를 생성하게 되며, 이 과정에서 Context Switching 및 비동기 코드 관리와 관련된 코드가 추가된다.

> Swift 컴파일러는 소스 코드를 최적화하기 위해 여러 단계의 중간 표현을 생성하는데, 그중 하나가 `SIL (Swift Intermediate Language)`다. SIL은 최적화를 위해 설계된 중간 표현으로, 코드의 실행 경로를 최적화하거나, 불필요한 작업을 제거하는 등의 작업을 한다.

또한 비동기 작업 내에서 `MainActor.run`를 자주 사용하면 비동기 작업의 흐름을 끊고 메인 스레드로 전환하는 과정에서 지연이 발생할 수도 있다.
만약 메인스레드가 이미 바쁜 상태라면 `MainActor.run`에서 메인 스레드로의 전환이 대기 상태에 놓일 수도 있다.
즉, 메인 스레드의 병목 현상을 유발할 수 있으며 결과적으로 UI 렌더링 지연이나 다른 중요한 작업의 지연으로 이어질 수도 있다.
또한 비동기 작업 내에서 빈번하게 사용하게 된다면 컴파일러 최적화를 어렵게 만들고 불필요한 오버헤드를 발생시킬 수 있다.

### @MainActor

`@MainActor`는 클로저, 함수, 타입 수준에서 메인 스레드에서 실행되어야 함을 선언적으로 지정한다. 컴파일러는 해당 코드가 메인 스레드에서 실행된다는 사실을 컴파일 타임에 인지하고 이에 따라 최적화를 수행한다.

`@MainActor`를 사용하면 컴파일러는 코드의 실행 경로를 예측하고 최적화할 수 있다. 메인 스레드에서 실행될 코드가 전체적으로 잘 정의되어 있으므로 불필요한 스레드 전환이나 컨텍스트 스위칭(Context Switching)을 최소화할 수 있다.

또한 `@MainActor`는 메인 스레드 실행이 보장되기 때문에 SIL 단계에서의 코드 생성도 간결해진다. 컴파일러는 메인 스레드에서의 실행을 염두에 두고 최적화된 SIL 코드를 생성하며, 이로 인해 성능 오버헤드가 적은 편이다.

## 그래서 뭘 써야해?

메인 스레드에서 실행되어야 하는 코드가 많거나 일관된 실행 환경이 필요할 때는 `@MainActor`를 최대한 활용하도록 사용하자.

특정 코드 내에서 일부분을 메인 스레드로 실행해야할 때는 `MainActor.run`을 사용하자. 다만 빈번한 사용은 런타임 오버헤드를 발생시켜 성능 저하를 초래할 수 있으니 신중하게 사용하는 것이 좋겠다.

## 5줄 요약

1. `@MainActor`는 함수나 클래스 단위에서 메인 스레드에서의 실행을 컴파일 타임에 최적화하여, 불필요한 스레드 전환을 줄이고 성능을 향상시킨다.
2. `MainActor.run`은 특정 클로저를 메인 스레드에서 실행하기 위해 런타임 시 스레드 전환과 추가적인 SIL 코드 생성을 유발하여 성능 오버헤드를 증가시킬 수 있다.
3. `@MainActor`는 전체적인 메인 스레드 실행이 필요한 경우 적합하며, 컴파일러가 일관된 실행 경로를 최적화할 수 있다.
4. `MainActor.run`은 특정 상황에서만 메인 스레드 전환이 필요할 때 사용하지만, 빈번한 사용은 성능 저하로 이어질 수 있다.
5. 성능 최적화를 위해 `@MainActor`를 선호하고, `MainActor.run`은 신중하게 사용하는 것이 바람직하다.

---

# 참고 링크

- [https://developer.apple.com/documentation/swift/concurrency](https://developer.apple.com/documentation/swift/concurrency)
- [https://developer.apple.com/documentation/swift/mainactor](https://developer.apple.com/documentation/swift/mainactor)
- [https://mechanicdong.tistory.com/54](https://mechanicdong.tistory.com/54)