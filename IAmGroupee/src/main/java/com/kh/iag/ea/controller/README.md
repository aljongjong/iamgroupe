# ๐พ ์ ์๊ฒฐ์ฌ ์ฌ์ฉ์ ์ฃผ์ ๋ก์ง

## <๊ธฐ์ ์ ์ฒญ>
```java
// ๊ธฐ์์ ์ฒญ (์ฒ๋ฆฌ)
@PostMapping(value = "/write")
public String write(Model model, HttpSession session, @ModelAttribute SignupDto dto, String leavePeriod) throws Exception {

	// ๊ฒฐ์ฌ์  ๋ฒํธ ํ์ด๋ธ ์ธ์ํธ(๋ฌธ์๋ฒํธ, ๊ฒฐ์ฌ์ ๋ฒํธ)
	int result1 = service.insertProcessNo(session, dto);
	// ๊ฒฐ์ฌ์  ๋ฒํธ ํ์ด๋ธ ์๋ ํธ(์์์ ์ธ์ํธํ ๋ฐ์ดํฐ)
	ProcessDto pd = service.selectProcessNo();
	// ๊ฒฐ์ฌ์  ํ์ด๋ธ ์ธ์ํธ (๊ฒฐ์ฌ์ ์๋งํผ)
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

		// ์ฐ์ฐจ ๋ฌธ์ ์ธ์ํธ
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

		// ํด๊ฐ ๋ฌธ์ ์ธ์ํธ
		int result3 = service.insertDocumentLv(leavePeriod, dto, pd);

	} else {
		// ๋ฌธ์ ํ์ด๋ธ ์ธ์ํธ
		int result3 = service.insertDocument(dto, pd);
	}

	// ์ฐธ์กฐ์ ํ์ด๋ธ ์ธ์ํธ
	if(dto.getReferNo() != null) {
		if(dto.getReferNo().length > 0) {			
			int result4 = service.insertRef(dto, pd);
		}			
	}
	// addAttribute
	// ๋ฌธ์ ์ ๋ณด ๋ฌธ์ ํ์ด๋ธ
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

	// ๊ฒฐ์ฌ์ ์ ๋ณด ๊ฒฐ์ฌ์  ํ์ด๋ธ
	List<ProcessDto> processList = service.selectProcess(pd);
	model.addAttribute("processList", processList);

	log.info(doc.toString());
	// ์๋ฃํ ๊ธฐ์๋ฌธ์์กฐํ ์์ธ ํ์ด์ง๋ก
	return "ea/user/ea_signuplist_detail";
}
```

## <๊ฒฐ์ฌ ์ฒ๋ฆฌ>
```java
// ๊ฒฐ์ฌ๋ฌธ์์กฐํ (๊ฒฐ์ฌ์งํ)
@PostMapping(value = "/apprlist/process")
public String apprlisApprved(String docNo, @ModelAttribute ProcessDto dto) throws Exception {

	// ๊ฒฐ์ฌ์  ํ์ด๋ธ ์๋ฐ์ดํธ
	int result1 = service.updateProcessState(dto);			
	if(dto.getProcSeq() == 2 || dto.getProcSeq() == 3) {
		int result2 = service.updateStageName(dto);
	}

	// ๊ฒฐ์ฌ์๋ฐ์ดํธํ ํ ๊ฐ์ง๊ณ  ์์ ๊ฑฐ๊ธฐ์ ์๋ procSep์ด๋ procCnt๊ฐ ๊ฐ๊ณ , procSeq์ด 1์ด๊ฑฐ๋ 4์ด๋ฉด ์น์ธ์๋ฃ๋ ๋ฌธ์๋ก ๋ฐ๊ฟ์ผํจ DOC_SEP = 'Y'๋ก
	ProcessDto resultDto = service.checkingLastProcess(dto);

	// ๋ฌธ์ํ์ด๋ธ ๋ฌธ์๋จ๊ณ +1 (DEFAULT '1' -> 1์ฐจ๊ฒฐ์ฌํ  ์ฐจ๋ก์์ ์น์ธ์ผ๋๋ +1 , ์ ๊ฒฐ์ผ๋๋ procCnt๋งํผ ๋ค ์ฌ๋ฆฌ๊ธฐ)
	// ๋ฐ๋ ค๋ ํ์์์ฒญ์ผ๋ ใดใด
	if(dto.getProcSeq() != 2 && dto.getProcSeq() != 3) {
		// +1
		if(dto.getProcSeq() == 1) {
			int result3 = service.updateDocumentStageWhenOne(resultDto);
		// proCnt + 1๋งํผ ์ฌ๋ฆฌ๊ธฐ
		} else if(dto.getProcSeq() == 4) {
			int result4 = service.updateDocumentStageWhenFour(resultDto);
		}
	}
	// ๊ฒฐ์ฌ์๋ฐ์ดํธํ ํ ๊ฐ์ง๊ณ  ์์ ๊ฑฐ๊ธฐ์ ์๋ procSep์ด๋ procCnt๊ฐ ๊ฐ๊ณ , procSeq์ด 1์ด๊ฑฐ๋ 4์ด๋ฉด ์น์ธ์๋ฃ๋ ๋ฌธ์๋ก ๋ฐ๊ฟ์ผํจ DOC_SEP = 'Y'๋ก
	if((resultDto.getProcSep() == resultDto.getProcCnt()) || (resultDto.getProcSeq() == 4)) {
		if(resultDto.getProcSeq() == 1 || resultDto.getProcSeq() == 4) {
			// EA_DOCUMENT ํ์ด๋ธ ๋ฌธ์ ์น์ธ์๋ฃ๋ก ๋๋ฆฌ๊ธฐ
			int result5 = service.updateDocumentSep(resultDto);
		}
	}

	return "ea/user/ea_apprlist_list";
}
```

## <๋ฌธ์ ์กฐํ>
```java
public List<DocsDto> entireCap(HttpSession session) throws Exception {
		
	UserDto loginUser = (UserDto) session.getAttribute("loginUser");
	String userNo = loginUser.getUserNo();
	long positionNo = loginUser.getPositionNo();

	// SEC_A, SEC_B ์ค์ ์ ๋ณด
	int secA = service.selectSecA();
	int secB = service.selectSecB();


	// ๋ก๊ทธ์ธํ ์ ์ ์ ๊ธฐ์๋ฌธ์, ๊ฒฐ์ฌ๋ฌธ์, ์ฐธ๊ณ ๋ฌธ์ ๋ฐ์ดํฐ (S๋ฑ๊ธ)
	List<DocsDto> relatedDocs = service.selectRelatedDocs(userNo);

	// ๋ก๊ทธ์ธํ ์ ์ ์ ๊ด๋ จ์๋(๊ธฐ์, ๊ฒฐ์ฌ, ์ฐธ๊ณ ํ์ง ์์) ๋ฌธ์๋ค (๋ณด์๋ฑ๊ธ ํํฐ๋ง ํ์)
	List<DocsDto> notRelatedDocs = service.selectNotRelatedDocs(userNo);

	// ํ๋ฉด์ผ๋ก ๋ณด๋ผ ๋ฌธ์ ๋ฆฌ์คํธ
	List<DocsDto> entireList = new ArrayList<>();

	// S๋ฑ๊ธ
	relatedDocs.stream()
			   .forEach(d -> entireList.add(d));

	// C๋ฑ๊ธ ๋ฌธ์ ์ฒ๋ฆฌ
	notRelatedDocs.stream()
				  .filter(d -> d.getDocSlv().equals("C"))
				  .forEach(d -> entireList.add(d));

	// B๋ฑ๊ธ ๋ฌธ์ ์ฒ๋ฆฌ
	notRelatedDocs.stream()
				  .filter(d -> d.getDocSlv().equals("B") && positionNo <= secB)
				  .forEach(d -> entireList.add(d));

	// A๋ฑ๊ธ ๋ฌธ์ ์ฒ๋ฆฌ
	notRelatedDocs.stream()
				  .filter(d -> d.getDocSlv().equals("A") && positionNo <= secA)
				  .forEach(d -> entireList.add(d));


	return entireList;
}
```
