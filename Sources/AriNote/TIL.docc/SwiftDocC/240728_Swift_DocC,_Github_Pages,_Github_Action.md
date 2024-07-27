# 240728 Swift DocC, Github Pages, Github Action

Documentation을 웹페이지로 변환하여 Github Pages로 배포하는 방법

7월 28일 (일)

# 학습내용

- Xcode로 만든 Documentation을 웹페이지로 변환하기
- 변환한 웹페이지를 Github Pages로 배포하기
- Github Action으로 웹페이지 배포 자동화하기

# 고민한 점 / 해결방법

#

## Xcode로 만든 Documentation을 웹페이지로 변환하기 (Pages)

`docc-plugin`을 사용하여 아래와 같이 커맨드를 수행한다.

```
$ swift package --allow-writing-to-directory {저장위치} \
    generate-documentation --target {타겟이름} \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path {레포지토리-이름} \ 
    --output-path {저장위치}
```

그러면 아래와 같이 저장위치에 변환된 웹페이지 파일들이 생성된다.

![](https://github.com/user-attachments/assets/59e67823-c7fc-4a69-8775-6e5359ed4aaa)

## 변환한 웹페이지를 Github Pages로 배포하는 방법

1. 앞서 변환한 웹페이지 파일들(docs)를 레포지토리에 푸쉬한다.
2. 그리고 레포지토리 Settings > Pages로 진입하여 아래와 같이 설정을 바꿔준다.
  - 브랜치로 직접 배포하는 설정.
  - 배포할 브랜치를 선택한 후 웹페이지가 포함된 디렉토리 docs를 루트로 선택해주었다.
![image](https://github.com/user-attachments/assets/d871ecd9-80c9-40e9-bb01-888b4c3ef8ea)
3. 이후 main 브랜치에 커밋이 푸시될 때마다 아래와 같이 Github Action이 동작하면서 배포가 된다.
![](https://github.com/user-attachments/assets/cf411b0a-0af7-48d8-99e6-5fdaa0398718)

# Trouble shooting

## 문서 구조 구성하기

### 원인
각 카테고리마다 하위 문서를 설정해주고 싶었다. 아래는 문서 구조가 잡히지 않는 상황이다.

![](https://github.com/user-attachments/assets/0e4f9707-697f-4204-acd3-9921e75e4fe2)

문서 구조를 설정해주려면, 각 파일에 `## Topics`를 추가하여 `- <doc:{파일이름}>`을 추가해주어야 한다.

![](https://github.com/user-attachments/assets/ebaac4e4-d531-4640-84d3-335fbeda13a6)

### 이유

근데 이걸 모두 수작업으로 하기엔 너무 번거롭다는 생각이 들었다.

그래서 swift로 스크립트를 짜서 문서 설정을 자동화하기로 했다.

### 해결

스크립트는 아래와 같은 조건으로 짜게 되었다.

1. `TIL.md` 파일을 제외한 나머지 `.md` 파일을 찾는다.
2. `.md` 파일들과 이름이 같은 디렉토리 경로를 찾는다.
3. 해당 디렉토리에 있는 파일 이름을 모두 찾아 내림차순으로 정렬하여, `.md`파일에 `## Topics` 섹션을 찾거나 추가한다.
4. 정렬된 파일 목록을 Topics 섹션에 양식에 맞게 추가하도록 했다. (양식: `- <doc:{파일이름}>`)

그리고 이 스크립트를 활용해서 Github Pages를 배포하는 것도 자동화하기 위해 브랜치가 아니라 Github Action으로 배포하도록 설정을 바꾸었다.

![](https://github.com/user-attachments/assets/1e7c9a54-f7a2-43e0-b6e2-29a621e1f1d0)

워크플로우는 다음과 같은 순서로 step을 구성했다.

1. 레포지토리 체크아웃
2. swift run 커맨드로 스크립트 수행하여 각 .md 파일 업데이트
3. docc-plugin으로 Documentation을 웹페이지로 변환
4. Github Pages 배포

> workflow: https://github.com/leeari95/TIL/blob/main/.github/workflows/update-markdown-files.yml

---

# 참고 링크

- [https://www.swift.org/documentation/docc/adding-structure-to-your-documentation-pages](https://www.swift.org/documentation/docc/adding-structure-to-your-documentation-pages)
- [https://www.swift.org/documentation/docc/](https://www.swift.org/documentation/docc/)
- [https://swiftlang.github.io/swift-docc-plugin/documentation/swiftdoccplugin/publishing-to-github-pages/](https://swiftlang.github.io/swift-docc-plugin/documentation/swiftdoccplugin/publishing-to-github-pages/)