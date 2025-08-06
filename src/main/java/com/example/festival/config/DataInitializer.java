package com.example.festival.config;

import com.example.festival.entity.Member;
import com.example.festival.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {
    
    private final MemberRepository memberRepository;
    
    @Override
    public void run(String... args) throws Exception {
        // 테스트 데이터 초기화
        if (memberRepository.count() == 0) {
            memberRepository.save(new Member(null, "Jin"));
            memberRepository.save(new Member(null, "Alice"));
            memberRepository.save(new Member(null, "Bob"));
            System.out.println("테스트 데이터가 초기화되었습니다.");
        }
    }
} 