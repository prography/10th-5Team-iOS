# Repository Mock

Preview/Test에서 네트워크 없이 빠르게 상태를 만들기 위한 Repository Mock 모음입니다.

## 사용 방법

### 1. 기본 사용

ViewModel에서 Repository를 주입받을 때, Mock Repository를 주입하면 됩니다.

```swift
// 기존 코드
@StateObject private var viewModel = MyCampaignViewModel()

// Mock 사용
@StateObject private var viewModel = MyCampaignViewModel(
    campaignRepository: CampaignStatusRepositoryMock(),
    bookmarkRepository: BookmarkRepositoryMock()
)
```

### 2. 시나리오별 Result 값 변경

각 메서드는 주입된 `Result`를 그대로 반환하므로, 시나리오별로 값만 바꿔 끼워 넣으면 됩니다.

```swift
let mockRepo = CampaignStatusRepositoryMock()

// 성공 시나리오
mockRepo.getMyCampaignsResult = .success(MockRepositoryData.myCampaignPage)

// 에러 시나리오
mockRepo.getMyCampaignsResult = .failure(NSError(domain: "test", code: -1))

// 빈 데이터 시나리오
mockRepo.getMyCampaignsResult = .success(MockRepositoryData.emptyPage)
```

### 3. ViewModel에 의존성 주입 추가

Mock을 사용하려면 ViewModel에서 의존성 주입을 지원해야 합니다.

```swift
class MyCampaignViewModel: ObservableObject {
    private let campaignStatusRepository: CampaignStatusRepository
    private let bookmarkRepository: BookmarkRepository

    init(
        campaignStatusRepository: CampaignStatusRepository = CampaignStatusRepository(),
        bookmarkRepository: BookmarkRepository = BookmarkRepository()
    ) {
        self.campaignStatusRepository = campaignStatusRepository
        self.bookmarkRepository = bookmarkRepository
    }
}
```

### 4. Preview에서 사용

```swift
#Preview {
    let mockCampaignRepo = CampaignStatusRepositoryMock()
    mockCampaignRepo.getMyCampaignsResult = .success(MockRepositoryData.myCampaignPage)

    let mockBookmarkRepo = BookmarkRepositoryMock()

    return MyCampaignView()
        .environmentObject(MyCampaignViewModel(
            campaignRepository: mockCampaignRepo,
            bookmarkRepository: mockBookmarkRepo
        ))
}
```

## 파일 구조

- `RepositoryMock.swift`: Repository Mock 클래스 모음
- `MockRepositoryData.swift`: Mock 데이터 모음
- `README.md`: 사용 가이드

## 지원하는 Repository

- ✅ BookmarkRepository
- ✅ CampaignStatusRepository
- ✅ CampaignRepository
- ✅ AuthRepository

## Mock Data

`MockRepositoryData`에 미리 정의된 데이터:

- `myCampaignDTO`: 단일 캠페인 데이터
- `myCampaigns`: 캠페인 목록
- `myCampaignPage`: 페이징된 캠페인 데이터
- `campaignDTO`: 일반 캠페인 데이터
- `campaigns`: 일반 캠페인 목록
- `campaignPage`: 페이징된 일반 캠페인 데이터
- `campaignPlatforms`: 캠페인 플랫폼 목록
- `campaignStatusCount`: 캠페인 상태별 카운트
- `campaignStatusPopup`: 팝업 데이터
- `socialLoginResponse`: 소셜 로그인 응답
- `emptyPage`: 빈 페이지 데이터

## 주의사항

- Mock은 네트워크 호출 없이 즉시 데이터를 반환합니다
- 실제 비즈니스 로직은 테스트되지 않으므로, 단위 테스트가 필요합니다
- Preview와 UI 테스트에서만 사용하세요
