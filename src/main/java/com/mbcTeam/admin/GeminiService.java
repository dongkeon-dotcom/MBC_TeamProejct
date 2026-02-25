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
        	String promptText = 
        			"당신은 이커머스 전문 카피라이터이자 SEO 전문가입니다.\n" +
        				    "[입력 정보]\n" +
        				    "- 상품명: " + productName + "\n" +
        				    "- 카테고리: " + features+ "\n" +

        				    "[작성 지침]\n" +
        				    "1. 일관성: 전문적이면서도 친근한 '해요체'를 사용하세요.\n" +
        				    "2. SEO 최적화: 상품명과 카테고리에 포함된 핵심 키워드를 문장에 자연스럽게 녹여내세요.\n" +
        				    "3. 할루시네이션 제어: 제공된 이미지와 텍스트 정보에 없는 기능이나 스펙은 절대로 지어내지 마세요. 확실하지 않은 정보는 언급하지 않습니다.\n" +
        				    "4. 멀티모달 분석: 첨부된 이미지에서 확인되는 색상, 재질, 디자인적 특징을 한 문장 이상 포함하세요.\n\n" +

        				    "[출력 형식]\n" +
        				    "- 300자 이내의 홍보 문구\n" +
        				    "- 문구 하단에 '#키워드' 형식으로 관련 태그 3개 추천\n" +
        				    "- 문구는 [헤드라인]과 [본문]으로 구분하세요.";
        	
        	textPart.put("text", promptText);        	
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
            //System.out.println("********************************************");
            //System.out.println(root);
            return root.path("candidates").get(0)
                       .path("content").path("parts").get(0)
                       .path("text").asText();

        } catch (Exception e) {
            e.printStackTrace();
            return "설명 생성 중 오류가 발생했습니다: " + e.getMessage();
        }
    }
}
