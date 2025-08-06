package com.example.festival.controller;

import com.example.festival.dto.ApiResponse;
import com.example.festival.entity.Member;
import com.example.festival.service.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/members")
@RequiredArgsConstructor
@Validated
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:5173", "http://127.0.0.1:5173"}) // 개발 환경 CORS 설정
@Tag(name = "회원 관리", description = "회원 CRUD API")
@Slf4j
public class MemberController {
    
    private final MemberService memberService;
    
    // GET /api/members - 전체 회원 리스트 조회
    @GetMapping
    @Operation(summary = "전체 회원 목록 조회", description = "등록된 모든 회원의 목록을 조회합니다.")
    @ApiResponses(value = {
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "회원 목록 조회 성공"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 내부 오류")
    })
    public ResponseEntity<ApiResponse<List<Member>>> getAllMembers() {
        log.info("전체 회원 목록 조회 요청");
        List<Member> members = memberService.getAllMembers();
        log.info("회원 목록 조회 완료: {}명", members.size());
        return ResponseEntity.ok(ApiResponse.success(members, "회원 목록 조회 성공"));
    }
    
    // POST /api/members - 새 회원 추가
    @PostMapping
    @Operation(summary = "새 회원 추가", description = "새로운 회원을 등록합니다.")
    @ApiResponses(value = {
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "회원 추가 성공"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "잘못된 요청 데이터"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 내부 오류")
    })
    public ResponseEntity<ApiResponse<Member>> createMember(@Valid @RequestBody Member member) {
        log.info("새 회원 추가 요청: {}", member.getName());
        Member createdMember = memberService.createMember(member);
        log.info("회원 추가 완료: ID={}, 이름={}", createdMember.getId(), createdMember.getName());
        return ResponseEntity.ok(ApiResponse.success(createdMember, "회원 추가 성공"));
    }
    
    // DELETE /api/members/{id} - 회원 삭제
    @DeleteMapping("/{id}")
    @Operation(summary = "회원 삭제", description = "지정된 ID의 회원을 삭제합니다.")
    @ApiResponses(value = {
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "회원 삭제 성공"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "회원을 찾을 수 없음"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 내부 오류")
    })
    public ResponseEntity<ApiResponse<String>> deleteMember(
            @Parameter(description = "삭제할 회원의 ID", example = "1") 
            @PathVariable Long id) {
        log.info("회원 삭제 요청: ID={}", id);
        memberService.deleteMember(id);
        log.info("회원 삭제 완료: ID={}", id);
        return ResponseEntity.ok(ApiResponse.success("ok", "회원 삭제 성공"));
    }
} 