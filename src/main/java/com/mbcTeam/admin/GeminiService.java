package com.mbcTeam.admin;

import java.util.*;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@PropertySource("classpath:config/gemini.properties")
@Service
public class GeminiService {
	

	@Value("${gemini.api.key}")
	private String API_KEY;
	
	@Value("${gemini.api.url}")
	private String URL;

    public String getAiDescription(String productName, String features, byte[] imageBytes, String mimeType) {
        RestTemplate restTemplate = new RestTemplate();
        ObjectMapper mapper = new ObjectMapper();

        String API = URL+"?key="+API_KEY; 
        try {
        	
        	// 이미지 Base64 인코딩
        	String base64Img = Base64.getEncoder().encodeToString(imageBytes);
        	
        	List<Map<String, Object>> partsList = new ArrayList<>();
        	
        	// 텍스트
        	Map<String, Object> textPart = new HashMap<>();
        	textPart.put("text", "상품명: " + productName + ", 특징: " + features + ". 제공된 이미지를 분석하여 300자 이내 홍보 문구 작성해줘.");        	
            partsList.add(textPart);
            
            // 이미지
            Map<String, Object> imagePart = new HashMap<>();
            Map<String, Object> inlineData = new HashMap<>();
            inlineData.put("mime_type", mimeType); // 예: "image/jpeg"
            inlineData.put("data", base64Img);
            imagePart.put("inline_data", inlineData);
            partsList.add(imagePart);

            // 구조 생성(contents -> parts)
            Map<String, Object> content = new HashMap<>();
            content.put("parts", partsList);

            List<Map<String, Object>> contentsList = new ArrayList<>();
            contentsList.add(content);

            Map<String, Object> requestBodyMap = new HashMap<>();
            requestBodyMap.put("contents", contentsList);

            // Map을 JSON 문자열로 변환
            String jsonRequest = mapper.writeValueAsString(requestBodyMap);

            // 헤더 설정 (Content-Type을 application/json으로 명시)
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            // 요청 엔티티 생성
            HttpEntity<String> entity = new HttpEntity<>(jsonRequest, headers);

            // API 호출 (Post)
            String jsonResponse = restTemplate.postForObject(API, entity, String.class);

            // 결과 파싱 (이전과 동일)
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
