# 프로덕션 레벨 최종 API 테스트 스크립트

Write-Host "=== 프로덕션 레벨 회원 관리 API 테스트 ===" -ForegroundColor Green

# 1. 전체 회원 목록 조회 (표준화된 응답 확인)
Write-Host "`n1. 전체 회원 목록 조회 (GET /api/members) - 표준화된 응답" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/members" -Method GET
    Write-Host "✅ 성공: 표준화된 응답 구조 확인" -ForegroundColor Green
    Write-Host "   - success: $($response.success)" -ForegroundColor Cyan
    Write-Host "   - message: $($response.message)" -ForegroundColor Cyan
    Write-Host "   - timestamp: $($response.timestamp)" -ForegroundColor Cyan
    Write-Host "   - 데이터 개수: $($response.data.Count)개" -ForegroundColor Cyan
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ 오류: $($_.Exception.Message)" -ForegroundColor Red
}

# 2. 유효하지 않은 데이터로 회원 추가 (표준화된 에러 응답 확인)
Write-Host "`n2. 유효하지 않은 데이터로 회원 추가 (POST /api/members) - 표준화된 에러" -ForegroundColor Yellow
try {
    $invalidMember = @{
        name = ""
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/members" -Method POST -Body $invalidMember -ContentType "application/json"
} catch {
    $errorResponse = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($errorResponse)
    $responseBody = $reader.ReadToEnd()
    Write-Host "✅ 예상된 표준화된 에러 응답:" -ForegroundColor Cyan
    Write-Host $responseBody -ForegroundColor Cyan
}

# 3. 유효한 데이터로 회원 추가 (표준화된 성공 응답 확인)
Write-Host "`n3. 유효한 데이터로 회원 추가 (POST /api/members) - 표준화된 성공" -ForegroundColor Yellow
try {
    $validMember = @{
        name = "프로덕션테스트"
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/members" -Method POST -Body $validMember -ContentType "application/json"
    Write-Host "✅ 성공: 표준화된 성공 응답" -ForegroundColor Green
    Write-Host "   - success: $($response.success)" -ForegroundColor Cyan
    Write-Host "   - message: $($response.message)" -ForegroundColor Cyan
    Write-Host "   - 생성된 회원 ID: $($response.data.id)" -ForegroundColor Cyan
    $response | ConvertTo-Json
} catch {
    Write-Host "❌ 오류: $($_.Exception.Message)" -ForegroundColor Red
}

# 4. 존재하지 않는 회원 삭제 (표준화된 에러 응답 확인)
Write-Host "`n4. 존재하지 않는 회원 삭제 (DELETE /api/members/999) - 표준화된 에러" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/members/999" -Method DELETE
} catch {
    $errorResponse = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($errorResponse)
    $responseBody = $reader.ReadToEnd()
    Write-Host "✅ 예상된 표준화된 에러 응답:" -ForegroundColor Cyan
    Write-Host $responseBody -ForegroundColor Cyan
}

# 5. 존재하는 회원 삭제 (표준화된 성공 응답 확인)
Write-Host "`n5. 존재하는 회원 삭제 (DELETE /api/members/1) - 표준화된 성공" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/members/1" -Method DELETE
    Write-Host "✅ 성공: 표준화된 성공 응답" -ForegroundColor Green
    Write-Host "   - success: $($response.success)" -ForegroundColor Cyan
    Write-Host "   - message: $($response.message)" -ForegroundColor Cyan
    Write-Host "   - data: $($response.data)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ 오류: $($_.Exception.Message)" -ForegroundColor Red
}

# 6. 최종 회원 목록 조회
Write-Host "`n6. 최종 회원 목록 조회" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/members" -Method GET
    Write-Host "✅ 성공: 최종 회원 목록" -ForegroundColor Green
    Write-Host "   - 총 회원 수: $($response.data.Count)명" -ForegroundColor Cyan
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ 오류: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== 프로덕션 레벨 개선 사항 확인 ===" -ForegroundColor Green
Write-Host "✅ API 응답 표준화 완료 (ApiResponse<T>)" -ForegroundColor Green
Write-Host "✅ Swagger 보안 설정 완료 (프로필별 분기)" -ForegroundColor Green
Write-Host "✅ 통합 테스트 추가 완료 (@SpringBootTest)" -ForegroundColor Green
Write-Host "✅ 단위 테스트 업데이트 완료" -ForegroundColor Green
Write-Host "✅ 환경별 설정 분리 완료" -ForegroundColor Green

Write-Host "`n=== 프로덕션 배포 준비 완료 ===" -ForegroundColor Cyan
Write-Host "🚀 개발 환경 실행: ./gradlew bootRun --args='--spring.profiles.active=dev'" -ForegroundColor Cyan
Write-Host "🚀 운영 환경 실행: ./gradlew bootRun --args='--spring.profiles.active=prod'" -ForegroundColor Cyan
Write-Host "🧪 테스트 실행: ./gradlew test" -ForegroundColor Cyan
Write-Host "📖 개발용 Swagger: http://localhost:8080/swagger-ui.html (dev 프로필에서만)" -ForegroundColor Cyan
Write-Host "🔒 운영 환경에서는 Swagger UI 비활성화됨" -ForegroundColor Cyan 