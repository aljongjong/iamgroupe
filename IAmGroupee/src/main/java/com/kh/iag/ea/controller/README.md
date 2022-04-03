# 👾 전자결재 사용자 주요 로직

## <기안 신청>
```
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

## <결재 처리>
```
// 결재문서조회 (결재진행)
@PostMapping(value = "/apprlist/process")
public String apprlisApprved(String docNo, @ModelAttribute ProcessDto dto) throws Exception {

	// 결재선 테이블 업데이트
	int result1 = service.updateProcessState(dto);			
	if(dto.getProcSeq() == 2 || dto.getProcSeq() == 3) {
		int result2 = service.updateStageName(dto);
	}

	// 결재업데이트한 행 가지고 와서 거기에 있는 procSep이랑 procCnt가 같고, procSeq이 1이거나 4이면 승인완료된 문서로 바꿔야함 DOC_SEP = 'Y'로
	ProcessDto resultDto = service.checkingLastProcess(dto);

	// 문서테이블 문서단계 +1 (DEFAULT '1' -> 1차결재할 차례에서 승인일때는 +1 , 전결일때는 procCnt만큼 다 올리기)
	// 반려나 협의요청일땐 ㄴㄴ
	if(dto.getProcSeq() != 2 && dto.getProcSeq() != 3) {
		// +1
		if(dto.getProcSeq() == 1) {
			int result3 = service.updateDocumentStageWhenOne(resultDto);
		// proCnt + 1만큼 올리기
		} else if(dto.getProcSeq() == 4) {
			int result4 = service.updateDocumentStageWhenFour(resultDto);
		}
	}
	// 결재업데이트한 행 가지고 와서 거기에 있는 procSep이랑 procCnt가 같고, procSeq이 1이거나 4이면 승인완료된 문서로 바꿔야함 DOC_SEP = 'Y'로
	if((resultDto.getProcSep() == resultDto.getProcCnt()) || (resultDto.getProcSeq() == 4)) {
		if(resultDto.getProcSeq() == 1 || resultDto.getProcSeq() == 4) {
			// EA_DOCUMENT 테이블 문서 승인완료로 돌리기
			int result5 = service.updateDocumentSep(resultDto);
		}
	}

	return "ea/user/ea_apprlist_list";
}
```

## <문서 조회>
```
public List<DocsDto> entireCap(HttpSession session) throws Exception {
		
	UserDto loginUser = (UserDto) session.getAttribute("loginUser");
	String userNo = loginUser.getUserNo();
	long positionNo = loginUser.getPositionNo();

	// SEC_A, SEC_B 설정정보
	int secA = service.selectSecA();
	int secB = service.selectSecB();


	// 로그인한 유저의 기안문서, 결재문서, 참고문서 데이터 (S등급)
	List<DocsDto> relatedDocs = service.selectRelatedDocs(userNo);

	// 로그인한 유저와 관련없는(기안, 결재, 참고하지 않은) 문서들 (보안등급 필터링 필요)
	List<DocsDto> notRelatedDocs = service.selectNotRelatedDocs(userNo);

	// 화면으로 보낼 문서 리스트
	List<DocsDto> entireList = new ArrayList<>();

	// S등급
	relatedDocs.stream()
			   .forEach(d -> entireList.add(d));

	// C등급 문서 처리
	notRelatedDocs.stream()
				  .filter(d -> d.getDocSlv().equals("C"))
				  .forEach(d -> entireList.add(d));

	// B등급 문서 처리
	notRelatedDocs.stream()
				  .filter(d -> d.getDocSlv().equals("B") && positionNo <= secB)
				  .forEach(d -> entireList.add(d));

	// A등급 문서 처리
	notRelatedDocs.stream()
				  .filter(d -> d.getDocSlv().equals("A") && positionNo <= secA)
				  .forEach(d -> entireList.add(d));


	return entireList;
}
```
