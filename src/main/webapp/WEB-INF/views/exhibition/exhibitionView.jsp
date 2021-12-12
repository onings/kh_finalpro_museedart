<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="resources/hansolCss/hansol_exhibitionView.css" rel="stylesheet">
<link rel="stylesheet" href="//code.jquery.com/ui/1.13.0/themes/base/jquery-ui.css">
<link rel="stylesheet" href="/resources/jquery-ui/jquery-ui.css">
</head>
<body>
	
	<jsp:include page="/WEB-INF/views/common/header.jsp"/>
	<script type="text/javascript" src="/resources/jquery-ui/jquery-ui.min.js"></script>
	<div class="container">
		<div class="rightSide">
        <div class="topSide">
            <h2>${exb.exhibitionTitle }</h2>
            <div class="star"></div>
        </div>
        <div class="middleSide">
            <div class="exhibitionPhoto">
                <img class="photo" src=${exb.exhibitionPhoto }>
            </div>
            <div class="exhibitionSummary">
                <table class="summaryTable" >
                    <tr>
                        <td>전시 기간</td>
                        <td>${exb.exhibitionStart } ~ ${exb.exhibitionEnd }</td>
                    </tr>
                    <tr>
                        <td>전시 시간</td>
                        <td>${exb.exhibitionTimeStart } ~ ${exb.exhibitionTimeEnd }</td>
                    </tr>
                    <tr>
                        <td>연령</td>
                        <td>${exb.exhibitionAge }</td>
                    </tr>
                    <tr>
                        <td>티켓 가격</td>
                        <td>${exb.exhibitionPrice }</td>
                    </tr>
                    <tr>
                        <td>인원선택</td>
                        <td>
                        <div class="count">
                 	        <button type="button" class="count_btn1">-</button>
								<span class="amount" id="amount">1</span>
							<button type="button" class="count_btn1">+</button>
						</div>
						</td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="bottomSide">
              <ul class="nav nav-tabs">
                <li class="active"><a data-toggle="tab" href="#home">전시정보</a></li>
                <li><a data-toggle="tab" href="#menu1">예매및취소</a></li>
                <li><a data-toggle="tab" href="#menu2">관람평</a></li>
              </ul>
              <div class="tab-content">
              		<div id="home" class="tab-pane fate in active" >
              			<h3>전시 정보</h3>
              			<div class="detail">${exb.exhibitionDetail }</div>
             	 	</div>
              		<div id="menu1" class="tab-pane fate in" style="width:850px">
              			<h3>취소 환불 규정</h3>
		    			<p>Some content in menu 1.</p>
              		</div>
              		<div id="menu2" class="tab-pane fate in" >
              			<h3>관람평이</h3>
		    			<div class="reviewBox hideContent">
                
			        <c:if test="${sessionScope.m != null }">
			        	<div class="inputReviewBox">
							<form action="/insertExReview.do" method="post">
								<input type="hidden" name="reviewWriter" value="${sessionScope.m.memberId }">
								<input type="hidden" name="showNo" value="${snr.s.showNo }">
								<div class="selectStar">
									<p>평점선택</p>
									<select name="star">
										<option value="1">1</option>
										<option value="2">2</option>
										<option value="3">3</option>
										<option value="4">4</option>
										<option value="5">5</option>
									</select>
								</div>
								<textarea name="reviewContent" class="form-control" style="width: 90%;resize: none;"></textarea>
								<button type="submit" class="btn btn-defualt">등록</button>
							</form>
						</div>
			        </c:if>
					
					<div class="reviewList">
						<c:forEach items="${exr.list }" var="exr" varStatus="i">
							<ul class="reviews">
								<li>
									<p>${exr.exReviewWriter }</p>
									<p>${exr.exReviewDate }</p>
								</li>
								<li>
									<p>${exr.exReviewContentBr }</p>
									<textarea name="reviewContent" class="form-control updateContent" style="display: none;">${exr.exReviewContent }</textarea>
									<div class="starBox">
										<c:forEach begin="1" end="${exr.exReviewStar }" >
											<span><img src="resources/showImage/star-on.png" style="height: 10px;"></span>											
										</c:forEach>									
									</div>
									<p class="reviewsBtn">
										<c:if test="${sessionScope.m != null }">
											<c:choose>
												<c:when test="${sessionScope.m.memberId == sr.reviewWriter}">
													<a href="javascript:void(0)" onclick="modifyReview(this,'${exr.exReviewNo }','${exr.exNo }');">수정</a>
													<a href="javascript:void(0)" onclick="deleteReview(this,'${exr.exReviewNo }','${exr.exNo }');">삭제</a>
												</c:when>
												<c:when test="${sessionScope.m.memberLevel == 0 }">
													<a href="javascript:void(0)" onclick="deleteReview(this,'${exr.exReviewNo }','${exr.exNo }');">삭제</a>
												</c:when>
											</c:choose>
										</c:if>
									</p>
								</li>
							</ul>
						</c:forEach>
					</div>
					
                </div>
              		</div>
              </div>
        </div>
    </div>
    <div class="fixed">
    	 <div id="datepicker"></div>
    	 <input type="hidden" id="startDay" value="${exb.exhibitionStart }">
    	 <input type="hidden" id="endDay" value="${exb.exhibitionEnd }">
    	 <input type="hidden" class="price" value="${exb.exhibitionPrice }">
    	 <input type="hidden" id="exhibitionNo" value="${exb.exhibitionNo }">
    	 <input type="hidden" id="exhibitionTitle" value="${exb.exhibitionTitle }">
    	 <input type="hidden" id="exhibitionPhoto" value="${exb.exhibitionPhoto }">
    	 <input type="hidden" id="bookDate" value="">
    	 <span class="totalPrice" id="totalPrice">${exb.exhibitionPrice }</span>원
    	 <button onclick="payment();"class="btn" id="payment" >결제하기</button>
    </div>
   
	</div>
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
 <script>
 		function payment(){
 			var bookDate = $("#bookDate").val();
 			var paymentPrice = Number($("#totalPrice").html()); 
 			var paymentQuantity = Number($("#amount").html()); 
 			var exhibitionNo = Number($("#exhibitionNo").val());
 			var exhibitionTitle = $("#exhibitionTitle").val();
 			var exhibitionPhoto = $("#exhibitionPhoto").val();
 			var paymentSelect = 1; // 전시결제는 1 , 강좌결제는 2
 			console.log(bookDate);
 			var form = $("<form action='/exhibitionPaymentFrm.do' method='post'></form>");
 			form.append($("<input type='text' name='paymentQuantity' value='"+paymentQuantity+"'>"));
 			form.append($("<input type='text' name='paymentPrice' value='"+paymentPrice+"'>"));
 			form.append($("<input type='text' name='exhibitionNo' value='"+exhibitionNo+"'>"));
 			form.append($("<input type='text' name='paymentSelect' value='"+paymentSelect+"'>"));
 			form.append($("<input type='text' name='exhibitionTitle' value='"+exhibitionTitle+"'>"));
 			form.append($("<input type='text' name='exhibitionPhoto' value='"+exhibitionPhoto+"'>"));
 			form.append($("<input type='text' name='bookDate' value='"+bookDate+"'>"));
			$("body").append(form);
			form.submit();
 		}
 
	    $(function() {
	        var start = $("#startDay").val();
	        var end = $("#endDay").val();
	    	
	        var today = new Date();;
	        var endDate = end;
	        $("#datepicker").datepicker({
	            dateFormat: "yy-mm-dd",
	            monthNames : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월','9월', '10월', '11월', '12월' ], 
	            monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월','9월', '10월', '11월', '12월' ],
	            dayNames : [ '일', '월', '화', '수', '목', '금', '토' ],
	            dayNamesShort : [ '일', '월', '화', '수', '목', '금', '토' ],
	            dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],
	            yearSuffix : '년',
 	            minDate: start,
	            maxDate: endDate,
	            onSelect : function(data){
	            	$("#bookDate").val(data);
	            }
	        });
	        $("#bookDate").val($("#datepicker").datepicker("setDate", today).val());
	        $("#datepicker").change(function() {
				selectDate = $(this).val();
				$(".slide").fadeOut();
				$("input[name=date]").val(selectDate);
	        });
	      //월요일 휴무 코드
			 function noMondays(date) {
	    		return [date.getDay() != 1, ''];
	 		}
			

	        
	        //$("#datepicker").datepicker("onselect", today);
	        
			//$(".ui-datepicker-calendar>tbody>tr>td>a").css("background-color", "black").css("color", "#fff");
	        
	    });
	    $(".count>button").click(function(){
			var currAmount = Number($(".amount").html()); 
			if($(this).html() == "+") { 
				$(".amount").html(++currAmount);
			}else{
				if(currAmount != 1){ 
					$(".amount").html(--currAmount);					
				}
			}
			var price = Number($(".price").val()); 
			$(".totalPrice").html(currAmount*price);
			$("#amount").val(currAmount);
			
		});
	    function modifyReview(obj,exReviewNo,exNo) {
			//textarea를 화면에 표현
			$(obj).parents("li").children().filter(".updateContent").show();
			//기존 본문 내용을 숨김
			$(obj).parents("li").children().first().hide();
			$(obj).parents("li").children().filter(".starBox").hide();
			//수정 -> 수정완료
			$(obj).html('수정완료');
			$(obj).attr("onclick", "modifyComplete(this, '"+exReviewNo+"', '"+exNo+"')");
			//삭제 -> 취소
			$(obj).next().html('취소');
			$(obj).next().attr("onclick", "modifyCancel(this, '"+exReviewNo+"', '"+exNo+"');");
			//답글달기 버튼 숨기기
			$(obj).next().next().hide();
		}
		function modifyCancel(obj,exReviewNo,exNo) {
			//textarea 숨김
			$(obj).parents("li").children().first().show();
			$(obj).parents("li").children().filter(".starBox").show();
			//기존 본문내용을 화면에 다시 표현
			$(obj).parents("li").children().filter(".updateContent").hide();
			//수정완료 -> 수정
			$(obj).prev().html('수정');
			$(obj).prev().attr("onclick", "modifyReview(this, '"+exReviewNo+"', '"+exNo+"');");
			//취소 -> 삭제
			$(obj).html('삭제');
			$(obj).attr("onclick", "deleteReview(this, '"+exReviewNo+"', '"+exNo+"');");
			//답글달기 버튼 보이기
			$(obj).next().show();
		}
		function modifyComplete(obj,exReviewNo,exNo){
			var form = $("<form action='/updateExReview.do' method='post'></form>");
			//form안에 수정 번호 설정
			form.append($("<input type='text' name='reviewNo' value='"+exReviewNo+"'>"));
			//form에 공연 번호 설정
			form.append($("<input type='text' name='showNo' value='"+exNo+"'>"));
			//수정한 내용을 설정
			form.append($(obj).parents("li").children().filter(".updateContent"));
			//전송할 form태그를 현재 페이지에 추가
			$("body").append(form);
			//form태그 전송
			form.submit();
			
		}
		function deleteReview(obj,exReviewNo,showNo){
			var exReviewStatus = 1;
			if(confirm("관람평을 삭제하시겠습니까?")){
				location.href="/deleteExReview.do?reviewNo="+exReviewNo+"&showNo="+exNo;
			}
		}
    </script>
</html>