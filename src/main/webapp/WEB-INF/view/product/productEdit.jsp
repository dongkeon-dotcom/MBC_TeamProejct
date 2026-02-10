<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:import url="/WEB-INF/view/include/top.jsp" />
<link href="${path}/resources/css/product/productAdd.css"
	rel="stylesheet">

<section>

	<div class="container my-5" style="max-width: 800px;">
		<h2 class="text-center mb-5 fw-bold">상품 정보 수정 페이지</h2>

		<form action="${path}/product/adminProductEditOK.do" method="post"
			enctype="multipart/form-data" onsubmit="return handleFormSubmit(event)">
			<input type="hidden" name="productIdx" value = "${m.productIdx }"/>
			<!-- OldImgDelete, OldOptionDelete 값 담아두는용 -->
			<div id = "delete-container"></div>
			<div class="card p-4 mb-4 shadow-sm mx-auto" style="max-width: 80%;">
				<div class="row px-md-5">
					<div class="col-12 mb-4">
						<label class="main-label">카테고리</label>
						<select class="form-select"
							name="category" id="category"
							onchange="updateSubCategories()">
							<option selected>-- 카테고리 선택 --</option>
							<option value="아우터" ${m.category == '아우터' ? 'selected' : ''}>아우터</option>
							<option value="상의" ${m.category == '상의' ? 'selected' : ''}>상의</option>
							<option value="바지" ${m.category == '바지' ? 'selected' : ''}>바지</option>
							<option value="치마" ${m.category == '치마' ? 'selected' : ''}>치마</option>
							<option value="원피스" ${m.category == '원피스' ? 'selected' : ''}>원피스</option>
						</select>
					</div>
					
					<div class="col-12 mb-4">
						<label class="main-label">하위카테고리</label>
						<select
							class="form-select"
							name="subCategory" id="subCategory">
							<option selected>-- 하위 카테고리 선택 --</option>
						</select>
					</div>
					
					<div class="col-12 mb-4">
						<label class="main-label">상품명</label>
						<input type="text" class="form-control"
						name="productName" id="productName" placeholder="상품 이름" value="${m.productName}">
					</div>
					<div class="col-12 mb-4">
						<label class="main-label">상품가격</label>
						<div class="input-group">
							<input type="number" class="form-control"
							name="price" id="price" value="${m.price}"
							placeholder="0" min="0">
							<span class="input-group-text">원</span>
						</div>
					</div>
					<div class="col-12 mb-4">
						<label class="main-label">등록날짜 (자동등록)</label>
						<input type="text"
							class="form-control bg-light"
							name="regDate" id="regDate"
							value="${m.regDate}"
							readonly>
					</div>
				</div>

				<div class="row mb-4">
					<div class="col-md-12 mb-4">
						<div class="upload-header">
							<label class="upload-label">대표이미지</label>
							<button type="button" class="btn btn-outline-primary btn-sm"
								onclick="triggerFileSelect('mainFileList')">+ 이미지 추가</button>
						</div>
						<div id="mainFileList" class="file-list-container">
							<c:if test="${not empty m.productMainImg}">
							<div class="input-group mb-2 shadow-sm align-items-center flex-nowrap existing-file-item">
			                    <span class="input-group-text bg-light p-1">
			                        <img class="img-preview" src="${path}/resources/images/ProductMainImg/${m.productMainImg}" 
			                             style="width: 40px; height: 40px; object-fit: cover; border-radius: 4px;">
			                    </span>
			                    <input type="text" class="form-control bg-white name-display" value="${m.productMainImg} (기존)" readonly style="pointer-events: none; font-size: 0.9rem;">
			                    <input type="hidden" name="existingProductMainImg" value="${m.productMainImg}">
			                    <button type="button" class="btn btn-danger btn-sm px-3" style="height: 48px;" onclick="removeFileItem(this, true)">삭제</button>
			                </div>
							</c:if>
						</div>
					</div>
				</div>
				<div class="row mb-4">
					<div class="col-md-12 mb-4">
						<div class="upload-header">
							<label class="upload-label">상세이미지</label>
							<button type="button" class="btn btn-outline-primary btn-sm"
								onclick="triggerFileSelect('detailFileList')">+ 이미지 추가
							</button>
						</div>
						<div id="detailFileList" class="file-list-container">
							<c:forEach var="img" items="${imgList}" varStatus="status">
				                <div class="input-group mb-2 shadow-sm align-items-center flex-nowrap existing-file-item">
				                    <span class="input-group-text bg-light p-1">
				                        <img class="img-preview" src="${path}/resources/images/ProductImg/${img.productImg}" 
				                             style="width: 40px; height: 40px; object-fit: cover; border-radius: 4px;">
				                    </span>
				                    <input type="text" class="form-control bg-white name-display" value="${img.productImg} (기존)" readonly style="pointer-events: none; font-size: 0.9rem;">
				                    <input type="hidden" name="existingImgIdx" value="${img.productImgIdx}">
				                    <button type="button" class="btn btn-danger btn-sm px-3" style="height: 48px;" onclick="OldImgDelete(this, '${img.productImgIdx}', 'Img')">삭제</button>
				                </div>
				            </c:forEach>
						</div>
					</div>
				</div>
				<div class="row mb-4">
					<div class="col-md-12 mb-4">
						<div class="upload-header">
							<label class="upload-label">설명이미지</label>
							<button type="button" class="btn btn-outline-primary btn-sm"
								onclick="triggerFileSelect('descFileList')">+ 이미지 추가</button>
						</div>
						<div id="descFileList" class="file-list-container">
							<c:forEach var="descImg" items="${descImgList}" varStatus="status">
				                <div class="input-group mb-2 shadow-sm align-items-center flex-nowrap existing-file-item">
				                    <span class="input-group-text bg-light p-1">
				                        <img class="img-preview" src="${path}/resources/images/ProductDescImg/${descImg.productDescImg}" 
				                             style="width: 40px; height: 40px; object-fit: cover; border-radius: 4px;">
				                    </span>
				                    <input type="text" class="form-control bg-white name-display" value="${descImg.productDescImg} (기존)" readonly style="pointer-events: none; font-size: 0.9rem;">
				                    <input type="hidden" name="existingDescImgIdx" value="${descImg.productDescImgIdx}">
				                    <button type="button" class="btn btn-danger btn-sm px-3" style="height: 48px;" onclick="OldImgDelete(this, '${descImg.productDescImgIdx}','desc')">삭제</button>
				                </div>
				            </c:forEach>						
						
						
						</div>
					</div>
				</div>
				<div class="row mb-4">
					<div class="col-md-12 mb-4">
						<div class="upload-header">
							<label class="upload-label">상품사이즈</label>
							<button type="button" class="btn btn-outline-primary btn-sm"
								onclick="triggerFileSelect('sizeFileList')">+ 이미지 추가</button>
						</div>
						<div id="sizeFileList" class="file-list-container">
							<c:if test="${not empty m.productSizeImg}">
				                <div class="input-group mb-2 shadow-sm align-items-center flex-nowrap existing-file-item">
				                    <span class="input-group-text bg-light p-1">
				                        <img class="img-preview" src="${path}/resources/images/ProductSizeImg/${m.productSizeImg}" 
				                             style="width: 40px; height: 40px; object-fit: cover; border-radius: 4px;">
				                    </span>
				                    <input type="text" class="form-control bg-white name-display" value="${m.productSizeImg} (기존)" readonly style="pointer-events: none; font-size: 0.9rem;">
				                    <input type="hidden" name="existingProductSizeImg" value="${m.productSizeImg}">
				                    <button type="button" class="btn btn-danger btn-sm px-3" style="height: 48px;" onclick="removeFileItem(this, true)">삭제</button>
				                </div>
				            </c:if>						
						
						</div>
					</div>
				</div>
				<div class="mb-4 position-relative">
					<label class="form-label fw-bold">상품설명</label>
					<button type="button"
						class="btn btn-outline-secondary btn-sm ai-gen-btn">ai 생성</button>
					<textarea class="form-control" name="productDesc" id="productDesc" rows="5" placeholder="상품 설명">${m.productDesc}</textarea>
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
						<c:forEach var="opt" items = "${optionList}" varStatus="status">
							<tr class="option-row">
								<input type="hidden" name="productOptionList[${status.index}].optionIdx" value="${opt.optionIdx}"/>
								<td>
									<select name="productOptionList[${status.index}].color" class="form-select">
				                    	<c:set var="colors" value="White,Black,Gray,Red,Blue,Green,Brown" />
				                    	<c:forTokens items="${colors}" delims="," var="c">
				                        	<option value="${c}" ${opt.color == c ? 'selected' : ''}>${c}</option>
				                    	</c:forTokens>
				                </select>
								</td>
								<td>
					                <select name="productOptionList[${status.index}].size" class="form-select">
					                    <option value="S" ${opt.size == 'S' ? 'selected' : ''}>S</option>
					                    <option value="M" ${opt.size == 'M' ? 'selected' : ''}>M</option>
					                    <option value="L" ${opt.size == 'L' ? 'selected' : ''}>L</option>
					                </select>
					            </td>
					            <td>
					                <input type="number" name="productOptionList[${status.index}].stock" 
					                       class="form-control" value="${opt.stock}" min="0">
					            </td>
					            <td>
					                <button type="button" class="btn btn-outline-danger btn-sm" onclick="removeOldOption(this, '${opt.optionIdx}')">삭제</button>
					            </td>
							</tr>								
						</c:forEach>
					</tbody>
				</table>
				<button type="button"
					class="btn btn-outline-primary btn-sm ms-3 d-inline-flex align-items-center"
					onclick="addRow()">+ 옵션 추가</button>
			</div>

			<div class="submit-btn-wrapper">
				<button type="submit"
					class="btn btn-primary btn-lg py-3 fw-bold w-50">상품 수정하기</button>
			</div>
		</form>
	</div>

<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
<script>
$(document).ready(function() {
    $('.ai-gen-btn').on('click', function() {
        // 1. 필요한 입력값 가져오기 (input 태그의 id를 확인하세요!)
        var pName = $('#productName').val(); // 상품명 입력란 id
        var pFeature = $('#subCategory').val(); // 특징 입력란 id

        if(!pName) {
            alert("상품명을 입력해주세요.");
            return;
        }
        if(!pFeature){
        	alert("하위카테고리를 선택해주세요.");
        	return;
        }

        // 2. 버튼 상태 변경 (중복 클릭 방지)
        var $btn = $(this);
        $btn.prop('disabled', true).text('생성 중...');

        
        // 3. Ajax 호출
        
        const path = '${path}';
        $.ajax({
            url: path + '/admin/geminiAjax.do',
            type: 'GET',
            data: {
                name: pName,
                feature: pFeature
            },
            success: function(response) {
                // 4. 결과값을 textarea에 넣기
                $('#productDesc').val(response);
            },
            error: function(xhr, status, error) {
                console.error(error);
                alert("AI 설명 생성에 실패했습니다. 다시 시도해주세요.");
            },
            complete: function() {
                // 5. 버튼 복구
                $btn.prop('disabled', false).text('ai 생성');
            }
        });
    });
});	
	
//카테고리쪽

window.onload = function() {
     updateSubCategories();
    
    const savedSubCategory = "${m.subCategory}";
    
    if (savedSubCategory) {
        const subCatSelect = document.getElementById("subCategory");
        subCatSelect.value = savedSubCategory;
    }
}

const subCategories = {
	    "아우터": ["자켓", "코트", "패딩/점퍼", "가디건", "베스트", "레더/무스탕"],
	    "상의": ["티셔츠", "셔츠/블라우스", "니트", "맨투맨/후드", "슬리브리스"],
	    "바지": ["데님", "슬랙스", "코튼 팬츠", "조거/트레이닝", "쇼츠"],
	    "치마": ["미니스커트", "롱스커트", "H라인 스커트", "플리츠/A라인", "데님 스커트"],
	    "원피스": ["미니 원피스", "롱 원피스", "셔츠 원피스", "니트 원피스", "점프슈트"]
	};
function updateSubCategories() {
    const categorySelect = document.getElementById("category");
    const subCategorySelect = document.getElementById("subCategory");

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
     	// 현재 몇 번째 행인지 인덱스 파악
        const index = tbody.querySelectorAll('.option-row').length;
        // 새 행 생성
        
        const newRow = document.createElement("tr");
        newRow.className = "option-row";
        
     // name 속성에 [${index}]를 반드시 포함해야 ProductVO의 List<ProductOptionVO>에 매핑됩니다.
        newRow.innerHTML = `
            <td>
                <select name="productOptionList[\${index}].color" class="form-select">
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
                <select name="productOptionList[\${index}].size" class="form-select">
                    <option value="S">S</option>
                    <option value="M">M</option>
                    <option value="L">L</option>
                </select>
            </td>
            <td>
                <input type="number" name="productOptionList[\${index}].stock" class="form-control" value="0" min="0">
            </td>
            <td><button type="button" class="btn btn-outline-danger btn-sm" onclick="removeRow(this)">삭제</button></td>
        `;
        
        tbody.appendChild(newRow);
    }

    function removeRow(button) {
    	const row = button.closest('tr');
        const tbody = row.parentElement;
        row.remove(); // 행 삭제
        
        reorderIndices(tbody); // 삭제 후 인덱스 재정렬 실행
    }
    
    function removeOldOption(button, optionIdx){
    	const deleteContainer = document.getElementById('delete-container');
   	 	const input = document.createElement('input');
   	 
   	 	input.type = 'hidden';
   	 	input.name = 'deleteOptionIdx';
   	 	input.value = optionIdx;
   	 
   	 	deleteContainer.appendChild(input);
    	
    	const row = button.closest('tr');
    	const tbody = row.parentElement;
    	row.remove();
    	
    	reorderIndices(tbody);
    }

    
 // 2. 인덱스 재정렬 함수
    function reorderIndices(tbody) {
        const rows = tbody.querySelectorAll('.option-row');
        
        rows.forEach((row, index) => {
            // 해당 행 안의 모든 input, select 요소를 찾음
            const elements = row.querySelectorAll('input, select');
            
            elements.forEach(el => {
                const oldName = el.getAttribute('name');
                if (oldName) {
                    // 정규표현식을 사용하여 options[숫자] 부분을 options[현재순서]로 교체
                    // 예: options[3].color -> options[0].color
					const newName = oldName.replace(/\[\d+\]/, '[' + index + ']');
                	el.setAttribute('name', newName);
                    //console.log("적용후 이름: " + newName);
                }
            });
        });
    }
 // 3. 이미지 업로드 핵심 함수 (새로 추가됨 - 버튼 동작의 핵심)
function triggerFileSelect(containerId) {
	 
const container = document.getElementById(containerId);
    
    // 1. 개수 제한 체크
    const currentCount = container.querySelectorAll('.input-group').length;
    let limit = 10; // 기본값 10장
    
    if (containerId === 'mainFileList' || containerId === 'sizeFileList') {
        limit = 1; // 대표이미지와 상품사이즈는 1장으로 제한
    }

    if (currentCount >= limit) {
        alert("해당 항목은 최대 " + limit +"장까지만 등록 가능합니다.");
        return;
    }
	 
    const input = document.createElement('input');
    input.type = 'file';
    input.name = getParamName(containerId);
    input.style.display = 'none';
    input.accept = "image/*"; // 이미지 파일만 선택 가능하게 제한
    
    input.onchange = e => {
        const file = e.target.files[0];
        if (file) {
            const container = document.getElementById(containerId);
            const fileWrapper = document.createElement('div');
            fileWrapper.className = 'input-group mb-2 shadow-sm align-items-center flex-nowrap'; 

            // 1. 기본 구조 생성 (이미지가 들어갈 공간 확보)
            fileWrapper.innerHTML = `
                <span class="input-group-text bg-light p-1">
                    <img class="img-preview" src="" style="width: 40px; height: 40px; object-fit: cover; display: none; border-radius: 4px;">
                    <span class="no-img-icon" style="width: 40px; text-align: center;">🖼️</span>
                </span>
                <input type="text" class="form-control bg-white name-display" style="pointer-events: none; font-size: 0.9rem;" readonly>
                <button type="button" class="btn btn-danger btn-sm px-3" style="height: 48px;" onclick="removeFileItem(this)">삭제</button>
            `;

            // 2. 파일명 주입
            fileWrapper.querySelector('.name-display').value = file.name;

            // 3. FileReader를 이용한 썸네일 생성 로직
            const reader = new FileReader();
            reader.onload = function(event) {
                const imgTag = fileWrapper.querySelector('.img-preview');
                const iconTag = fileWrapper.querySelector('.no-img-icon');
                imgTag.src = event.target.result; // 읽어온 이미지 데이터 주입
                imgTag.style.display = 'block';   // 이미지 보이기
                iconTag.style.display = 'none';    // 아이콘 숨기기
            };
            reader.readAsDataURL(file); // 파일을 읽기 시작

            fileWrapper.appendChild(input); 
            container.appendChild(fileWrapper);
        }
    };
    input.click();
}
 //이미지 제거용
 function OldImgDelete(button, imgIdx, type){
	 const deleteContainer = document.getElementById('delete-container');
	 const input = document.createElement('input');
	 
	 input.type = 'hidden';
	 input.name = (type === 'desc') ? 'deleteDescImgIdx' : 'deleteImgIdx';
	 input.value = imgIdx;
	 
	 deleteContainer.appendChild(input);
	 
	 const item = button.closest('.input-group');
	 item.remove();	 
 }
 
 

// 삭제 버튼 클릭 시 해당 아이템 전체 삭제 함수
function removeFileItem(button) {
    const item = button.closest('.input-group');
    item.remove();
}

//containerId에 따라 서버에서 받을 파라미터 이름을 정해주는 함수 (필수!)
function getParamName(id) {
    const mapping = {
        'mainFileList': 'productMainImgfile',    // 대표이미지
        'detailFileList': 'productImgList',		 // 상세이미지
        'descFileList': 'productDescImgList',     // 설명이미지
        'sizeFileList': 'productSizeImgfile'      // 상품사이즈
    };
    return mapping[id] || 'files';
}

// 옵션 컬러,사이즈 중복검사
function validateOptions() {
    const rows = document.querySelectorAll('.option-row');
    if (rows.length === 0) return true; // 옵션이 없으면 통과

    const checkedOptions = new Set();

    for (let i = 0; i < rows.length; i++) {
        // name 속성이 .color / .size 로 끝나는 엘리먼트를 정확히 타겟팅
        const colorEl = rows[i].querySelector('select[name$=".color"]');
        const sizeEl = rows[i].querySelector('select[name$=".size"]');

        if (!colorEl || !sizeEl) continue;

        const color = colorEl.value;
        const size = sizeEl.value;
        const combination = color + "_" + size;

        if (checkedOptions.has(combination)) {
            alert("중복된 옵션이 있습니다: [" + color + " / " + size + "]\n옵션을 확인해 주세요.");
            rows[i].scrollIntoView({ behavior: 'smooth', block: 'center' }); // 해당 위치로 이동
            rows[i].style.backgroundColor = '#ffecec'; // 강조
            return false; 
        }
        
        checkedOptions.add(combination);
        rows[i].style.backgroundColor = ''; // 중복 아니면 배경색 초기화
    }
    return true; 
}

// 폼 전송 이벤트 연결
function handleFormSubmit(e) {
    // 1. 상품명 체크
    const productName = document.getElementById('productName').value.trim();
    if (productName === "") {
        alert("상품명을 입력해주세요.");
        document.getElementById('productName').focus();
        return false; // 전송 중단
    }

    // 2. 가격 체크 (추가)
    if (document.getElementById('price').value === "" || document.getElementById('price').value < 0) {
        alert("올바른 가격을 입력해주세요.");
        document.getElementById('price').focus();
        return false;
    }
        

    // 3. 옵션 중복 체크
    if (!validateOptions()) {
        return false; // 중복이면 전송 중단
    }

    // 모든 검사 통과 시 true 반환하여 폼 제출 허용
    return true;
}

</script>



</section>
<c:import url="/WEB-INF/view/include/bottom.jsp" />