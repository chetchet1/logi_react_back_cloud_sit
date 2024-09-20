package kr.co.seoulit.logistics.logiinfosvc.compinfo.controller;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.sql.Connection;
import java.util.HashMap;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.design.JasperDesign;
import net.sf.jasperreports.engine.xml.JRXmlLoader;

@Controller
@RequestMapping("/compinfo/*")
public class ReportController {
	
	@Autowired
	private DataSource data;
	   
	@RequestMapping(value = "/report/estimate", method = RequestMethod.GET)
	public void estimateReport(HttpServletRequest request, HttpServletResponse response) {
		String iReportFolderPath = "C:\\dev\\nginx-1.21.6\\nginx-1.21.6\\html\\resources\\iReportForm\\Estimate.jrxml";

		HashMap<String, Object> parameters = new HashMap<>();
		// 레포트 이름
		InputStream inputStream = null;
		ServletOutputStream out = null;
		try {

			response.setCharacterEncoding("UTF-8");
			String orderDraftNo = request.getParameter("orderDraftNo");
			parameters.put("orderDraftNo", orderDraftNo);

			Connection conn = data.getConnection();

			inputStream = new FileInputStream(iReportFolderPath);

			// jrxml 형식으로 읽어옴
			JasperDesign jasperDesign = JRXmlLoader.load(inputStream);
			// jrxml 을 내가 원하는 모양을 가지고옴
			JasperReport jasperReport = JasperCompileManager.compileReport(jasperDesign);
			// 그 틀에 맞춰서 파라메터의 정보를 넣어줌
			JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, conn);

			out = response.getOutputStream();
			response.setContentType("application/pdf");
			JasperExportManager.exportReportToPdfStream(jasperPrint, out);
			out.println();
			out.flush();

		} catch (Exception e) {

			e.printStackTrace();
		} finally {
			if (inputStream != null) {
				try {
					inputStream.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			if (out != null) {
				try {
					out.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
	}

	@RequestMapping(value = "/report/contract", method = RequestMethod.GET)
	public void contractReport(HttpServletRequest request, HttpServletResponse response) {
		
		String iReportFolderPath = "C:\\dev\\nginx-1.21.6\\nginx-1.21.6\\html\\resources\\iReportForm\\Contract.jrxml";

		HashMap<String, Object> parameters = new HashMap<>();
		// 레포트 이름
		InputStream inputStream = null;
		ServletOutputStream out = null;
		try {

			response.setCharacterEncoding("UTF-8");
			String orderDraftNo = request.getParameter("orderDraftNo");
			parameters.put("orderDraftNo", orderDraftNo);

			Connection conn = data.getConnection();

			inputStream = new FileInputStream(iReportFolderPath);
			// jrxml 형식으로 읽어옴
			JasperDesign jasperDesign = JRXmlLoader.load(inputStream);
			// jrxml 을 내가 원하는 모양을 가지고옴
			JasperReport jasperReport = JasperCompileManager.compileReport(jasperDesign);
			// 그 틀에 맞춰서 파라메터의 정보를 넣어줌
			JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, conn);

			out = response.getOutputStream();
			response.setContentType("application/pdf");
			JasperExportManager.exportReportToPdfStream(jasperPrint, out);
			out.println();
			out.flush();

		} catch (Exception e) {

			e.printStackTrace();
		} finally {
			if (inputStream != null) {
				try {
					inputStream.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			if (out != null) {
				try {
					out.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
	}
}