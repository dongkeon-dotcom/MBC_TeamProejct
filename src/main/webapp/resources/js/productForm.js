// resources/js/productForm.js

// 카테고리별 하위 카테고리 데이터
const subCategories = {
    "아우터": ["자켓", "코트", "패딩/점퍼", "가디건", "베스트", "레더/무스탕"],
    "상의": ["티셔츠", "셔츠/블라우스", "니트", "맨투맨/후드", "슬리브리스"],
    "바지": ["데님", "슬랙스", "코튼 팬츠", "조거/트레이닝", "쇼츠"],
    "치마": ["미니스커트", "롱스커트", "H라인 스커트", "플리츠/A라인", "데님 스커트"],
    "원피스": ["미니 원피스", "롱 원피스", "셔츠 원피스", "니트 원피스", "점프슈트"]
};

// 카테고리 선택 시 하위 카테고리 옵션 변경
function updateSubCategories() {
    const categorySelect = document.getElementById("productCategory");
    const subCategorySelect = document.getElementById("productSubCategory");

    const selectedCategory = categorySelect.value;

    // 기존 옵션 초기화
    subCategorySelect.innerHTML = "<option value=''>-- 하위 카테고리 선택 --</option>";

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
