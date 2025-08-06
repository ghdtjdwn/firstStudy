package com.example.festival.service;

import com.example.festival.entity.Member;
import com.example.festival.exception.MemberNotFoundException;
import com.example.festival.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class MemberService {
    
    private final MemberRepository memberRepository;
    
    // 전체 회원 목록 조회
    public List<Member> getAllMembers() {
        return memberRepository.findAll();
    }
    
    // 새 회원 추가
    public Member createMember(Member member) {
        return memberRepository.save(member);
    }
    
    // 회원 삭제
    public void deleteMember(Long id) {
        // 존재 여부 확인 후 삭제 (EmptyResultDataAccessException 방지)
        if (!memberRepository.existsById(id)) {
            log.warn("존재하지 않는 회원 삭제 시도: ID={}", id);
            throw new MemberNotFoundException(id);
        }
        log.info("회원 삭제 처리: ID={}", id);
        memberRepository.deleteById(id);
    }
} 