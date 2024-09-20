package kr.co.seoulit.logistics.logiinfosvc.compinfo.controller;


import java.util.Properties;
import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/compinfo/*")
public class SendEmailController {

   private Multipart multipart;

   @RequestMapping(value="/reportemail",method=RequestMethod.GET)
   public ModelAndView sendReportEmail(HttpServletRequest request, HttpServletResponse response) {

      String fileName = "Estimate.jrxml";
      String savePath = "C:\\물류프로젝트\\Logistics71_SpringBoot\\src\\main\\webapp\\resources\\iReportForm";
      
      String host = "smtp.gmail.com";
      final String user = "shoolove36";
      final String password = "wjddml4591@@";

      String to = "shoolove36@naver.com";

      // Get the session object
      Properties props = new Properties();
      props.put("mail.smtp.ssl.protocols", "TLSv1.2");
      props.put("mail.smtp.starttls.enable", "true");
      props.put("mail.smtp.host", host);
      props.put("mail.smtp.auth", "true");

      Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
         protected PasswordAuthentication getPasswordAuthentication() {
            return new PasswordAuthentication(user, password);
         }
      });

      // Compose the message
      try {
         MimeMessage message = new MimeMessage(session);
         message.setFrom(new InternetAddress(user));
         message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));

         // Subject
         
         switch (1) {
		case 1:
			
			break;

		default:
			break;
		}
         message.setSubject("요청하신 견적서 입니다.");
         multipart = new MimeMultipart();
               
         // Text
         MimeBodyPart mbp1 = new MimeBodyPart();
            mbp1.setText("요청하신 견적서 입니다. ");
            multipart.addBodyPart(mbp1);

         // send the message
         if(fileName != null){
               DataSource source = new FileDataSource(savePath+"\\"+fileName);
               BodyPart messageBodyPart = new MimeBodyPart();
               messageBodyPart.setDataHandler(new DataHandler(source));
               messageBodyPart.setFileName(fileName);
               multipart.addBodyPart(messageBodyPart);
           }
         message.setContent(multipart);
            Transport.send(message);
         System.out.println("메일 발송 성공!");

      } catch (MessagingException e) {
         e.printStackTrace();
      }
      return null;
   }
}
