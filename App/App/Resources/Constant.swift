//
//  Constant.swift
//  App
//
//  Created by Jinyoung Yoo on 11/15/24.
//

enum Constant {
    
    enum Literal {
        
        enum Onboarding {
            static var description: String { "콜라비를 사용하면 어디서나\n팀을 모을 수 있습니다" }
            static var emailLogin: String { "이메일로 계속하기" }
        }
        
        enum HomeEmpty {
            static var title: String { "워크스페이스를 찾을 수 없어요." }
            static var subtitle: String { "관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나\n새로운 워크스페이스를 생성해주세요." }
        }
        
        enum CreateWorkSpace {
            static var navTitle: String { "워크스페이스 생성" }
            static var nameTextField: String { "워크스페이스 이름" }
            static var nameTextFieldPlaceHolder: String { "워크스페이스 이름을 입력하세요(필수)" }
            static var descriptionTextField: String { "워크스페이스 설명" }
            static var descriptionTextFieldPlaceHolder: String { "워크스페이스 설명을 입력하세요(옵션)" }
        }
        
        enum ButtonText {
            static var createWorkspace: String { "워크스페이스 생성" }
            static var complete: String  { "완료" }
        }
    }
}

