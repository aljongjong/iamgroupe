package com.kh.iag.ea.entity;

import lombok.Data;

@Data
public class PageDto {
	// 위 4개의 값을 알아야 아래 5개의 값을 계산할 수 있다.
	private int currentPage;// 현재 페이지 
	private int cntPerPage; // 페이지 하나당 보여줄 row 개
	private int pageBtnCnt; // 페이지 버튼 몇개 보여줄
	private int totalRow; 	// 테이블의 전체 row 개수
	
	private int startRow; 	// 디비가서 조회할 rownum
	private int endRow; 	// 디비가서 조회할 rownum
	private int startPage;	// 시작 페이지
	private int endPage;	// 마지막 페이지 ({1(start),2,3,4,5(end)}, {6(start),7,8,9,10(end)}, {11(start), 12, 13(end)} 
	private int lastPage;	// DB의 row 기준으로 마지막 페이지는 몇인지 (게시글이 33개이고 한페이지당 보여주는 게시글이 10개이면 lastPage는 4)
	
	public PageDto(String currentPage, int cntPerPage, int pageBtnCnt, int totalRow) {
		this.currentPage = Integer.parseInt(currentPage);
		this.cntPerPage = cntPerPage;
		this.pageBtnCnt = pageBtnCnt;
		this.totalRow = totalRow;
		calc(Integer.parseInt(currentPage), cntPerPage, pageBtnCnt, totalRow);
	}

	private void calc(int currentPage, int cntPerPage, int pageBtnCnt, int totalRow) {
		this.setEndRow(this.getCurrentPage() * this.getCntPerPage());
		this.setStartRow(this.getEndRow() - this.getCntPerPage() + 1);
		
		int lastPage = this.getTotalRow() / this.getCntPerPage();
		if(this.getTotalRow() % this.getCntPerPage() > 0) {
			lastPage++;
		}
		this.setLastPage(lastPage);
		
		int endPage = this.getCurrentPage() / this.getPageBtnCnt();
		if(this.getCurrentPage() % this.getPageBtnCnt() > 0) {
			endPage++;
		}
		// 화면에서 처리가능
//		if(endPage > lastPage) {
//			endPage = lastPage;
//		}
		this.setEndPage(endPage * this.getPageBtnCnt());
		
		this.setStartPage(this.getEndPage() - this.getPageBtnCnt() + 1);
	}
}
