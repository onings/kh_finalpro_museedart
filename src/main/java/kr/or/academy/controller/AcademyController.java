package kr.or.academy.controller;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;

import kr.or.academy.service.AcademyService;
import kr.or.academy.vo.Academy;
import kr.or.academy.vo.AcademyPagingVo;

@Controller
public class AcademyController {
	@Autowired
	private AcademyService service;
	//수업 등록으로 이동
	@RequestMapping(value="/academyFrm.do")
	public String academyFrm() {
		return "academy/academyInsert";
	}
	//리스트 페이지 출력
	@RequestMapping(value="/academyList.do")
	public String academyList(Academy a,Model model,int reqPage) {
		//전체 페이지 겟수 출력 
		int totalCount = service.academyTotal();
		ArrayList<Academy> list = service.selectAcademyList(reqPage);
		int count = list.size();
		model.addAttribute("list",list);
		model.addAttribute("totalCount",totalCount);
		model.addAttribute("count",count);
		return "academy/academyList";
	}
	//수업 등록
	@RequestMapping(value="/academyInsert.do")
	public String academyInsert(Academy a,MultipartFile upfile, HttpServletRequest request,Model model) {
		if(upfile != null) {
			String savePath = request.getSession().getServletContext().getRealPath("/resources/academyImage/upload/");
			
			String filename = upfile.getOriginalFilename();
			String onlyFilename = filename.substring(0, filename.indexOf("."));
			String extention = filename.substring(filename.indexOf("."));
			
			String filepath = null;
			int count = 0;
			while(true) {
				if(count==0) {
					filepath = onlyFilename + extention;
				}else {
					filepath = onlyFilename+"_"+count+extention;
				}
				File checkFile = new File(savePath+filepath);
				if(!checkFile.exists()) {
					break;
				}
				count++;
			}
			
			try {
				FileOutputStream fos = new FileOutputStream(new File(savePath+filepath));
				BufferedOutputStream bos = new BufferedOutputStream(fos);
				byte[] bytes = upfile.getBytes();
				bos.write(bytes);
				bos.close();
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			String academyPhoto = "/resources/academyImage/upload/"+filepath;
			a.setAcademyPhoto(academyPhoto);
		}
		int result = service.academyInsert(a);
		if(result>0) {
			model.addAttribute("msg", "수업 등록 성공");			
		}else {
			model.addAttribute("msg", "수업 등록 실패");
		}
		model.addAttribute("loc", "/academyList.do");
		return "common/msg";
	}
	//더보기
	@ResponseBody
	@RequestMapping(value ="/moreAcademy.do",produces = "application/json;charset=utf-8")
	public String moreAcademy(int start) {
		//아작스 data start 값 strat 받아옴
		ArrayList<Academy> list = service.moreAcademy(start);
		return new Gson().toJson(list);
	}
	//상세보기 로 이동
	@RequestMapping(value="/academyView.do")
	public String academyView(int academyNo, Model model) {
		Academy a = service.selectOneAcademy(academyNo);
		model.addAttribute("a",a);
		return "academy/academyView";
	}
}
