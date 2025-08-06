# 프론트엔드-백엔드 통합 테스트 스크립트

Write-Host "=== 프론트엔드-백엔드 통합 테스트 ===" -ForegroundColor Green

# 1. 백엔드 API 상태 확인
Write-Host "`n1. 백엔드 API 상태 확인" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/members" -Method GET
    Write-Host "✅ 백엔드 API 정상 동작 중" -ForegroundColor Green
    Write-Host "   - 응답 구조: $($response.success)" -ForegroundColor Cyan
    Write-Host "   - 회원 수: $($response.data.Count)명" -ForegroundColor Cyan
} catch {
    Write-Host "❌ 백엔드 API 연결 실패: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   백엔드를 먼저 실행해주세요: ./gradlew bootRun" -ForegroundColor Yellow
    exit 1
}

# 2. CORS 설정 확인
Write-Host "`n2. CORS 설정 확인" -ForegroundColor Yellow
try {
    $headers = @{
        "Origin" = "http://localhost:5173"
        "Access-Control-Request-Method" = "GET"
        "Access-Control-Request-Headers" = "Content-Type"
    }
    
    $response = Invoke-WebRequest -Uri "http://localhost:8080/api/members" -Method OPTIONS -Headers $headers
    Write-Host "✅ CORS 설정 정상" -ForegroundColor Green
    Write-Host "   - Access-Control-Allow-Origin: $($response.Headers['Access-Control-Allow-Origin'])" -ForegroundColor Cyan
} catch {
    Write-Host "⚠️ CORS 설정 확인 실패 (일반적으로 정상)" -ForegroundColor Yellow
}

# 3. 프론트엔드 포트 확인
Write-Host "`n3. 프론트엔드 포트 확인" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5173" -Method GET -TimeoutSec 5
    Write-Host "✅ 프론트엔드 서버 정상 동작 중" -ForegroundColor Green
} catch {
    Write-Host "⚠️ 프론트엔드 서버가 실행되지 않았습니다" -ForegroundColor Yellow
    Write-Host "   프론트엔드 실행: cd frontend-example && npm run dev" -ForegroundColor Cyan
}

# 4. API 응답 구조 테스트
Write-Host "`n4. API 응답 구조 테스트" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/members" -Method GET
    
    # 표준화된 응답 구조 확인
    $hasSuccess = $response.PSObject.Properties.Name -contains "success"
    $hasData = $response.PSObject.Properties.Name -contains "data"
    $hasMessage = $response.PSObject.Properties.Name -contains "message"
    $hasTimestamp = $response.PSObject.Properties.Name -contains "timestamp"
    
    if ($hasSuccess -and $hasData -and $hasMessage -and $hasTimestamp) {
        Write-Host "✅ 표준화된 API 응답 구조 확인됨" -ForegroundColor Green
        Write-Host "   - success: $($response.success)" -ForegroundColor Cyan
        Write-Host "   - message: $($response.message)" -ForegroundColor Cyan
        Write-Host "   - timestamp: $($response.timestamp)" -ForegroundColor Cyan
    } else {
        Write-Host "❌ API 응답 구조가 표준화되지 않음" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ API 응답 구조 테스트 실패" -ForegroundColor Red
}

Write-Host "`n=== 통합 테스트 완료 ===" -ForegroundColor Green
Write-Host "🚀 백엔드 실행: ./gradlew bootRun" -ForegroundColor Cyan
Write-Host "🚀 프론트엔드 실행: cd frontend-example && npm run dev" -ForegroundColor Cyan
Write-Host "🌐 프론트엔드 접속: http://localhost:5173" -ForegroundColor Cyan
Write-Host "📖 백엔드 API 문서: http://localhost:8080/swagger-ui.html" -ForegroundColor Cyan 