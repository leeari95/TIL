# TIL (Today I Learned)

10월 8일 (금)

## 학습 내용
 오늘은 불타는 토요스터디를 진행하였다. 옵셔널과 예외처리에 대해서 복습하는 시간을 가졌다. 스터디원들과 서포터즈와 간단한 근황토크와 모각코를 진행하였다. 옵셔널 바인딩을 해야하는 여러가지의 상황들을 구현해보면서 코드를 나누는 시간을 가졌다.
&nbsp;
## 문제점 / 고민한 점
- Optional인 값을 switch로 어떻게 바인딩 할까?
- compactMap으로 옵셔널바인딩을 할 수 있을 것 같다.
- Dictionary의 init를 다시 복습해보았는데 기억이 나질 않아...
- indices 활용법을 잊어먹었다.
&nbsp;
## 해결방법
- switch로 바인딩을 하려면 옵셔널인 값을 switch문으로 아래와 같이 구성하면된다.
    ```swift
    let numbers: [String?] = ["1", "2", "3", "4", "5"]

    for index in numbers.indices {
        switch numbers[index] {
        case .none:
            continue
        case .some(let number):
            print("숫자 \(number)을 바인딩 하는데 성공!")
        }
    }
    ```
- compactMap을 활용하여 옵셔널을 벗겨보았다.
    ```swift
    let numbers: [String?] = ["1", "2", "3", "4", "5"]

    let numbersBinding: [String] = numbers.compactMap { $0 }
    let numbersTagList: Dictionary<String, Int> = Dictionary(uniqueKeysWithValues: zip(numbersBinding, 6...10))
    let numbersSorted = numbersTagList.sorted { $0.value < $1.value }
    numbersSorted.forEach{ (str, number) in
        print("\(number)번째에는 숫자 \(str)이 들어있다")
    }
    ```
    
&nbsp;

---

- 참고링크
    - [Optional](https://developer.apple.com/documentation/swift/optional)
    - [indices](https://developer.apple.com/documentation/swift/collection/1641719-indices)
    - [compactMap](https://github.com/apple/swift/blob/main/stdlib/public/core/FlatMap.swift)
