# API 테스트 스크립트

Write-Host "=== 회원 관리 API 테스트 ===" -ForegroundColor Green

# 1. 전체 회원 목록 조회
Write-Host "`n1. 전체 회원 목록 조회 (GET /api/members)" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/members" -Method GET
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "오류: $($_.Exception.Message)" -ForegroundColor Red
}

# 2. 새 회원 추가
Write-Host "`n2. 새 회원 추가 (POST /api/members)" -ForegroundColor Yellow
try {
    $newMember = @{
        name = "홍길동"
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/members" -Method POST -Body $newMember -ContentType "application/json"
    Write-Host "추가된 회원:" -ForegroundColor Cyan
    $response | ConvertTo-Json
} catch {
    Write-Host "오류: $($_.Exception.Message)" -ForegroundColor Red
}

# 3. 다시 전체 회원 목록 조회
Write-Host "`n3. 업데이트된 회원 목록 조회" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/members" -Method GET
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "오류: $($_.Exception.Message)" -ForegroundColor Red
}

# 4. 회원 삭제 (ID 1번 삭제)
Write-Host "`n4. 회원 삭제 (DELETE /api/members/1)" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/members/1" -Method DELETE
    Write-Host "삭제 결과: $($response.result)" -ForegroundColor Cyan
} catch {
    Write-Host "오류: $($_.Exception.Message)" -ForegroundColor Red
}

# 5. 최종 회원 목록 조회
Write-Host "`n5. 최종 회원 목록 조회" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/members" -Method GET
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "오류: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== 테스트 완료 ===" -ForegroundColor Green 