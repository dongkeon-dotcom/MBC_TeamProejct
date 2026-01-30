<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:import url="/WEB-INF/view/include/top.jsp" />
<link href="${path}/resources/css/product/productAdd.css" rel="stylesheet">

<section>

<div class="container my-5" style="max-width: 800px;">
    <h2 class="text-center mb-5 fw-bold">상품 등록 페이지</h2>

    <form action="/product/productAddFormOK.do" method="post" enctype="multipart/form-data">
            <div class="card p-4 mb-4 shadow-sm mx-auto" style="max-width: 80%;">
            	<div class="row px-md-5">
	                <div class="col-12 mb-4">
                    	<label class="main-label">카테고리</label>
                    	<select class="form-select" name="productCategory" id="productCategory" onchange="updateSubCategories()">
                        	<option selected> -- 카테고리 선택 -- </option>
                        	<option value="아우터"> 아우터 </option>
                        	<option value="상의"> 상의 </option>
                        	<option value="바지"> 바지 </option>
                        	<option value="치마"> 치마 </option>
                        	<option value="원피스"> 원피스 </option>
                    	</select>
                	</div>
                	<div class="col-12 mb-4">
	                    <label class="main-label">하위카테고리</label>
                    	<select class="form-select" name="productSubCategory" id="productSubCategory">
	                        <option selected> -- 하위 카테고리 선택 -- </option>
                    	</select>
                	</div>
                	<div class="col-12 mb-4">
	                    <label class="main-label">상품명</label>
                    	<input type="text" class="form-control" name="pName" placeholder="상품 이름">
                	</div>
                	<div class="col-12 mb-4">
	                    <label class="main-label">상품가격</label>
	                    <div class="input-group">
	                    	
                    		<input type="number" class="form-control" name="pPrice" id="pPrice" placeholder="0" min="0">
                    		<span class="input-group-text">원</span>
                    	</div>
                	</div>
                	<div class="col-12 mb-4">
	                    <label class="main-label">등록날짜 (자동등록)</label>
                    	<input type="text" class="form-control bg-light" name="regDate" 
                           	value="<fmt:formatDate value='<%= new java.util.Date() %>' pattern='yyyy-MM-dd' />" readonly>
                	</div>
            	</div>
                    	
            	<div class="row mb-4">
	                <div class="col-md-12 mb-4">
	                	<div class="upload-header">
                    		<label class="upload-label">대표이미지</label>
                    		<button type="button" class="btn btn-outline-primary btn-sm" onclick="triggerFileSelect('mainFileList')">
                    			+ 이미지 추가
                    		</button>
                    	</div>                    	
                    	<div id="mainFileList" class="file-list-container">
                    	</div>
                    </div>                 
                </div>
            	<div class="row mb-4">
	                <div class="col-md-12 mb-4">
	                	<div class="upload-header">
                    		<label class="upload-label">상세이미지</label>
                    		<button type="button" class="btn btn-outline-primary btn-sm" onclick="triggerFileSelect('detailFileList')">
                    			+ 이미지 추가
                    		</button>
                    	</div>                    	
                    	<div id="detailFileList" class="file-list-container">
                    	</div>
                    </div>                 
                </div>
            	<div class="row mb-4">
	                <div class="col-md-12 mb-4">
	                	<div class="upload-header">
                    		<label class="upload-label">설명이미지</label>
                    		<button type="button" class="btn btn-outline-primary btn-sm" onclick="triggerFileSelect('descFileList')">
                    			+ 이미지 추가
                    		</button>
                    	</div>                    	
                    	<div id="descFileList" class="file-list-container">
                    	</div>
                    </div>                 
                </div>
            	<div class="row mb-4">
	                <div class="col-md-12 mb-4">
	                	<div class="upload-header">
                    		<label class="upload-label">상품사이즈</label>
                    		<button type="button" class="btn btn-outline-primary btn-sm" onclick="triggerFileSelect('sizeFileList')">
                    			+ 이미지 추가
                    		</button>
                    	</div>                    	
                    	<div id="sizeFileList" class="file-list-container">
                    	</div>
                    </div>                 
                </div>
            	    <div class="mb-4 position-relative">
            			<label class="form-label fw-bold">상품설명</label>
            			<button type="button" class="btn btn-outline-secondary btn-sm ai-gen-btn">ai 생성</button>
            			<textarea class="form-control" rows="5" placeholder="상품 설명"></textarea>
        			</div>
        	</div>
	
        <div class="table-container shadow-sm border mb-4">
            <table class="table align-middle text-center">
                <thead>
                    <tr>
                        <th width="35%">컬러</th>
                        <th width="35%">사이즈</th>
                        <th width="20%">수량</th>
                        <th width="10%"></th>
                    </tr>
                </thead>
                <tbody id="optionBody" name="optionBody">

                </tbody>
            </table>
            <button type="button" class="btn btn-outline-primary btn-sm ms-3 d-inline-flex align-items-center" onclick="addRow()">+ 옵션 추가</button>
        </div>

		<div class="submit-btn-wrapper">
            <button type="submit" class="btn btn-primary btn-lg py-3 fw-bold w-50">상품 등록하기</button>
        </div>
    </form>
</div>

<script>
//카테고리쪽
const subCategories = {
	    "아우터": ["자켓", "코트", "패딩/점퍼", "가디건", "베스트", "레더/무스탕"],
	    "상의": ["티셔츠", "셔츠/블라우스", "니트", "맨투맨/후드", "슬리브리스"],
	    "바지": ["데님", "슬랙스", "코튼 팬츠", "조거/트레이닝", "쇼츠"],
	    "치마": ["미니스커트", "롱스커트", "H라인 스커트", "플리츠/A라인", "데님 스커트"],
	    "원피스": ["미니 원피스", "롱 원피스", "셔츠 원피스", "니트 원피스", "점프슈트"]
	};
function updateSubCategories() {
    const categorySelect = document.getElementById("productCategory");
    const subCategorySelect = document.getElementById("productSubCategory");

    const selectedCategory = categorySelect.value;

    // 기존 옵션 초기화
    subCategorySelect.innerHTML = "<option value=''> -- 하위 카테고리 선택 -- </option>";

    // 선택된 카테고리에 맞는 하위 카테고리 추가
    if (subCategories[selectedCategory]) {
        subCategories[selectedCategory].forEach(function(sub) {
            const option = document.createElement("option");
            option.value = sub;
            option.text = sub;
            subCategorySelect.appendChild(option);
        });
    }
}


//옵션쪽
function addRow() {
        const tbody = document.getElementById("optionBody");
        
        // 새 행 생성
        const newRow = document.createElement("tr");
        newRow.className = "option-row";
        
        newRow.innerHTML = `
            <td>
                <select name="color" class="form-select">
                    <option value="White">White</option>
                    <option value="Black">Black</option>
                    <option value="Gray">Gray</option>
                    <option value="Red">Red</option>
                    <option value="Blue">Blue</option>
                    <option value="Green">Green</option>
                    <option value="Brown">Brown</option>
                </select>
            </td>
            <td>
                <select name="size" class="form-select">
                    <option value="S">S</option>
                    <option value="M">M</option>
                    <option value="L">L</option>
                </select>
            </td>
            <td>
                <input type="number" name="quantity" class="form-control" value="0" min="0">
            </td>
            <td><button type="button" class="btn btn-outline-danger btn-sm" onclick="removeRow(this)">삭제</button></td>
        `;
        
        tbody.appendChild(newRow);
    }

    function removeRow(button) {
        const row = button.closest('tr');
        row.remove();
    }

// 박스 클릭시 동작
function triggerUpload(box){
	box.querySelector('input[type="file"]').click();
}

</script>



</section>
<c:import url="/WEB-INF/view/include/bottom.jsp"/>