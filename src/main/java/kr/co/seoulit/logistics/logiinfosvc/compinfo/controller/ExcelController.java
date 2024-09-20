package kr.co.seoulit.logistics.logiinfosvc.compinfo.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/compinfo/*")
public class ExcelController{
	
	@RequestMapping(value="/excel/download",method=RequestMethod.GET)
	public ModelMap downloadEstimateExcel(HttpServletRequest request, HttpServletResponse response) {
		
		XSSFWorkbook xssfWb = null; // .xlsx
		XSSFSheet xssfSheet = null; // .xlsx
		XSSFRow xssfRow = null; // .xlsx
		XSSFCell xssfCell = null;// .xlsx
		String excelName = request.getParameter("excelName");
		String data = request.getParameter("data");
		JSONObject json = new JSONObject(data);
		FileOutputStream fos1 = null;
		ModelMap map = new ModelMap();

		try {

			int rowNo = 0;
			xssfWb = new XSSFWorkbook();
			xssfSheet = xssfWb.createSheet("견적명세서");
			
			XSSFFont font = xssfWb.createFont();
			font.setFontName(HSSFFont.FONT_ARIAL); 
			font.setFontHeightInPoints((short)14); 
			font.setBold(true);
			
		
			CellStyle cellStyle_Title = xssfWb.createCellStyle();
			int columnPos=0;
			for(String key : json.keySet()) {
				xssfSheet.setColumnWidth(columnPos, (xssfSheet.getColumnWidth(columnPos))+(short)2048);
				columnPos++;
			}
			cellStyle_Title.setFont(font); 
			cellStyle_Title.setAlignment(HorizontalAlignment.CENTER);
			
			xssfSheet.addMergedRegion(new CellRangeAddress(0, 0, 0, columnPos-1)); 
			
			xssfRow = xssfSheet.createRow(rowNo++); 
			xssfCell = xssfRow.createCell((short) 0); 
			xssfCell.setCellStyle(cellStyle_Title); 
			xssfCell.setCellValue(excelName+"견적정보");
			

			CellStyle cellStyle_Column = xssfWb.createCellStyle();
			cellStyle_Column.setBorderTop(BorderStyle.THIN); 
			cellStyle_Column.setBorderBottom(BorderStyle.THIN);
			cellStyle_Column.setBorderLeft(BorderStyle.THIN); 
			cellStyle_Column.setBorderRight(BorderStyle.THIN); 
			cellStyle_Column.setAlignment(HorizontalAlignment.CENTER);
			xssfRow = xssfSheet.createRow(rowNo++);
			columnPos=0;
			for(String key : json.keySet()) {
				xssfCell = xssfRow.createCell((short) columnPos);
				xssfCell.setCellStyle(cellStyle_Column);
				xssfCell.setCellValue(key);
				columnPos++;
			}
			
			  CellStyle cellStyle_Body = xssfWb.createCellStyle();
				cellStyle_Column.setBorderTop(BorderStyle.THIN); 
				cellStyle_Column.setBorderBottom(BorderStyle.THIN);
				cellStyle_Column.setBorderLeft(BorderStyle.THIN); 
				cellStyle_Column.setBorderRight(BorderStyle.THIN); 
			  cellStyle_Body.setAlignment(HorizontalAlignment.CENTER);
			  xssfRow = xssfSheet.createRow(rowNo++);
			  columnPos=0;
			  for(String key : json.keySet()) { 
				  xssfCell = xssfRow.createCell((short) columnPos);
				  xssfCell.setCellStyle(cellStyle_Body); xssfCell.setCellValue("");
				  xssfCell.setCellValue(json.get(key).toString());
				  columnPos++;
			  }
			 
			 
			
			String localFile = "C:\\dev\\nginx-1.21.6\\nginx-1.21.6\\html\\excel\\"+excelName+".xlsx";
			
			File lfile = new File(localFile);
			
			fos1 = new FileOutputStream(lfile);
			xssfWb.write(fos1);
			
			}
		catch(FileNotFoundException e1) {
			map.put("errorCode", -1);
			map.put("errorMsg", "파일을 찾을 수 없습니다.");
		}
		catch(Exception e){
			map.put("errorCode", -1);
			map.put("errorMsg", e.getMessage());
			e.printStackTrace();
		}finally{
			if (fos1 != null)
				try {
					fos1.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	}
return null;
	}
}