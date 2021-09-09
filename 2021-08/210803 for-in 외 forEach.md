# TIL (Today I Learned)

날짜: 2021년 8월 3일
작성자: 이아리
태그: break, continue, forEach, forloop, return, 반복문, 제어문

## **학습내용**

오늘은 Swift 문법과 많이 친해지기 위해 코딩테스트 연습을 하였다. 하다가 'forEach' 라는 것은 for in과의 차이점이 무엇인지 갑자기 궁금해져서 어떤 차이점이 있는지 알아보았다. for in문은 반복제어문을 사용하여 클로저 탈출이 가능하지만, forEach는 제어문 사용이 아예 불가능했다. 알아보니 forEach는 반복문이 아니라 Closure를 파라미터로 넘겨주는 '메서드' 였던 것이다. 동작은 for in문과 같은 반복을 하는 것을 알고 있었지만, 이번 기회에 정확한 사용법과 어떤 차이점이 있는지 학습하였다.

## 코드 적어보기

✔️  두 반복문은 같은 결과를 출력한다.

```swift
let arr = ["leeari", "ari", "lee"]

for i in arr {
    print(i)
}
arr.forEach { i in
    print(i)
}
```

✔️  그러나 for in문에서는 사용이 가능한 제어문이 forEach에서는 에러가 뜨며 사용이 불가능하다.

```swift
for i in arr {
    if i == "leeari" {
        continue
    }
    if i == "ari" {
        break
    }
}
arr.forEach{ i in
//    !!! error: only allowed inside a loop !!!
//    break
//    continue
}
```

✔️  for in문은 return문을 만나면 반복이 즉시 종료되고 함수가 종료되지만, forEach는 반복횟수에 영향이 없다.

```swift
func loop() {
    let arr = ["leeari", "ari", "lee"]
    
    for i in arr {
        if i == "ari" {
            print(i)
            return
        }
    }
}
arr.forEach{ i in
    if i == "ari" {
        return print(i)
    }
    print(i)
}
```

## 정리

for in문은 break과 contiue문을 사용하여 클로저를 탈출할 수 있지만, forEach는 이러한 **제어문 사용이 불가능**하다. forEach는 내가 반복하고 싶은 구문을 forEach라는 함수의 파라미터로 Closure로 작성하여 넘겨주기 때문이다.

## 학습에 **참고한 링크**

[https://developer.apple.com/documentation/swift/array/1689783-foreach](https://developer.apple.com/documentation/swift/array/1689783-foreach)