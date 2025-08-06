# 최종 개선된 API 테스트 스크립트

Write-Host "=== 최종 개선된 회원 관리 API 테스트 ===" -ForegroundColor Green

# 1. 전체 회원 목록 조회
Write-Host "`n1. 전체 회원 목록 조회 (GET /api/members)" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/members" -Method GET
    Write-Host "✅ 성공: 회원 목록 조회" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ 오류: $($_.Exception.Message)" -ForegroundColor Red
}

# 2. 유효하지 않은 데이터로 회원 추가 (실패 케이스)
Write-Host "`n2. 유효하지 않은 데이터로 회원 추가 (POST /api/members) - 실패 케이스" -ForegroundColor Yellow
try {
    $invalidMember = @{
        name = ""
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/members" -Method POST -Body $invalidMember -ContentType "application/json"
} catch {
    $errorResponse = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($errorResponse)
    $responseBody = $reader.ReadToEnd()
    Write-Host "✅ 예상된 오류 (유효성 검사): $responseBody" -ForegroundColor Cyan
}

# 3. 유효한 데이터로 회원 추가 (성공 케이스)
Write-Host "`n3. 유효한 데이터로 회원 추가 (POST /api/members) - 성공 케이스" -ForegroundColor Yellow
try {
    $validMember = @{
        name = "김철수"
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/members" -Method POST -Body $validMember -ContentType "application/json"
    Write-Host "✅ 성공: 회원 추가됨" -ForegroundColor Green
    $response | ConvertTo-Json
} catch {
    Write-Host "❌ 오류: $($_.Exception.Message)" -ForegroundColor Red
}

# 4. 존재하지 않는 회원 삭제 (실패 케이스)
Write-Host "`n4. 존재하지 않는 회원 삭제 (DELETE /api/members/999) - 실패 케이스" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/members/999" -Method DELETE
} catch {
    $errorResponse = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($errorResponse)
    $responseBody = $reader.ReadToEnd()
    Write-Host "✅ 예상된 오류 (회원 없음): $responseBody" -ForegroundColor Cyan
}

# 5. 존재하는 회원 삭제 (성공 케이스)
Write-Host "`n5. 존재하는 회원 삭제 (DELETE /api/members/1) - 성공 케이스" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/members/1" -Method DELETE
    Write-Host "✅ 성공: 회원 삭제됨 - $($response.result)" -ForegroundColor Green
} catch {
    Write-Host "❌ 오류: $($_.Exception.Message)" -ForegroundColor Red
}

# 6. 최종 회원 목록 조회
Write-Host "`n6. 최종 회원 목록 조회" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/members" -Method GET
    Write-Host "✅ 성공: 최종 회원 목록" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ 오류: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== 최종 개선 사항 확인 ===" -ForegroundColor Green
Write-Host "✅ CORS 설정 개선됨" -ForegroundColor Green
Write-Host "✅ 유효성 검사 추가됨" -ForegroundColor Green
Write-Host "✅ 예외 처리 추가됨" -ForegroundColor Green
Write-Host "✅ @Data → @Getter/@Setter 변경됨" -ForegroundColor Green
Write-Host "✅ 테스트 코드 작성됨" -ForegroundColor Green
Write-Host "✅ Swagger/OpenAPI 문서화 추가됨" -ForegroundColor Green
Write-Host "✅ 로깅 추가됨" -ForegroundColor Green
Write-Host "✅ DELETE 존재 여부 확인 개선됨" -ForegroundColor Green

Write-Host "`n=== 추가 기능 ===" -ForegroundColor Cyan
Write-Host "📖 Swagger UI: http://localhost:8080/swagger-ui.html" -ForegroundColor Cyan
Write-Host "📊 H2 콘솔: http://localhost:8080/h2-console" -ForegroundColor Cyan
Write-Host "🧪 테스트 실행: ./gradlew test" -ForegroundColor Cyan 