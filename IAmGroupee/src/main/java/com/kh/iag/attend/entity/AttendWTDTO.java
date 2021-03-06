package com.kh.iag.attend.entity;

import lombok.Data;

@Data
public class AttendWTDTO 
{
	private long worktime_num;
	private String user_no;
	private String attend_date;	
	private String in_time;
	private String out_time;
	private String workcheck;
	private String normal_work_time;
	private String overtime_work_time;
	private float total_work_time;
}