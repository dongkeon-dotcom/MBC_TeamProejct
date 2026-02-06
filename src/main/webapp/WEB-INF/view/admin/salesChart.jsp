<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<c:import url="/WEB-INF/view/include/top.jsp" />
<link href="${path}/resources/css/admin/salesChart.css"
	rel="stylesheet">
<section>

<div class="nav-container">
        <div class="nav-btn" onclick="showChart('monthly')"><span>□</span> 월별 매출 통계</div>
        <div class="nav-btn" onclick="showChart('category')"><span>□</span> 상위 카테고리별 매출 통계</div>
    </div>

<div class="chart-wrapper">
    <div id="monthlySection">
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <h2>월별 매출 통계</h2>
            <div>
                <select id="yearSelect" onchange="updateSearch()">
                    <option value="2025" ${selectedYear == '2025' ? 'selected' : ''}>2025년</option>
                    <option value="2026" ${selectedYear == '2026' ? 'selected' : ''}>2026년</option>
                </select>
            </div>
        </div>
        <canvas id="monthlyChart"></canvas>
    </div>

    <div id="categorySection">
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <h2>상위 카테고리별 매출 통계</h2>
            <div id="dateFilters">
                <select id="catYearSelect" onchange="updateSearch()">
                    <option value="2025" ${selectedYear == '2025' ? 'selected' : ''}>2025년</option>
                    <option value="2026" ${selectedYear == '2026' ? 'selected' : ''}>2026년</option>
                </select>
                <select id="catMonthSelect" onchange="updateSearch()">
                    <c:forEach var="m" begin="1" end="12">
                        <option value="${m < 10 ? '0' : ''}${m}" ${selectedMonth == (m < 10 ? '0' + m : m) ? 'selected' : ''}>${m}월</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <canvas id="categoryChart"></canvas>
    </div>
</div>

<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
<script>
// 차트 인스턴스 전역 변수
let monthlyChart = null;
let categoryChart = null;

$(document).ready(function() {
    // 초기 화면 설정 (월별 통계 보이게)
    showChart('monthly');
});

// 탭 전환 함수 (추가됨)
function showChart(type) {
    if(type === 'monthly') {
        $("#monthlySection").show();
        $("#categorySection").hide();
    } else {
        $("#monthlySection").hide();
        $("#categorySection").show();
    }
    // 탭을 바꿀 때마다 최신 데이터로 업데이트하고 싶다면 아래 주석 해제
    // updateSearch(); 
}

function updateSearch() {
    const year = $("#yearSelect").val();
    const catYear = $("#catYearSelect").val();
    const catMonth = $("#catMonthSelect").val();

    const isMonthly = $("#monthlySection").is(":visible");
    const targetYear = isMonthly ? year : catYear;

    const path = '${path}';
    
    $.ajax({
        url: path + "/admin/salesChartAjax.do",
        type: "GET",
        data: {
            year: targetYear,
            month: catMonth
        },
        dataType: "json",
        success: function(data) {
            if(data.monthlyData && data.categoryData) {
                drawMonthlyChart(data.monthlyData, targetYear);
                drawCategoryChart(data.categoryData);
            } else {
                console.error("Data structure error:", data);
                alert('데이터를 불러오는 데 실패했습니다.');
            }
        },
        error: function(xhr, status, error) {
            console.error("AJAX Error:", error);
            alert("통계 데이터를 불러오지 못했습니다.");
        }
    });
}

// 월별 차트 그리기 함수
function drawMonthlyChart(dataList, selectedYear) {
    const ctx = document.getElementById('monthlyChart').getContext('2d');
    
    // 데이터 가공 (Key 대소문자 주의: MyBatis Map 리턴 시 보통 대문자)
    const labels = dataList.map(item => (item.salesMonth || item.MONTH) + '월');
    const values = dataList.map(item => (item.totalSum || item.TOTAL_SUM));

    // 기존 차트가 있으면 삭제 (그래야 마우스 오버 시 버그가 없음)
    if (monthlyChart) {
        monthlyChart.destroy();
    }

    monthlyChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: selectedYear + '년 월별 매출',
                data: values,
                backgroundColor: '#3e95cd'
            }]
        },
        options: {
            responsive: true,
            scales: { y: { beginAtZero: true } }
        }
    });
}

// 카테고리 차트 그리기 함수
function drawCategoryChart(dataList) {
    const ctx = document.getElementById('categoryChart').getContext('2d');
    
    const labels = dataList.map(item => (item.CATEGORY || item.category));
    const values = dataList.map(item => (item.TOTAL_SUM || item.totalSum));

    if (categoryChart) {
        categoryChart.destroy();
    }

    categoryChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: labels,
            datasets: [{
                data: values,
                backgroundColor: ['#3e95cd', '#8e5ea2', '#3cba9f', '#e8c3b9', '#c45850']
            }]
        },
        options: { responsive: true }
    });
}
</script>
</section>
<c:import url="/WEB-INF/view/include/bottom.jsp" />