package com.kh.iag.ps.admin.service;

import java.io.File;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.kh.iag.ps.admin.dao.personnelDao;
import com.kh.iag.ps.admin.entity.PageVo;
import com.kh.iag.ps.admin.entity.UserDto;
import com.kh.iag.ps.admin.entity.departmentDto;
import com.kh.iag.ps.admin.entity.jobDto;
import com.kh.iag.ps.admin.entity.positionDto;
import com.kh.iag.ps.admin.entity.psCountDto;

@Service
@Transactional
public class personnelServiceImpl implements personnelService {

	@Autowired
	private personnelDao dao;
	
	@Autowired
	private PasswordEncoder pe;
	
	@Override
	public int userEnroll(UserDto user, HttpServletRequest req) throws Exception {
		user.setPwd(pe.encode(user.getPwd()));
		
		MultipartFile f = user.getFile();
		
//		파일 여부
		if(!f.isEmpty()) {
//			변경된 이름
			String changeName = user.getUserNo() +"_"+System.currentTimeMillis() + "_" + f.getOriginalFilename();
			String path = req.getServletContext().getRealPath("/resources/img/ps/profile/");
			File file = new File(path + changeName);
			f.transferTo(file);
			user.setProfile(changeName);
			System.out.println(user.getProfile());
		} else {
			user.setProfile("user.png");
		}
		int result = dao.userEnroll(user);
		
		return result;
	}

	@Override
	public int dupCheck(String userNo) throws Exception {
		return dao.dupCheck(userNo);
	}

	@Override
	public List<positionDto> posiList() throws Exception {
		return dao.posiList();
	}

	@Override
	public List<jobDto> jobList() throws Exception {
		return dao.jobList();
	}

	@Override
	public List<departmentDto> deptList() throws Exception {
		return dao.deptList();
	}

	@Override
	public psCountDto psCount() throws Exception {
		psCountDto psCnt = new psCountDto();
		psCnt.setDeptCnt(dao.deptCnt());
		psCnt.setJobCnt(dao.jobCnt());
		psCnt.setPosiCnt(dao.posiCnt());
		psCnt.setUserCnt(dao.userCnt());
		return psCnt;
	}

	@Override
	public List<UserDto> getUserList(PageVo pv) throws Exception {
		return dao.getUserList(pv);
	}

	@Override
	public PageVo getPageVo(String page, String search) throws Exception {
		if(page == null) {
			page = "1";
		}
		int cntPerPage = 10;
		int pageBtnCnt = 10;
		int totalRow = dao.getUserCnt(search);
		PageVo pv = new PageVo(page, cntPerPage, pageBtnCnt, totalRow);
		pv.setSearch(search);
		return pv;
	}

	@Override
	public int userUpdate(UserDto user, HttpServletRequest req) throws Exception {
		if(user.getPwd() != null && !user.getPwd().isEmpty()) {
			user.setPwd(pe.encode(user.getPwd()));
		}else {
			user.setPwd(null);
		}
		
		MultipartFile f = user.getFile();
		
//		파일 여부
		if(!f.isEmpty()) {
//			변경된 이름
			String changeName = user.getUserNo() +"_"+System.currentTimeMillis() + "_" + f.getOriginalFilename();
			String path = req.getServletContext().getRealPath("/resources/img/ps/profile/");
			File file = new File(path + changeName);
			f.transferTo(file);
			user.setProfile(changeName);
		} else {
			user.setProfile(null);
		}
		int result = dao.userUpdate(user);;
		
		return result;
	}
	

}
