# 👾 전자결재 관리자 주요 로직 
(다수의 로직이 컨트롤러보다 JS, ajax 비동기 처리 비중이 많아 하단 코드 script문으로 대체)

## <문서 보안/번호 포맷 관리>
```javascript
<script>
// 문서 번호 포맷 디폴트값 들어가게
        let today = new Date();
        let year = (today.getYear()-100).toString();
        let year1 = today.getFullYear().toString();
        let month = (today.getMonth() + 1) > 9 ? (today.getMonth() + 1).toString() : "0" + (today.getMonth() + 1).toString();
        let month1 = (today.getMonth() + 1).toString();
        let date = (today.getDate() > 9) ? today.getDate().toString() : "0" + today.getDate().toString();
        let date1 = today.getDate().toString();
        const todayFormat1 = year + month + date;
        const todayFormat2 = year + month1 + date1;
        const todayFormat3 = year1 + month + date;
        const todayFormat4 = year1 + month1 + date1;
        $("#formatY > option[value=<c:out value='${defaultSettings.formatYear}'/>]").attr('selected', 'selected');
        $("#formatD > option[value=<c:out value='${defaultSettings.formatDept}'/>]").attr('selected', 'selected');
        $("#formatF > option[value=<c:out value='${defaultSettings.formatForm}'/>]").attr('selected', 'selected');
        if("<c:out value='${defaultSettings.formatYear}'/>" == 'YYMMDD') {
          $('#valueY').html(todayFormat1);
          $('#wrapA > span:nth-child(1)').html(todayFormat1 + "-");
        } else if("<c:out value='${defaultSettings.formatYear}'/>" == 'YYMD') {
          $('#valueY').html(todayFormat2);
          $('#wrapA > span:nth-child(1)').html(todayFormat2 + "-");
        } else if("<c:out value='${defaultSettings.formatYear}'/>" == 'YYYYMMDD') {
          $('#valueY').html(todayFormat3);
          $('#wrapA > span:nth-child(1)').html(todayFormat3 + "-");
        } else if("<c:out value='${defaultSettings.formatYear}'/>" == 'YYYYMD') {
          $('#valueY').html(todayFormat4);
          $('#wrapA > span:nth-child(1)').html(todayFormat4 + "-");
        }
        if("<c:out value='${defaultSettings.formatDept}'/>" == '부서번호') {
          $('#valueD').html('01');
          $('#wrapA > span:nth-child(2)').html("01-");
        } else if("<c:out value='${defaultSettings.formatDept}'/>" == '부서이름') {
          $('#valueD').html('인사');
          $('#wrapA > span:nth-child(2)').html("인사-");
        } 
        if("<c:out value='${defaultSettings.formatForm}'/>" == '양식번호') {
          $('#valueF').html('0001');
          $('#wrapA > span:nth-child(3)').html("0001-1");
        } else if("<c:out value='${defaultSettings.formatForm}'/>" == '양식이름') {
          $('#valueF').html('비품구매서');
          $('#wrapA > span:nth-child(3)').html("비품구매서-1");
        } 
        
        // 문서 번호 포맷
        function changeFormatY() {
          
          let y = $('#formatY').val();
          if(y == 'YYMMDD') {
            $('#valueY').html(todayFormat1);
            $('#wrapA > span:nth-child(1)').html(todayFormat1 + "-");
          } else if(y == 'YYMD') {
            $('#valueY').html(todayFormat2);
            $('#wrapA > span:nth-child(1)').html(todayFormat2 + "-");
          } else if(y == 'YYYYMMDD') {
            $('#valueY').html(todayFormat3);
            $('#wrapA > span:nth-child(1)').html(todayFormat3 + "-");
          } else if(y == 'YYYYMD') {
            $('#valueY').html(todayFormat4);
            $('#wrapA > span:nth-child(1)').html(todayFormat4 + "-");
          }
        };
        function changeFormatD() {
          let d = $('#formatD').val();
          if(d == '부서번호') {
            $('#valueD').html("01");
            $('#wrapA > span:nth-child(2)').html("01-");
          } else if(d == '부서이름') {
            $('#valueD').html("인사");
            $('#wrapA > span:nth-child(2)').html("인사-");
          }
        };
        function changeFormatF() {
          let d = $('#formatF').val();
          if(d == '양식번호') {
            $('#valueF').html("0001");
            $('#wrapA > span:nth-child(3)').html("0001-1");
          } else if(d == '양식이름') {
            $('#valueF').html("비품구매서");
            $('#wrapA > span:nth-child(3)').html("비품구매서-1");
          }
        };
</script>
```

## <문서 양식 관리>
```javascript
 <script>
 // - , + 버튼으로 카테고리, 양식 추가/삭제
	function categoryPlus() {
	  $.ajax({
	    url : "${root}/admin/ea/insertCategory",
	    method : "GET",
	    success : function(result) {
	      $("<option>", {
		  value : result,
		  onclick : "seletedCategory(this);",
		  ondblclick : "updateCategoryName();"
	      }).text('새로운 카테고리')
	      .appendTo("select[name=categoryNo]");
	    },
	    error : function(e) {
	      console.log(e);
	    }
	  });
	};
	function categoryMinus() {
	  if(confirm('선택하신 카테고리를 삭제하시겠습니까?\n(⚡︎삭제시 하위 문서양식까지 모두 삭제됩니다⚡︎)')) {
	    $.ajax({
	      url : "${root}/admin/ea/deleteCategory",
	      method : "GET",
	      data : {
		categoryNo : $('select[name="categoryNo"] > option[selected="selected"]').val()
	      },
	      success : function(result) {
		$('select[name="categoryNo"] > option[selected="selected"]').remove();
	      },
	      error : function(e) {
		console.log(e);
	      }
	    });
	  } else {
	    return false;
	  }
	};
	function formPlus() {
	  $.ajax({
	    url : "${root}/admin/ea/insertForm",
	    method : "GET",
	    data : {
	      categoryNo : $('select[name="categoryNo"] > option[selected="selected"]').val()
	    },
	    success : function(result) {
	      $("<option>", {
		  value : result,
		  class : $('select[name="categoryNo"] > option[selected="selected"]').val(),
		  onclick : "selectedForm(this);",
		  ondblclick : "updateFormName();"
	      }).addClass('activeForm')
	      .text('새로운 양식')
	      .appendTo("select[name=formNo]");
	      $("<div>", {
		  id : result
	      }).html('<h1 style="text-align:center">새로운 양식</h1>').appendTo("#formContents");
	    },
	    error : function(e) {
	      console.log(e);
	    }
	  });
	};
	function formMinus() {
	  if(confirm('선택하신 양식을 삭제하시겠습니까?')) {
	    $.ajax({
	      url : "${root}/admin/ea/deleteForm",
	      method : "GET",
	      data : {
		formNo : $('select[name="formNo"] > option[selected="selected"]').val()
	      },
	      success : function(result) {
		$('select[name="formNo"] > option[selected="selected"]').remove();
	      },
	      error : function(e) {
		console.log(e);
	      }
	    });
	  } else {
	    return false;
	  }
	};
 </script>
```

## <승인/만료 문서 관리>
```javascript
<script>
// 문서관리 체크 버튼
        // 상단 체크박스 클릭하면, 전체 체크박스 클릭되도록
        let topCheckBox = document.querySelector('thead input[type="checkbox"]');
        let delArr = document.getElementsByClassName('checkbox-del');
        
        topCheckBox.onchange = function(e) {
          if(this.checked) {
            // 상단 체크박스가 체크면 전부 다 체크
            // 모든 체크박스 다 가져오기, 그다음에 모든 체크박스 checkd값을 true로 바꿔주기
            // delArr 안의 요소 하나씩 꺼내와서 checked값을 true로 바꿔주기
            for(let i = 0; i < delArr.length; ++i) {
              delArr[i].checked = true;
            }
          } else {
            // 아니면 체크 해제
            for(let i = 0; i < delArr.length; ++i) {
              delArr[i].checked = false;
            }
          }
        };
        // 삭제하기 버튼 눌렀을 때
        function del() {
          if(confirm('선택하신 문서를 삭제하시겠습니까?')) {
            // 삭제할 번호 가져오기
            // 가져온 번호들을 하나의 문자열로 합치기
            let result = "";
            let delArr = document.getElementsByClassName('checkbox-del');
            
            for(let i = 0; i < delArr.length; ++i) {
              let t = delArr[i];
              if(t.checked) {
                result += t.value + ',';
              }
            }
            // 삭제 요청 보내기 (삭제할 번호 전달해주면서)
            $.ajax({
              url : "${root}/admin/ea/delete",
              data : {"str" : result},
              type : "post",
              success : function(data) {
                for(let i = 0; i < delArr.length; ++i) {
                  let t = delArr[i];
                  if(t.checked) {
                    t.parentElement.parentElement.remove();
                  }
                }
                alert('선택하신 문서가 삭제되었습니다!');
              },
              error : function(e) {
                alert(e);
              }
            });
            return true;
          } else {
            return false;
          }
          // 새로고침
          // window.location.reload();
        }
</script>
```
