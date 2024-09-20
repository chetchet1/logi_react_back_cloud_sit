package kr.co.seoulit.logistics.logiinfosvc.compinfo.controller;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.service.CompInfoService;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.BoardTO;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.ListFormTO;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.util.BoardFile;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.util.BoardFileUploadUtil;

@RestController
@RequestMapping("/compinfo/*")
public class BoardController {

	@Autowired
	private CompInfoService compInfoService;

	private MultipartFile reportFile;
	ModelMap map=null;
	
	@RequestMapping(value = "/board/list", method = RequestMethod.GET)
	public ModelMap selectBoardList(HttpServletRequest request, HttpServletResponse response) {
		map = new ModelMap();
		response.setContentType("application/json; charset=UTF-8");
		ArrayList<BoardTO> list = null;
		ListFormTO boardList = null;
		int pagenum, sr, er, dbCount, selectValue;
		try {
			pagenum = 1;
			if (request.getParameter("pn") != null) {
				pagenum = Integer.parseInt(request.getParameter("pn"));
			}
			selectValue = Integer.parseInt(request.getParameter("selectValue"));
			boardList = new ListFormTO();
			dbCount = compInfoService.getRowCount();
			boardList.setRowsize(selectValue);
			boardList.setDbcount(dbCount);
			boardList.setPagenum(pagenum);
			sr = boardList.getStartrow();
			er = boardList.getEndrow();
			list = compInfoService.getBoardList(sr, er);
			boardList.setList(list);
			map.put("errorMsg", "success");
			map.put("errorCode", 0);
			map.put("boardlist", list);
			map.put("board", boardList);
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}
	
	// Detail
	@RequestMapping(value = "/board/detail", method = RequestMethod.GET)
	public ModelMap selectBoardDetail(HttpServletRequest request, HttpServletResponse response) {

		map = new ModelMap();

		response.setContentType("application/json; charset=UTF-8");

		int board_seq;

		String sessionId = null;

		try {

			board_seq = Integer.parseInt(request.getParameter("board_seq"));

			sessionId = (String) request.getSession().getAttribute("empName");

			BoardTO board = compInfoService.getBoard(sessionId, board_seq);
			
			map.put("errorMsg", "success");
			map.put("errorCode", 0);
			map.put("board", board);

		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}
	
	// delete
	@RequestMapping(value = "/board", method = RequestMethod.DELETE)
	public ModelMap deleteBoard(HttpServletRequest request, HttpServletResponse response) {

		map = new ModelMap();

		response.setContentType("application/json; charset=UTF-8");

		try {
			int board_seq = Integer.parseInt(request.getParameter("board_seq"));
			compInfoService.removeBoard(board_seq);
			map.put("errorMsg", "게시글이 삭제되었습니다");
			map.put("errorCode", 0);

		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}
	
	// register
	@RequestMapping(value = "/board", method = RequestMethod.POST)
	public ModelMap registerBoard(HttpServletRequest request, HttpServletResponse response) {

		map = new ModelMap();

		response.setContentType("application/json; charset=UTF-8");

		BoardTO board = new BoardTO();

		try {

			MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;

			reportFile = multipartRequest.getFile("uploadFile");

			String fileName = reportFile.getName();
			
			System.out.println("fileName ====>"+fileName);

			if ((fileName != null) && (reportFile.getSize() > 0)) {
				BoardFile boardFile = null;
				try {
					boardFile = BoardFileUploadUtil.doFileUpload(reportFile);
					System.out.println("boardFile ====>"+boardFile);
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
				board.addBoardFile(boardFile);
			}

			board.setName(request.getParameter("name"));
			board.setContent(request.getParameter("content"));
			board.setTitle(request.getParameter("title"));
			board.setBoard_seq(Integer.parseInt(request.getParameter("board_seq")));
			board.setReg_date(request.getParameter("reg_date"));

			compInfoService.addBoard(board);

			map.put("errorMsg", "게시글이 등록되었습니다");
			map.put("errorCode", 0);

		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}
	
	//download
	@RequestMapping(value="/board/download" ,method=RequestMethod.GET)
	public ModelMap downloadFile(HttpServletRequest request, HttpServletResponse response){
		map = new ModelMap();
		OutputStream servletoutputstream1 = null;
		//response.setCharacterEncoding("utf-8");		
		String tempFileName = request.getParameter("tempFileName");
		String fileName = request.getParameter("fileName");
		try {

			String filePath="C:\\dev\\nginx-1.21.6\\nginx-1.21.6\\html\\upload\\"+tempFileName;
			File tempFile = new File(filePath);
			int filesize = (int) tempFile.length();		
			response.setContentType("application/octet-stream;charset=utf-8");
			response.setHeader("Content-disposition", "attachment;filename=" + "" + new String(fileName.getBytes(),"iso-8859-1"));
			response.setHeader("Content-Transper-Encoding","binary");
			response.setContentLength(filesize);
			
			servletoutputstream1 = response.getOutputStream();

			dumpFile(tempFile, servletoutputstream1);

			servletoutputstream1.flush();
			System.out.println("@@@@@@@@@@@다운로드되나??");

		}catch (IOException e){
			e.printStackTrace();
			map.clear();
			map.put("errorCode", -1);
			map.put("errorMsg", e.getMessage());
        }catch (Exception e){
        	e.printStackTrace();
        	map.clear();
        	map.put("errorCode", -1);
			map.put("errorMsg", e.getMessage());
        }
	
		return map;
	}
	private void dumpFile(File realFile, OutputStream outputstream) {
		byte readByte[] = new byte[4096];
		try {
			BufferedInputStream bufferedinputstream = new BufferedInputStream(new FileInputStream(realFile));
			int i;
			while ((i = bufferedinputstream.read(readByte, 0, 4096)) != -1)
				outputstream.write(readByte, 0, i);		
				outputstream.close();
				bufferedinputstream.close();
		} catch (Exception _ex) {
			_ex.printStackTrace();
		}
	}
}
