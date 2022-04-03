# 👾 전자결재 관리자 주요 로직 (다수 ajax 비동기 처리로 하단 코드 JS로 대체)

## <문서 보안/번호 포맷 관리>
```javascript
// 기안신청 (처리)
@PostMapping(value = "/write")
public String write(Model model, HttpSession session, @ModelAttribute SignupDto dto, String leavePeriod) throws Exception {

	// 결재선 번호 테이블 인서트(문서번호, 결재선번호)
	int result1 = service.insertProcessNo(session, dto);
	// 결재선 번호 테이블 셀렉트(위에서 인서트한 데이터)
	ProcessDto pd = service.selectProcessNo();
	// 결재선 테이블 인서트 (결재자 수만큼)
	int result2 = service.insertProcess(dto, pd);


	CategoryDto categoryLeave = null;
	FormDto formLeave = null;
	if("A".equals(dto.getLvCheck())) {

		categoryLeave = service.selectCategoryLeave(dto);
		if(categoryLeave == null) {
			int insertCategoryLeave = service.insertCategoryLeave(dto);
			System.out.println("insertCategoryLeave:::" + insertCategoryLeave);
		}

		formLeave = service.selectProcessLeave(dto);
		if(formLeave == null) {
			int insertFormLeave = service.insertFormLeave(dto);
			System.out.println("insertFormLeave:::" + insertFormLeave);
		}

		// 연차 문서 인서트
		int result3 = service.insertDocumentAlv(dto, pd);

	} else if("B".equals(dto.getLvCheck())) {

		categoryLeave = service.selectCategoryLeave(dto);
		if(categoryLeave == null) {
			int insertCategoryLeave = service.insertCategoryLeave(dto);
			System.out.println("insertCategoryLeave:::" + insertCategoryLeave);
		}

		formLeave = service.selectProcessLeave(dto);
		if(formLeave == null) {
			int insertFormLeave = service.insertFormLeave(dto);
			System.out.println("insertFormLeave:::" + insertFormLeave);
		}

		// 휴가 문서 인서트
		int result3 = service.insertDocumentLv(leavePeriod, dto, pd);

	} else {
		// 문서 테이블 인서트
		int result3 = service.insertDocument(dto, pd);
	}

	// 참조자 테이블 인서트
	if(dto.getReferNo() != null) {
		if(dto.getReferNo().length > 0) {			
			int result4 = service.insertRef(dto, pd);
		}			
	}
	// addAttribute
	// 문서 정보 문서 테이블
	DocsDto doc = service.selectDocument(pd);
	Date makeDate = doc.getDocMake();
	Date closeDate = doc.getDocClose();
	SimpleDateFormat ft = new SimpleDateFormat("yyyy. MM. dd.");
	doc.setSimpleMakeDate(ft.format(makeDate));
	doc.setSimpleCloseDate(ft.format(closeDate));

	if("A".equals(dto.getLvCheck())) {
		Date appliDate = doc.getAlvAppli();
		Date startDate = doc.getAlvStart();
		Date endDate = doc.getAlvEnd();

		doc.setSimpleAppliDate(ft.format(appliDate));
		doc.setSimpleStartDate(ft.format(startDate));
		doc.setSimpleEndDate(ft.format(endDate));

	} else if("B".equals(dto.getLvCheck())) {
		Date appliDate = doc.getLvAppli();
		Date startDate = doc.getLvStart();
		Date endDate = doc.getLvEnd();

		doc.setSimpleAppliDate(ft.format(appliDate));
		doc.setSimpleStartDate(ft.format(startDate));
		doc.setSimpleEndDate(ft.format(endDate));
	}

	model.addAttribute("docInfo", doc);

	// 결재자 정보 결재선 테이블
	List<ProcessDto> processList = service.selectProcess(pd);
	model.addAttribute("processList", processList);

	log.info(doc.toString());
	// 완료후 기안문서조회 상세 페이지로
	return "ea/user/ea_signuplist_detail";
}
```

## <문서 양식 관리>
```javascript
 // - , + 버튼으로 카테고리, 양식 추가/삭제
 <script>
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
