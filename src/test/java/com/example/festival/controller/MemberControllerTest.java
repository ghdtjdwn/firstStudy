package com.example.festival.controller;

import com.example.festival.entity.Member;
import com.example.festival.service.MemberService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Arrays;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import com.example.festival.dto.ApiResponse;
import com.example.festival.exception.MemberNotFoundException;

@WebMvcTest(MemberController.class)
class MemberControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private MemberService memberService;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void getAllMembers_ShouldReturnMembers() throws Exception {
        // Given
        List<Member> members = Arrays.asList(
            new Member(1L, "Jin"),
            new Member(2L, "Alice")
        );
        when(memberService.getAllMembers()).thenReturn(members);

        // When & Then
        mockMvc.perform(get("/api/members"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data[0].id").value(1))
                .andExpect(jsonPath("$.data[0].name").value("Jin"))
                .andExpect(jsonPath("$.data[1].id").value(2))
                .andExpect(jsonPath("$.data[1].name").value("Alice"));
    }

    @Test
    void createMember_WithValidData_ShouldReturnCreatedMember() throws Exception {
        // Given
        Member member = new Member(null, "홍길동");
        Member createdMember = new Member(1L, "홍길동");
        when(memberService.createMember(any(Member.class))).thenReturn(createdMember);

        // When & Then
        mockMvc.perform(post("/api/members")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(member)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.name").value("홍길동"));
    }

    @Test
    void createMember_WithInvalidData_ShouldReturnBadRequest() throws Exception {
        // Given
        Member member = new Member(null, ""); // 빈 이름

        // When & Then
        mockMvc.perform(post("/api/members")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(member)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void deleteMember_WithValidId_ShouldReturnOk() throws Exception {
        // Given
        Long memberId = 1L;
        doNothing().when(memberService).deleteMember(memberId);

        // When & Then
        mockMvc.perform(delete("/api/members/{id}", memberId))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value("ok"));
    }

    @Test
    void deleteMember_WithInvalidId_ShouldReturnNotFound() throws Exception {
        // Given
        Long memberId = 999L;
        doThrow(new MemberNotFoundException(memberId)).when(memberService).deleteMember(memberId);

        // When & Then
        mockMvc.perform(delete("/api/members/{id}", memberId))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.errorCode").value("MEMBER_NOT_FOUND"));
    }
} 