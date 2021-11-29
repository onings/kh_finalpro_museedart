<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
    <link href="resources/spaceCss/space_default.css" rel="stylesheet">
    <link href="resources/spaceCss/space_main.css" rel="stylesheet">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp"/>
	<div class="container">
		<h1>대관 안내</h1>
		<div class="space-img">
			<img src="resources/spaceImage/연습실1.png">
			<p>
				무지다 문화센터에는 연습실, 다목적실, 강의실, 세미나실 총 4개의 공간이 있습니다.<br>
				비영리 모임, 생활문화동아리와 문화인, 그리고 지역의 예술가들을 위해 제공합니다.<br>
				공간 특성에 따라 사용할 수 있는 용도가 다르며, 실별 용도와 보유물품 리스트는 아래 상세내용에서 확인하실 수 있습니다.<br>
				쾌적한 공간 사용을 위해, 실별 적정인원 확인을 추천드리고, 사용 후에는 사용 후 게시판에 게시물을 작성하여야 합니다. <br>
			</p>
		</div>
		<div class="rental-sequence">
			<h3 class="s-title">대관 절차</h3>
			<img src="resources/spaceImage/대관절차.png">
		</div>
		<div class="rental-price">
			<h3 class="s-title">대관료 안내</h3>
		</div>
		<button class="btn btn-default" id="rentalBtn" onclick="location.href='/rentalSpace.do'">대관 신청하기</button>
	</div>
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>