# 220128 CoreData, NSPredicate, Relationship


1월 28일 (금)

## 학습 내용
- CoreData
    - NSPredicate
    - Relationship


&nbsp;

## 고민한 점 / 해결 방법

**[NSPredicate]**

* CoreData를 사용할 때 Predicate 문법을 사용하여 필터링할 때 사용한다.
* Priedicate 키워드들은 대문자로 작성하는 것이 가독성에 좋다.(SQL처럼..)
* 문자열 안의 두개 이상의 공백은 하나로 처리된다.
```swift
// CoreData에서 특정 id 값 존재
let request: NSFetchRequest<Entity> = Entity.fetchRequest()
let predicate = NSPredicate(format: "id == $@", id)
request.predicate = predicate
```
* 패치하기 전에 predicate를 대입해주고 패치를 하게되면, 필터링 한 특정 데이터만 패치되어 데이터를 가져오게 된다.
* NSPredicate는 코어데이터 뿐만 아니라 Regular Expression 문법을 따르므로, 핸드폰 번호나 이메일, 패스워드 정규식 체크에도 사용된다.
* NSPredicate의 메소드인 evaluate(with:)를 사용하여 정규식 판별을 할 수 있다.
```swift
// 핸드폰 번호 정규성 체크
func validatePhoneNumber(_ input: String) -> Validation<String, String> {
    
    let regex = "^01[0-1, 7][0-9]{7,8}$"
    let phonePredicate = NSPredicate(format: "SELF MATCHES %@", regex)
    let isValid = phonePredicate.evaluate(with: input)
    
    if isValid {
        return .valid(input)
    } else {
        return .invalid("invalid phone number")
    }
}

// 이메일 정규성 체크
func validateEmail(_ input: String) -> Validation<String, String> {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
    let isValid = emailPredicate.evaluate(with: input)

    if isValid {
        return .valid(input)
    } else {
        return .invalid("invalid email")
    }
}

// 패스워드 정규성 체크
func validatePassword(_ input: String) -> Validation<String, String> {
    let regex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}" // 8자리 ~ 50자리 영어+숫자+특수문자

    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    let isValid = predicate.evaluate(with: input)

    if isValid {
        return .valid(input)
    } else {
        return .invalid("invalid password")
    }
}
```
---

**[Relationship]**

![](https://i.imgur.com/TuaxX6u.png)

* Relationship을 선택하면 여러가지 옵션들을 설정할 수 있다. 이 옵션들의 의미들은 뭘까?
    * `Transient`
        * 해당 Relationship이 임시적인 값인지 여부를 뜻한다. 여기에 임시적인 속성으로 취급되어 저장소에 들어가지 않는다.
    * `Optional`
        * 해당 Relationship이 선택적인지 여부를 뜻한다.
        * 선택하면 해당 Relationship을 nil로 둘 수 있다.
        * 만약 옵셔널이 아닌데 nil로 설정한 뒤 save를 시도하면 런타임 에러가 발생한다.
    * `Destination`
        * Relationship의 타입을 의미한다.
        * 자기 자신을 지정할 수도 있다.
    * `Inverse`
        * 해당 Relationship의 역방향 Relationship을 의미한다.
        * 한쪽에서의 변화가 역방향으로도 전파될 수 있도록 모든 Relationship은 Inverse를 가져야 한다.
    * `Delete Rules`
        * 자기 자신이 지워질 때, Relationship으로 연결된 Entity들에게 어떻게 변화가 전파되는 지를 설정한다.
        * Inverse가 필수이기 때문에 Destination은 Source 참조를 가지고 있다.
            * `No Action`
                * 아무런 행동을 하지 않는다. 따라서 Destination에서의 참조는 그대로 유지되며, 이는 수동으로 업데이트 되어야 한다.
            * `Nullify`
                * Destination의 Source 참조를 nil로 설정한다.
            * `Cascade`
                * Destination의 객체들을 연쇄적으로 삭제한다.
            * `Deny`
                * 아무런 Destination을 가리키지 않을 때만 삭제가 가능하며 하나라도 다른 객체 참조를 가지고 있으면 삭제가 거부된다.
    * `Type`
        * 해당 Relationship이 1:1 관계인지, 1:N 관계인지를 결정한다.
        * 1:N 관계인 경우 최소숫자와 최대 숫자를 정할 수 있다.

---

- 참고링크
    - https://onelife2live.tistory.com/35
    - https://ios-development.tistory.com/592
    - https://koggy.tistory.com/32?category=922104
