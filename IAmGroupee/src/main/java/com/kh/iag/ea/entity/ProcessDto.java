package com.kh.iag.ea.entity;

import lombok.Data;

@Data
public class ProcessDto {
	private String procNo;	// 결재선 번호
	private String userNo;	// 결재자 사원번호
	private int procSep;	// 결재 순서 번호 (1 ~ 5)
	private int procSeq;	// 결재 구분 0(대기), 1(승인), 2(반려 or 협의요청), 3(전결)
	private String procRejected; // 반려사유
	private String docNo;	// 문서번호
	
	
}