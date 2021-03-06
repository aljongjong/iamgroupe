<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>전자결재 > 참조문서조회 (리스트)</title>
  <!-- Favicon -->
  <link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/img/svg/looo.png" type="image/x-icon">
  <!-- Custom styles -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.min.css">

  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/ea/user/ea_reflist.css">

  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>

<body>
  <%@ include file="/WEB-INF/views/common/headerSide.jsp" %>

  <div class="ea_wrapper">
    <div class="ea_reflist_wrapper">
      <div class="ea_reflist_title">
        <span>참조문서조회 (리스트)</span>
      </div>
      <div class="ea_reflist_list_contents">
        <!-- 제목 누르면 그냥 문서번호만 보내서 처리 -->
        <table>
          <thead>
            <tr>
              <th>문서 번호</th>
              <th>
                <span>양식 ▾</span>
                <ul>
                  <% int i = 1; %>
                  <c:forEach items="${formList}" var="fl">
                    <li>
                      <form action="${root}/ea/reflistByFilter" method="POST" name="reflistByFilterF<%=i%>">
                        <a href="javascript:reflistByFilterF<%=i%>.submit()">${fl.formTitle}</a>
                        <input type="hidden" name="formNo" value="${fl.formNo}">
                      </form>
                    </li>
                    <% i++; %>
                  </c:forEach>
                </ul>
              </th>
              <th>문서 제목</th>
              <th>
                <span>상신 날짜 ▾</span>
                <ul>
                  <li>
                    <form action="${root}/ea/reflistByFilter" method="POST" name="reflistByFilterM1">
                      <a href="javascript:reflistByFilterM1.submit()">빠른순</a>
                      <input type="hidden" name="make" value="old">
                    </form>
                  </li>
                  <li>
                    <form action="${root}/ea/reflistByFilter" method="POST" name="reflistByFilterM2">
                      <a href="javascript:reflistByFilterM2.submit()">늦은순</a>
                      <input type="hidden" name="make" value="new">
                    </form>
                  </li>
                </ul>
              </th>
              <th>
                <span>마감 날짜 ▾</span>
                <ul>
                  <li>
                    <form action="${root}/ea/reflistByFilter" method="POST" name="reflistByFilterC1">
                      <a href="javascript:reflistByFilterC1.submit()">빠른순</a>
                      <input type="hidden" name="close" value="old">
                    </form>
                  </li>
                  <li>
                    <form action="${root}/ea/reflistByFilter" method="POST" name="reflistByFilterC2">
                      <a href="javascript:reflistByFilterC2.submit()">늦은순</a>
                      <input type="hidden" name="close" value="new">
                    </form>
                  </li>
                </ul>
              </th>
              <th>
                <span>진행 단계 ▾</span>
                <ul>
                  <li>
                    <form action="${root}/ea/reflistByFilter" method="POST" name="reflistByFilterP1">
                      <a href="javascript:reflistByFilterP1.submit()">결재대기</a>
                      <input type="hidden" name="procSeq" value="1">
                    </form>
                  </li>
                  <li>
                    <form action="${root}/ea/reflistByFilter" method="POST" name="reflistByFilterP2">
                      <a href="javascript:reflistByFilterP2.submit()">반려</a>
                      <input type="hidden" name="procSeq" value="2">
                    </form>
                  </li>
                  <li>
                    <form action="${root}/ea/reflistByFilter" method="POST" name="reflistByFilterP3">
                      <a href="javascript:reflistByFilterP3.submit()">협의요청</a>
                      <input type="hidden" name="procSeq" value="3">
                    </form>
                  </li>
                </ul>
              </th>
            </tr>
          </thead>
          <tbody>
            <!-- for-each -->
            <form action="${root}/ea/reflist/detail" method="POST" name="requestForm">
              <c:forEach items="${refList}" var="rl">
                <tr id="listContents">
                  <td>${rl.docNo}</td>
                  <td>${rl.formTitle}</td>
                  <td><a href="javascript:requestForm.submit()" class="ea_title">${rl.docTitle}</a></td>
                  <td>${rl.simpleMakeDate}</td>
                  <td>${rl.simpleCloseDate}</td>
                  
                  <c:forEach items="${processList}" var="pl" varStatus="vs">
                    <c:if test="${rl.docNo eq pl.docNo}">
                      <c:if test="${pl.procSeq eq 2}">
                      <td>반려</td>
                      </c:if>
                      <c:if test="${pl.procSeq eq 3}">
                      <td>협의요청</td>
                      </c:if>
                    </c:if>
                  </c:forEach>

                  <c:forEach items="${processList}" var="pl" varStatus="vs">
                    <c:if test="${rl.docNo eq pl.docNo}">
                      <!-- 그냥... 오버플로우 히든으로 가리자... -->
                      <c:if test="${pl.procSeq ne 2 || pl.procSeq ne 3}">
                        <td>결재대기</td>
                      </c:if>
                    </c:if>
                  </c:forEach>


                </tr>
              </c:forEach>
            </form>
          </tbody>
          </table>
        
        
        
        <div id="pagingBtn">
          <!-- 페이지 start -->
          <c:if test="${page ne null}">
          <ul>
            <c:if test="${page.startPage != 1}">
              <li><a href="${page.startPage - 1}">◁</a></li>
            </c:if>
            
            <c:forEach var="i" begin="${page.startPage}" end="${page.endPage}">
              <c:if test="${page.currentPage != i and i <= page.lastPage}">
                <li><a href="${root}/ea/reflist/${i}">${i}</a></li>
              </c:if>
              <c:if test="${page.currentPage == i and i <= page.lastPage}">
                <li style="background: #4081e4; color: #fff;">${i}</li>
              </c:if>
            </c:forEach>
            
            <c:if test="${page.endPage < page.lastPage}">
              <li><a href="${page.endPage + 1}">▷</a></li>
            </c:if>
          </ul>
          </c:if>
          <!-- 페이지 end -->
        </div>
          
        </div>
      </div>
    </div>
    
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
    <!-- Icons library -->
    <script src="${pageContext.request.contextPath}/resources/plugins/feather.min.js"></script>
    
    <!-- Custom scripts -->
    <script src="${pageContext.request.contextPath}/resources/js/script.js"></script>

<script>
  $('.ea_reflist_list_contents > table > thead > tr > th > span').click(function() {
    $(this).siblings("ul").toggleClass('active');
  });

  // 상세페이지 이동시 문서번호, 결재절차 데이터 추가
  $('.ea_title').click(function() {
    let process = $(this).parent().siblings().eq(4).text();
    console.log(process);
    let docNo = $(this).parent().parent().children().eq(0).text();
    console.log(docNo);
    $('<input>', {
      type : "hidden",
      name: "process",
      value : process
    }).appendTo('form[name="requestForm"]');
    $('<input>', {
      type : "hidden",
      name: "docNo",
      value : docNo
    }).appendTo('form[name="requestForm"]');
  });


</script>
</body>
</html> 