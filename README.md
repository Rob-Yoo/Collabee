# 콜라비
<br>

메신저 기반 협업 어플리케이션

<br>

## 🗄️ 프로젝트 정보
- **기간** : `2024.11.03 ~ 2024.12.03` (1개월)
- **개발 인원** : `iOS 1명`, `백엔드 1명`
- **지원 버전**: <img src="https://img.shields.io/badge/iOS-15.0+-black?logo=apple"/>
- **기술 스택 및 라이브러리**
  - UI: `UIKit` `PhotosUI` `SnapKit` `Compositional Layout` `Diffable DataSource`
  - Architecture: `Modular Architecture` `Clean Architecture + MVVM`
  - Reactive: `Combine`
  - Network: `Moya` `Socket.io`
  - Local DB: `Realm`
  - 기타: `Then` `KakaoSDK`
  
- **프로젝트 주요 기능**
  - `회원 관리` (소셜 로그인 / 이메일 로그인)
  - `워크스페이스` (생성 / 수정 / 삭제 / 퇴장 / 초대)
  - `채널` (생성 / 수정 / 삭제 / 퇴장 / 실시간 채팅 / 읽지 않은 채팅 개수)
  - `DM` (실시간 채팅 / 읽지 않은 채팅 개수)

<br>


| 로그인 화면 | 워크스페이스 화면 | DM 목록 화면 | 채팅 화면 |
|--|--|--|--|
|![로그인화면](https://github.com/user-attachments/assets/d0da4c5c-336d-4238-93ee-1a772155b3ba)|![워크스페이스](https://github.com/user-attachments/assets/35904369-e480-4735-9d1b-5dd99e637b07)|![DM](https://github.com/user-attachments/assets/09110508-e5bf-4c59-b691-34668b5745a6)|![c채팅](https://github.com/user-attachments/assets/c0ae1b7c-ff22-48bf-817a-9808fbcc4803)


<br>


## 🧰 프로젝트 주요 기술 사항

### Modular Architecture

<img width="360" alt="스크린샷 2024-12-08 오후 4 23 53" src="https://github.com/user-attachments/assets/1883bbd9-9028-410d-b573-615249d9c707">

**App**

 - Presentaion 계층(VC, VM)
 - DIContainer 객체 등록

**Auth**, **Workspace**, **Chat**, **User**
  - Domain-Data 계층으로 이루어진 기능 모듈
  - 클린 아키텍처의 의존성 규칙 준수

**DataSource**
  - RemoteDataSource: NetworkProvider, WSProvider(웹소켓) 프로토콜 및 구현체
  - LocalDataSource: DataBaseProvider 프로토콜 및 구현체, TokenStorage(KeyChain), UserDefaultStorage
  - ImageDataSource: ImageCacheManager, DiskCache

**Common**
  - 공통으로 사용되는 유틸리티 모듈 (DIContainer, Extension)

<br>

**모듈화 고려 사항**
- 모듈의 재사용성을 위한 기능 단위 수직적 분할
- 기능 확장 시 다른 모듈 영향 최소화
- DataSource 모듈이 사용하고 있는 라이브러리로부터 각 피처 모듈의 의존성 분리

***

### 실시간 채팅 구현

- 채팅방 진입 로직

  - 가장 마지막 채팅 날짜(Realm)를 이용해서 읽지 않은 채팅 요청(HTTP) 후 저장
  - 30개의 채팅 데이터 로드(Realm) 후 소켓 연결
  - 채팅방에서 나가거나 백그라운드 진입 시 소켓 연결 해제

- 실시간 채팅 전송 및 응답

  - 채팅 데이터 수신(Socket) 후 저장
  - 채팅 데이터 송신(HTTP) 후 저장
  - 상단 페이지네이션을 위해 가장 오래된 채팅에 대한 커서 생성(ChatDataRepository)

***

### DIContainer 구현

- `Lazy Initialization Holder 클로저`를 통해 타입에 대한 구현체를 등록할 수 있게 구현
- `unique와 shared 스코프`를 통해 객체의 생명주기를 유연하게 관리
- WeakWrapper를 통해 `등록 객체를 약한 참조`하여 모든 참조가 사라질 때 자동으로 메모리 해제되게 구현
- Injected 프로퍼티 래퍼를 통해 resolve 코드 추상화
- Assembly 프로토콜을 통해 등록 객체들을 모듈별로 나누어서 관리하고 등록할 수 있게 구현

***

### Combine을 활용한 Input-Output 패턴

- Custom Publisher/Subscription, NotificationCenter Publisher을 활용해 `UI 액션에 대한 Input Publisher` 구현
- Method Swizzling, Associated Object을 활용하여 `ViewController LifeCycle 메서드 호출에 대한 Input Publisher` 구현
- UITableView/UICollectionView의 경우 DiffableDataSource를 활용하여 `ViewController가 Output Publisher을 들고 있지 않게함`
- 이를 통해 `데이터 바인딩 코드가 bindViewModel 메서드에서만 관리`되는 일관된 형태 준수

***

### Realm DB 모델링

<img width="533" alt="DB 모델링" src="https://github.com/user-attachments/assets/c4891ca2-39c2-4f55-97fb-a31141e983a0">

<br>

- ChatRoomObject와 ChatObject를 `To-Many` 관계로 정의하고 ChatObject를 `EmbeddedObject`타입으로 선언하여 `Cascading Delete`가 가능하도록 설계
- ChatObject와 SenderObject를 `To-One` 관계로 정의하여 SenderObject 변경에 의한 `삽입/갱신 이상 방지`
- SenderObject를 `Object` 타입으로 선언하여 `Cascading Delete가 불가능`하도록 설계

***

### 이미지 처리

- ImageIO를 활용한 `다운샘플링`을 통해 서버 업로드 시 `네트워크 통신 오버헤드 감소 및 서버 리소스 절약`
- UIGraphicsImageRender를 활용한 이미지 리사이징을 통해 이미지 품질을 적절히 유지하면서 `메모리 최적화된 렌더링 수행`
- FileManager를 활용한 `Etag 기반 이미지 디스크 캐시` 구현을 통해 `이미지 로드 성능 최적화`
- URL에서 이미지를 비동기적으로 로드하고 캐시하며, 플레이스홀더와 이미지 리사이징 기능을 제공하는 UIImageView extension 메서드 구현

***

### Request Interceptor을 활용한 액세스 토큰 갱신

- 토큰 갱신에 대한 retry 메서드가 무한 호출되지 않게 retryLimit 설정
- DispatchSemaphore와 isRefreshing 변수를 통해 `토큰 중복 갱신에 대한 동시성 문제 해결`

***

## 📋 회고

### 1. 모듈화 구조 설계에 대한 아쉬움

이번 프로젝트에서는 모듈화를 진행하며 `기능 확장 시 다른 모듈에 영향을 최소화한다`는 목표를 세웠다. 이를 위해 각 피처 모듈에 API 정의, Local DB 스키마, 그리고 이를 활용하는 Repository 구현체를 모두 포함시키는 구조를 설계하였다. 그러나 이러한 설계로 인해 다음과 같은 문제가 발생했다.

- 피처 모듈의 라이브러리 의존성 필요
  - 각 피처 모듈에 Moya의 TargetType, Realm의 Object 타입, 쿼리 문법이 포함되면서, 라이브러리 의존성이 생겨버렸다. DataSource 모듈을 통해 Moya에 대한 의존성은 분리시켰지만, Local DB 스키마를 내부에 두어야 하는 구조적 제약으로 인해 Realm에 대한 의존성은 분리시키지 못했다.

- Data Layer 관련 보일러플레이트 증가
  - 기능 별로 Data Layer를 독립 모듈로 분리하지 않아, DTO-Entity 매핑 로직이 각 모듈마다 중복되는 형태로 흩어지게 되었다. 이는 재사용성을 떨어뜨리고 반복적인 보일러플레이트 코드를 양산하는 결과를 낳았다.

`프로젝트를 통해 얻은 교훈은, 모듈 경계 정의 시 “기능 확장 시 다른 모듈에 미치는 영향 최소화”만을 절대적인 기준으로 삼는 것보다는 특정 상황에서는 기능 확장 시 다른 모듈을 수정하게 되더라도, 이를 통해 공통 로직을 한 곳에서 관리하고, 라이브러리 의존성을 한 모듈로 모아둘 수 있다는 것이다.`

### 2. DIContainer 스코프 설정에 대한 아쉬움

객체 스코프를 Resolve시 설정하게 구현하였는데, 이렇게 되면 잘못된 스코프를 가지게 되는 것을 방지할 수 없게 된다.<br>
Register 시 객체 스코프를 설정할 수 있는 구현 방식을 고민해봐야겠다.

