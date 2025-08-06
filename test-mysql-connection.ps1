# MySQL 연결 테스트 스크립트

Write-Host "=== MySQL 연결 테스트 ===" -ForegroundColor Green

# MySQL 서버 상태 확인
Write-Host "`n1. MySQL 서버 상태 확인" -ForegroundColor Yellow
try {
    $mysqlProcess = Get-Process -Name "mysqld" -ErrorAction SilentlyContinue
    if ($mysqlProcess) {
        Write-Host "✅ MySQL 서버 실행 중 (PID: $($mysqlProcess.Id))" -ForegroundColor Green
    } else {
        Write-Host "❌ MySQL 서버가 실행되지 않았습니다" -ForegroundColor Red
        Write-Host "   MySQL 서버를 시작해주세요" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "❌ MySQL 프로세스 확인 실패" -ForegroundColor Red
}

# MySQL 포트 확인
Write-Host "`n2. MySQL 포트 확인" -ForegroundColor Yellow
try {
    $portCheck = Test-NetConnection -ComputerName localhost -Port 3306 -InformationLevel Quiet
    if ($portCheck) {
        Write-Host "✅ MySQL 포트 3306 정상" -ForegroundColor Green
    } else {
        Write-Host "❌ MySQL 포트 3306 연결 실패" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ 포트 확인 실패: $($_.Exception.Message)" -ForegroundColor Red
}

# MySQL 연결 테스트 (mysql 명령어 사용)
Write-Host "`n3. MySQL 사용자 연결 테스트" -ForegroundColor Yellow
try {
    $mysqlTest = mysql -u springuser -p'rhdqnskgkwk78!' -e "SELECT 'MySQL 연결 성공!' as message;" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ MySQL 사용자 연결 성공" -ForegroundColor Green
        Write-Host "   $($mysqlTest | Select-String 'MySQL 연결 성공')" -ForegroundColor Cyan
    } else {
        Write-Host "❌ MySQL 사용자 연결 실패" -ForegroundColor Red
        Write-Host "   오류: $mysqlTest" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ MySQL 명령어 실행 실패: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   MySQL 클라이언트가 설치되어 있는지 확인해주세요" -ForegroundColor Yellow
}

# 데이터베이스 존재 확인
Write-Host "`n4. 데이터베이스 확인" -ForegroundColor Yellow
try {
    $dbCheck = mysql -u springuser -p'rhdqnskgkwk78!' -e "SHOW DATABASES LIKE 'member_db';" 2>&1
    if ($dbCheck -match "member_db") {
        Write-Host "✅ member_db 데이터베이스 존재" -ForegroundColor Green
    } else {
        Write-Host "⚠️ member_db 데이터베이스가 없습니다" -ForegroundColor Yellow
        Write-Host "   mysql-setup.sql 스크립트를 실행해주세요" -ForegroundColor Cyan
    }
} catch {
    Write-Host "❌ 데이터베이스 확인 실패" -ForegroundColor Red
}

Write-Host "`n=== MySQL 설정 가이드 ===" -ForegroundColor Green
Write-Host "1. MySQL 서버 시작" -ForegroundColor Cyan
Write-Host "2. mysql-setup.sql 실행: mysql -u root -p < mysql-setup.sql" -ForegroundColor Cyan
Write-Host "3. Spring Boot 실행: ./gradlew bootRun --args='--spring.profiles.active=dev'" -ForegroundColor Cyan
Write-Host "4. API 테스트: .\test-api-production-ready.ps1" -ForegroundColor Cyan 