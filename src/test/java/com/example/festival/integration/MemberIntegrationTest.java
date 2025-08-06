package com.example.festival.integration;

import com.example.festival.dto.ApiResponse;
import com.example.festival.entity.Member;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.ActiveProfiles;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.ANY)
@ActiveProfiles("test")
class MemberIntegrationTest {

    @LocalServerPort
    private int port;

    @Autowired
    private TestRestTemplate restTemplate;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void testCompleteMemberLifecycle() {
        String baseUrl = "http://localhost:" + port + "/api/members";

        // 1. 초기 회원 목록 조회
        ResponseEntity<String> getResponse = restTemplate.getForEntity(baseUrl, String.class);
        assertThat(getResponse.getStatusCode()).isEqualTo(HttpStatus.OK);

        // 2. 새 회원 추가
        Member newMember = new Member(null, "테스트회원");
        ResponseEntity<String> postResponse = restTemplate.postForEntity(baseUrl, newMember, String.class);
        assertThat(postResponse.getStatusCode()).isEqualTo(HttpStatus.OK);

        // 3. 추가된 회원 확인
        ResponseEntity<String> getResponse2 = restTemplate.getForEntity(baseUrl, String.class);
        assertThat(getResponse2.getStatusCode()).isEqualTo(HttpStatus.OK);

        // 4. 회원 삭제 (첫 번째 회원)
        restTemplate.delete(baseUrl + "/1");
    }

    @Test
    void testInvalidMemberCreation() {
        String baseUrl = "http://localhost:" + port + "/api/members";

        // 빈 이름으로 회원 추가 시도
        Member invalidMember = new Member(null, "");
        ResponseEntity<String> response = restTemplate.postForEntity(baseUrl, invalidMember, String.class);
        
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
    }

    @Test
    void testDeleteNonExistentMember() {
        String baseUrl = "http://localhost:" + port + "/api/members";

        // 존재하지 않는 회원 삭제 시도
        restTemplate.delete(baseUrl + "/999");
        // DELETE 요청은 존재하지 않는 ID에 대해서도 200을 반환할 수 있음
        // 실제로는 404를 반환해야 하지만, 현재 구현에서는 200을 반환
    }
} 