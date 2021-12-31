# 211231 inout, async, await, Thread Sanitizer
# TIL (Today I Learned)


12월 31일 (금)

## 학습 내용
- 은행창구매니저 STEP4 진행 후 PR 작성
- inout
- async/await
- Thread Sanitizer
- Thread Safe하게 코드 작성하기

&nbsp;

## 고민한 점 / 해결 방법

**[inout]**

* inout 키워드를 사용하면 파라미터로 전달받은 값을 참조하는 줄 알았는데, 아니였다.
* 값을 받아와서 대입을 하게되면, 참조해서 수정을 하는게 아니라 아예 수정한 값을 새로 덮어쓰기를 한다.
* 옵저버 프로퍼티를 inout으로 전달해주었더니 함수가 호출될 때마다 옵저버 프로퍼티의 didSet 블럭이 호출되었다.

**[async/await]**

* Swift 5.5부터 구현된 기능
* 추가된 이유
    * Swift 개발에서 Closure 및 completion hendlers를 사용하는 비동기 프로그래밍을 많이 한다.
    * 많은 비동기 작업, 오류 처리, 비동기 호출 간의 제어흐름이 복잡할 때 문제가 많다.
* 많은 비동기 작업
    * 일련의 비동기 작업에는 deeply-nested closures가 필요하다.
    ```swift
    func processImageData1(completionBlock: (_ result: Image) -> Void) { loadWebResource("dataprofile.txt") { dataResource in
            loadWebResource("imagedata.dat") { imageResource in
                decodeImage(dataResource, imageResource) { imageTmp in
                    dewarpAndCleanupImage(imageTmp) { imageResult in
                        completionBlock(imageResult)
                    }
                }
            }
        }
    }

    processImageData1 { image in
        display(image)
    }
    ```

    * 오류처리
        * 콜백은 오류처리를 어렵고 매우 장황하게 만든다.
        ```swift
        // (2c) Using a `switch` statement for each 
        func processImageData2c(completionBlock: (Result<Image, Error>) -> Void) { loadWebResource("dataprofile.txt") { dataResourceResult in
                switch dataResourceResult {
                case .success(let dataResource):
                    loadWebResource("imagedata.dat") { imageResourceResult in
                    switch imageResourceResult {
                        case .success(let imageResource):
                        decodeImage(dataResource, imageResource) { imageTmpResult in
                            switch imageTmpResult {
                                case .success(let imageTmp):
                                dewarpAndCleanupImage(imageTmp) { imageResult in
                                    completionBlock(imageResult)
                                }
                                case .failure(let error):
                                completionBlock(.failure(error))
                            }
                        }
                        case .failure(let error):
                        completionBlock(.failure(error))
                    }
                } case .failure(let error):
                    completionBlock(.failure(error))
                }
            }
        }

        processImageData2c { result in
            switch result {
                case .success(let image): display(image)
                case .failure(let error): display("No image today", error)
            }
        }
        ```
        * Swift Result가 Swift 5.0에서 추가되면서 error를 처리하는게 더 쉬워졌지만 여전히 closure 중첩 문제는 남아있다.
    * 비동기 호출간의 제어흐름이 복잡할 때
        * 비동기 함수를 조건부로 실행하는 것은 고통 그 자체이다.
        * 예를 들어 이미지를 얻은 후 swizzle 해야한다고 할 때
            * 이미지가 있으면 바로 swizzle
            * 이미지가 없으면 decode후 swizzle
        ```swift 
        func processImageData3(recipient: Person, completionBlock: (_ result: Image) -> Void) {
            let swizzle: (_ contents: Image) -> Void = {
              // ... continuation closure that calls completionBlock eventually
            }
            if recipient.hasProfilePicture {
                swizzle(recipient.profilePicture)
            } else {
                decodeImage { image in
                    swizzle(image)
                }
            }
        }
        ```
        * 그래서 위와같은 코드가 필요하다.
        * 이 함수를 구조화 하는 방법은 위 코드와 같이 completion handler에서 swizzle 코드를 작성하는 것이다.
        ```swift
        func processImageData3(recipient: Person, completionBlock: (_ result: Image) -> Void) {
            let swizzle: (_ contents: Image) -> Void = { // ... continuation closure that calls completionBlock eventually ✅✅   
            }
            if recipient.hasProfilePicture {
                swizzle(recipient.profilePicture)
            } else {
                decodeImage { image in
                    swizzle(image)
                }
            }
        }
        ```
        * 이 패턴은 함수의 자연스러운 하향식 구성을 반전시킨다.
        * swizzle closure가 completion handler에서 사용되므로 capture에 대해 신중하게 생각해야 한다.
        * 조건부로 실행되는 비동기 함수의 수가 증가함에 따라 문제는 더욱 악화되고 본질적으로 반전된 pyramid of doom을 생성시킨다.
    ```swift
    func processImageData4a(completionBlock: (_ result: Image?, _ error: Error?) -> Void) {
        loadWebResource("dataprofile.txt") { dataResource, error in
             guard let dataResource = dataResource else {
                return // ⚠️ <- forgot to call the block
            } loadWebResource("imagedata.dat") { imageResource, error in
                guard let imageResource = imageResource else {
                     return // ⚠️ <- forgot to call the block
                     } ...
            }
        }
    }
    ```
    * 실수하기 쉬워진다.
        * completion block을 호출하지 않고 그냥 return하고 잊어버리면 디버깅 하기가 어려워진다.
        * 내가 만약 잊지 않고 completion block을 호출했다고 치면

        ```swift
        func processImageData4b(recipient:Person, completionBlock: (_ result: Image?, _ error: Error?) -> Void) {
            if recipient.hasProfilePicture {
                if let image = recipient.profilePicture {
                    completionBlock(image) // ⚠️ <- forgot to return after calling the block
                }
            } ...
        }
        ```
        * completion block을 호출하고 나서 return 호출하는 것을 까먹을 수도 있다.
            * guard는 return을 하지 않으면 컴파일 에러를 주긴 하지만 항상 guard를 쓰는건 아니니까…
* 해결
    * 위와 같은 문제를 해결하기 위해 async-await proposal은 Swift에 코루틴(coroutine) 모델을 도입하게 된다.
        * 비동기 함수의 semantics 정의와 동시성을 제공하지는 않는다.
* 비동기 함수(async/await)를 사용하면?
    * 비동기 코드를 마치 동기 코드인 것처럼 작성할 수 있게 된다.
        * 프로그래머가 동기 코드에서 사용할 수 있는 동일한 언어 구조를 최대한 활용할 수 있게 된다.
    * 자연스럽게 코드의 의미 구조를 보존할 수 있다.
        * 언어에 대한 최소한 3가지 교차 개선에 필요한 정보를 제공…? 이게 뭔소리야
    * 비동기 코드의 성능 향상 
        * better performance for asynchronous code
    * 코드를 디버깅, 프로파일링 및 탐색하는 동안 보다 일관된 경험을 제공하기 위한 더 나은 도구
        * better tooling to provide a more consistent experience while debugging, profiling and exploring code
    * 작업 우선 순위 및 취소와 같은 동시성 기능을 위한 기반
        * a foundation for future concurrency features like task priority and cancellation


---

**[코드에서 경쟁 상태를 확인하는 방법]**

* Xcode에서 ..
    * `Product > scheme > editScheme > Run > Diagnostics > Thread Sanitizer`
    * Thread Sanitizer 이걸 체크하면 빌드를 돌리고 나서 thread safe 하지 않은 상황이 발생할 수 있는 가능성을 엑스코드에서 체크해준다.
    * 하지만 사용해보니 완벽하게 체크해주는 건 아닌 것 같다.[?] 그냥 도와주는 기능이라고 생각하고 사용해야할 것 같다.
    * ![](https://i.imgur.com/ERrHYab.png)

**[Thread Safe하게 코드를 작성하려면?]**

* 공유자원을 읽고 쓰는 작업을 Thread safe하게 Shemaphore를 사용해서 하나의 thread만 접근 할 수 있도록 하는 방법이 있다.
    * 하지만 이 방법은 완벽하게 제어하기는 무리가 있다. 오히려 공유자원을 lock으로 처리하다가 교착 상황 발생할 가능성이 높다고 한다.
* Serial Queue sync로 보내서 처리하는 방법도 있다.
    * 그러면 들어온 task에 순서가 생기기 때문에 다수의 스레드에서 동시에 값을 접근하지 못하게 하는 상황이 된다.
    * sync로 사용하는 이유는 Serial queue로 보낸 작업을 기다림으로써 공유자원의 제대로 된 값을 얻기 위함이다.


---

- 참고링크
    - https://zeddios.tistory.com/1230
    - https://github.com/apple/swift-evolution/blob/main/proposals/0296-async-await.md
    - https://ios-development.tistory.com/618
    - https://sujinnaljin.medium.com/ios-%EC%B0%A8%EA%B7%BC%EC%B0%A8%EA%B7%BC-%EC%8B%9C%EC%9E%91%ED%95%98%EB%8A%94-gcd-12-c06b599fe7f5
    - https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html
