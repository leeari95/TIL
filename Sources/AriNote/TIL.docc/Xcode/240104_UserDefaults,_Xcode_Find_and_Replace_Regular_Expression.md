# 240104 UserDefaults, Xcode Find and Replace Regular Expression

# TIL (Today I Learned)

1월 4일 (목)

## 학습 내용

- UserDefaults
- Xcode Find and Replace

&nbsp;

## 고민한 점 / 해결 방법

> UserDefaults는 기본적으로 캐시를 지원하고 있다...!

![image](https://github.com/leeari95/TIL/assets/75905803/bf597777-7c3e-4192-9add-a30fbdc5ef81)

</br>

#

> Xcode에서 정규 표현식을 사용하여 프로젝트 전체적으로 특정 코드를 바꾸는 방법

회사 프로젝트 내에서 UserDefaults를 래핑하여 싱글톤 클래스로 get, set 메소드를 사용하고 있었는데, 이번에 SwiftyUserDefaults라는 라이브러리를 통해 개선하게 되면서 더이상 get, set 메소드를 만들어 래핑할 필요가 없어지게 되었다.

이 라이브러리는 subscript를 활용하여 데이터를 손쉽게 읽고 저장할 수 있는데, 프로젝트 코드를 전체적으로 메소드 호출 방식이 아닌, 참조 및 할당해주는 방식으로 바꿔주어야 한다.

그래서 이를 일일이 바꿔주기에는 뭔가 노가다 같아서... 좋은 방법이 없을까 찾다가 발견했다.

![image](https://github.com/leeari95/TIL/assets/75905803/923d8e74-eeca-40c9-922f-2cf3eb1a537f)


이렇게 텍스트 뿐만 아니라 정규 표현식을 사용하여 프로젝트 내에 특정 문자열을 골라낼 수가 있었다.
그리고 이를 활용하여 특정 문자열을 남겨두고 나머지 문자열만 바꿔치기가 가능했다.

예를 들어서 `Storage.shared.get(key: Persistent.store.keyName)` 이 부분을 `Persistent.store.keyName` 이런식으로 바꾸고 싶다고 가정해보자.

1. 찾고자하는 패턴을 정규 표현식으로 아래와 같이 입력해준다.
  a. `Storage\.shared\.get\(key: (.+)\)`
  b. 여기서 `(.+)`는 괄호 안의 하나 이상의 임이의 문자를 캡처 그룹으로 지정한다는 의미다.
2. Replace 필드에 캡처그룹을 참조하는 $1를 입력해준다.
  a. 이렇게 하면 찾은 문자열에서 캡쳐한 값으로 바꿔치기가 된다.

아래는 또다른 예시다.

1. Find Pattern: `Storage\.shared\.set\((.+), key: (.+)\)`
2. Replace Pattern: `$2 = $1`

</br>

---

# Reference

* https://developer.apple.com/documentation/foundation/userdefaults
* https://developer.apple.com/documentation/xcode/finding-and-replacing-content-in-a-project
