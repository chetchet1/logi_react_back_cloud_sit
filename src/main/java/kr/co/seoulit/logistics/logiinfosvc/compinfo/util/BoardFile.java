package kr.co.seoulit.logistics.logiinfosvc.compinfo.util;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.BoardTO;
import lombok.Data;

@Data
public class BoardFile {
	private int file_seq;
	
	private BoardTO board;
	private String fileName;
	private String tempFileName;
}

