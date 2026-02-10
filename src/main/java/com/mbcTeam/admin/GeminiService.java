package com.mbcTeam.admin;

import java.util.*;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class GeminiService {
	
	//private final String API_KEY ="AIzaSyBj-RUDCmDC7pR0o56MqlpePQvgX21vcXg"; // 내꺼
	private final String API_KEY = "AIzaSyCvNxfI8ulzslKRyHdWvEGxnA-XfllJe9s"; // 강사님꺼
	private final String URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=" + API_KEY;

    public String getAiDescription(String productName, String features) {
        RestTemplate restTemplate = new RestTemplate();
        ObjectMapper mapper = new ObjectMapper();

        try {
        	Map<String, String> parts = new HashMap<>();
            parts.put("text", "상품명: " + productName + ", 특징: " + features + ". 200자 이내 홍보 문구 작성.");

            List<Map<String, String>> partsList = new ArrayList<>();
            partsList.add(parts);

            Map<String, Object> content = new HashMap<>();
            content.put("parts", partsList);

            List<Map<String, Object>> contentsList = new ArrayList<>();
            contentsList.add(content);

            Map<String, Object> requestBodyMap = new HashMap<>();
            requestBodyMap.put("contents", contentsList);

            // 2. [핵심] Map을 진짜 JSON 문자열로 변환
            String jsonRequest = mapper.writeValueAsString(requestBodyMap);

            // 3. 헤더 설정 (Content-Type을 application/json으로 명시)
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            // 4. 요청 엔티티 생성
            HttpEntity<String> entity = new HttpEntity<>(jsonRequest, headers);

            // 5. API 호출 (Post)
            String jsonResponse = restTemplate.postForObject(URL, entity, String.class);

            // 6. 결과 파싱 (이전과 동일)
            JsonNode root = mapper.readTree(jsonResponse);
            System.out.println("********************************************");
            System.out.println(root);
            return root.path("candidates").get(0)
                       .path("content").path("parts").get(0)
                       .path("text").asText();

        } catch (Exception e) {
            e.printStackTrace();
            return "설명 생성 중 오류가 발생했습니다: " + e.getMessage();
        }
    }
}
