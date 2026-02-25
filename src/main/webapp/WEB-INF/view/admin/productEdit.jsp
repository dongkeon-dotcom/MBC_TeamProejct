<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:import url="/WEB-INF/view/include/top.jsp" />
<link href="${path}/resources/css/admin/productAdd.css"
	rel="stylesheet">

<section>

	<div class="container my-5" style="max-width: 800px;">
		<h2 class="text-center mb-5 fw-bold">상품 정보 수정 페이지</h2>

		<form action="${path}/admin/adminProductEditOK.do" method="post"
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
					<div class="row">
					<div class="col-6 mb-4">
						<label class="main-label">추천</label>
						<input type="hidden" name="recommended" id="recommendedInput" value = "${m.recommended }">
						<c:choose>
							<c:when test="${!m.recommended}">
								<button type="button" class="btn btn-sm btn-outline-primary recommend-btn"
										data-status=false>해제</button>
							</c:when>
							<c:otherwise>
								<button type="button" class="btn btn-sm btn-success recommend-btn"
										data-status=true>추천</button>
							</c:otherwise>
						</c:choose>
					</div>
					<div class="col-6 mb-4">
						<label class="main-label">할인</label>
						<div class="input-group">
						<input type="number" class="form-control"
						name="discountRate" id="discountRate" placeholder="할인률" value="${m.discountRate }"
						placeholder="0" min="0" max="100">
						<span class="input-group-text">%</span>
						</div>
					</div>
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

			<div class="submit-btn-wrapper d-flex justify-content-center gap-3 mx-auto" style="max-width: 600px;">
			    <button type="submit"
			        class="btn btn-primary btn-lg py-3 fw-bold flex-fill">
			        상품 수정하기
			    </button>
			    
			    <button type="button" 
			        class="btn btn-outline-danger btn-lg py-3 fw-bold flex-fill" 
			        onclick="deleteProduct('${m.productIdx}')">
			        상품 삭제하기
			    </button>
			</div>
		</form>
	</div>

<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
<script>
$(document).ready(function(){
	$('.recommend-btn').on('click', function(){
		const btn = $(this);
		const currentStatus = btn.data('status');
		const nextStatus = !currentStatus;
		
		$('#recommendedInput').val(nextStatus);
		
		if(nextStatus === true){
			btn.text('추천').removeClass('btn-outline-primary').addClass('btn-success').data('status', true);
		} else{
			btn.text('해제').removeClass('btn-success').addClass('btn-outline-primary').data('status', false);
		}
		
	});	
});
$(document).ready(function() {
    $('.ai-gen-btn').on('click', function() {
        // 필요한 입력값 가져오기
        var pName = $('#productName').val(); // 상품명 입력란 id
        var pFeature = $('#subCategory').val(); // 특징 입력란 id
        
        // 대표이미지 가져오기
        var fileInput = $('#mainFileList').find('input[type="file"]')[0];
        var file = fileInput ? fileInput.files[0] : null;

        // 입력값 검사
        if(!pName) {
            alert("상품명이 필요합니다.");
            return;
        }
        if(pFeature === '-- 하위 카테고리 선택 --'){
        	alert("하위카테고리가 필요합니다.");
        	return;
        }
        if(!file){
        	alert("대표이미지가 필요합니다.");
        	return
        }
        
        var formData = new FormData();
        formData.append("name", pName);
        formData.append("feature", pFeature);
        if(file){
        	formData.append("image",file);
        }

        // 버튼 상태 변경 (중복 클릭 방지)
        var $btn = $(this);
        $btn.prop('disabled', true).text('생성 중...');

        
        // Ajax 호출
        const path = '${path}';
        $.ajax({
            url: path + '/admin/geminiAjax.do',
            type: 'POST',
            data: formData,
            processData: false,		//데이터를 쿼리 문자열로 변환하지 않음
            contentType: false,		// 가상의 form-data 헤더 자동 생성
            success: function(response) {
                // 결과값을 textarea에 넣기
                $('#productDesc').val(response);
            },
            error: function(xhr, status, error) {
                console.error(error);
                alert("AI 설명 생성에 실패했습니다. 다시 시도해주세요.");
            },
            complete: function() {
                // 버튼 복구
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
 
    // 이미지 압축 함수 (Promise 반환)
    function compressImage(file) {
        return new Promise((resolve) => {
            const reader = new FileReader();
            reader.readAsDataURL(file);
            reader.onload = (event) => {
                const img = new Image();
                img.src = event.target.result;
                img.onload = () => {
                    const canvas = document.createElement('canvas');
                    let width = img.width;
                    let height = img.height;

                    // 1. 최대 해상도 설정 (예: 가로 1200px 기준 비율 유지)
                    const maxWidth = 1200;
                    if (width > maxWidth) {
                        height = (maxWidth * height) / width;
                        width = maxWidth;
                    }

                    canvas.width = width;
                    canvas.height = height;

                    const ctx = canvas.getContext('2d');
                    ctx.drawImage(img, 0, 0, width, height);

                    // 2. 품질 설정 (0.7은 70% 품질, JPEG 형식으로 압축)
                    const dataUrl = canvas.toDataURL('image/jpeg', 0.7);
                    
                    // DataURL을 File 객체로 변환
                    const byteString = atob(dataUrl.split(',')[1]);
                    const mimeString = dataUrl.split(',')[0].split(':')[1].split(';')[0];
                    const ab = new ArrayBuffer(byteString.length);
                    const ia = new Uint8Array(ab);
                    for (let i = 0; i < byteString.length; i++) {
                        ia[i] = byteString.charCodeAt(i);
                    }
                    const blob = new Blob([ab], { type: mimeString });
                    const compressedFile = new File([blob], file.name, { type: mimeString });
                    
                    resolve(compressedFile);
                };
            };
        });
    }
 // 3. 이미지 업로드 핵심 함수 (새로 추가됨 - 버튼 동작의 핵심)
function triggerFileSelect(containerId) {
    const container = document.getElementById(containerId);
    
    // 1. 개수 제한 체크
    const currentCount = container.querySelectorAll('.input-group').length;
    let limit = 5; 
    
    if (containerId === 'mainFileList' || containerId === 'sizeFileList') {
        limit = 1; 
    }

    if (currentCount >= limit) {
        alert("해당 항목은 최대 " + limit +"장까지만 등록 가능합니다.");
        return;
    }

    // [중요] input 생성 루틴
    const input = document.createElement('input');
    input.type = 'file';
    input.name = getParamName(containerId);
    input.style.display = 'none';
    input.accept = "image/*";
    
    // 다중 선택 설정
    if (limit > 1) {
        input.multiple = true;
    }

    input.onchange = async e => {
        const files = e.target.files;
        if (!files || files.length === 0) return; // 선택 취소 시 대응

        for (let file of files) {
        	
        	//압축 compressImage 실행
        	const compressedFile = await compressImage(file);
        	
            const nowCount = container.querySelectorAll('.input-group').length;
            if (nowCount >= limit) {
                alert("해당 항목은 최대 " + limit + "장까지만 등록 가능합니다.");
                break;
            }

            const dataTransfer = new DataTransfer();
            dataTransfer.items.add(compressedFile);
            
            const newFileInput = document.createElement('input');
            newFileInput.type = 'file';
            newFileInput.name = getParamName(containerId);
            newFileInput.style.display = 'none';
            newFileInput.files = dataTransfer.files;

            const fileWrapper = document.createElement('div');
            fileWrapper.className = 'input-group mb-2 shadow-sm align-items-center flex-nowrap'; 

            fileWrapper.innerHTML = `
                <span class="input-group-text bg-light p-1">
                    <img class="img-preview" src="" style="width: 40px; height: 40px; object-fit: cover; display: none; border-radius: 4px;">
                    <span class="no-img-icon" style="width: 40px; text-align: center;">🖼️</span>
                </span>
                <input type="text" class="form-control bg-white name-display" style="pointer-events: none; font-size: 0.9rem;" readonly>
                <button type="button" class="btn btn-danger btn-sm px-3" style="height: 48px;" onclick="removeFileItem(this)">삭제</button>
            `;

            fileWrapper.querySelector('.name-display').value = compressedFile.name;

            const reader = new FileReader();
            reader.onload = function(event) {
                const imgTag = fileWrapper.querySelector('.img-preview');
                const iconTag = fileWrapper.querySelector('.no-img-icon');
                imgTag.src = event.target.result;
                imgTag.style.display = 'block';
                iconTag.style.display = 'none';
            };
            reader.readAsDataURL(compressedFile);

            fileWrapper.appendChild(newFileInput); 
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
	
	const maxSize = 20 * 1024 * 1024;
	let totalSize = 0 ;
	
	const allFileInputs = document.querySelectorAll('input[type="file"]');
	
	allFileInputs.forEach(input =>{
		if(input.files && input.files.length >0){
			for (let i=0;i<input.files.length; i++){
				totalSize += input.files[i].size;
			}
		}
	});
	
	if(totalSize > maxSize){
		alert("등록하려는 모든 이미지의 총 용량이 너무 큽니다.\n"+
				"최대 용량: " + (maxSize /1024/1024).toFixed(0) + "MB\n"+
				"현재 용량: " + (totalSize /1024/1024).toFixed(2) + "MB");
		return false;		
	}
	
	// 카테고리 체크
	const category = document.getElementById('category').value.trim();
	if(category === "-- 카테고리 선택 --"){
		alert("카테고리를 선택해주세요");
        document.getElementById('category').focus();
        return false; // 전송 중단
	}
		
	// 하위 카테고리 체크
	const subCategory = document.getElementById('subCategory').value.trim();
	if(subCategory === "-- 하위 카테고리 선택 --"){
		alert("하위 카테고리를 선택해주세요");
        document.getElementById('subCategory').focus();
        return false; // 전송 중단
	}
	
	
    // 상품명 체크
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
    
    // 대표이미지 검사
    const mainImgContainer = document.getElementById('mainFileList');
    const hasMainImg = mainImgContainer.querySelectorAll('.input-group').length > 0;

    if(!hasMainImg){
    	alert("대표이미지를 등록해 주세요.");
    	return false;
    }
    
    // 상세이미지 검사
    const detailImgContainer = document.getElementById('detailFileList');
    const hasDetailImg = detailImgContainer.querySelectorAll('.input-group').length > 0;

    if(!hasDetailImg){
    	alert("상세이미지를 최소 1장 등록해 주세요.");
    	return false;
    }
    
    // 설명이미지 검사
    const descImgContainer = document.getElementById('descFileList');
    const hasDescImg = descImgContainer.querySelectorAll('.input-group').length > 0;
    
    if(!hasDescImg){
    	alert("설명이미지를 최소 1장 등록해 주세요.");
    	return false;
    }
    
    // 사이즈이미지 검사
    const sizeImgContainer = document.getElementById('sizeFileList');
    const hasSizeImg = sizeImgContainer.querySelectorAll('.input-group').length > 0;
   
    if(!hasSizeImg){
    	alert("사이즈이미지를 등록해 주세요.");
    	return false;
    }
    
    // 상품 설명 검사
    const productDesc = document.getElementById('productDesc').value.trim();
    if (productDesc === "") {
        alert("상품설명을 입력해주세요.");
        return false; // 전송 중단
    }
    
    

    // 모든 검사 통과 시 true 반환하여 폼 제출 허용
    return true;
}


//상품 삭제 함수
function deleteProduct(productIdx) {
    if (confirm("정말로 이 상품을 삭제하시겠습니까?")) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${path}/admin/adminProductDeleteOK.do';

        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'productIdx';
        input.value = productIdx;

        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
    }
}

</script>



</section>
<c:import url="/WEB-INF/view/include/bottom.jsp" />