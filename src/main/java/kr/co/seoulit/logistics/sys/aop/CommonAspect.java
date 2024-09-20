package kr.co.seoulit.logistics.sys.aop;

import java.util.Collections;

import javax.servlet.http.HttpServletRequest;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.aop.Advisor;
import org.springframework.aop.aspectj.AspectJExpressionPointcut;
import org.springframework.aop.support.DefaultPointcutAdvisor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.interceptor.MatchAlwaysTransactionAttributeSource;
import org.springframework.transaction.interceptor.RollbackRuleAttribute;
import org.springframework.transaction.interceptor.RuleBasedTransactionAttribute;
import org.springframework.transaction.interceptor.TransactionInterceptor;
import org.springframework.web.servlet.ModelAndView;

import kr.co.seoulit.logistics.logiinfosvc.hr.exception.DataNotInputException;
import kr.co.seoulit.logistics.logiinfosvc.hr.exception.IdNotFoundException;
import kr.co.seoulit.logistics.logiinfosvc.hr.exception.PwMissMatchException;
import kr.co.seoulit.logistics.logiinfosvc.hr.exception.PwNotFoundException;
import lombok.extern.slf4j.Slf4j;

@Aspect
@Configuration
@EnableAspectJAutoProxy
@Slf4j
public class CommonAspect {
	
//	ExceptionHandler
	 @org.springframework.web.bind.annotation.ExceptionHandler(IdNotFoundException.class)
	  public ModelAndView idNotFoundExceptionHandler(HttpServletRequest request, IdNotFoundException e) {
		  ModelAndView mv = new ModelAndView("/hr/loginform");
		  
		  mv.addObject("errorCode", -2);
		  mv.addObject("errorMsg", e.getMessage());
	      System.out.println("#######################IdNotFoundException#################1");
	     	      
	      log.error("Request: " + request.getRequestURL() +"\n"+ " raised " + e);
	      return mv;
	  }
	  @org.springframework.web.bind.annotation.ExceptionHandler(DataNotInputException.class)
	  public ModelAndView dataNotInputExceptionHandler(HttpServletRequest request, DataNotInputException e) {
		  ModelAndView mv = new ModelAndView("/hr/loginform");
		  
		  mv.addObject("errorCode", -1);
		  mv.addObject("errorMsg", e.getMessage());
	      System.out.println("#######################DataNotInputException#################1");
	     	      
	      log.error("Request: " + request.getRequestURL() +"\n"+ " raised " + e);
	      return mv;
	  }
	  @org.springframework.web.bind.annotation.ExceptionHandler(PwMissMatchException.class)
	  public ModelAndView pwMissMatchException(HttpServletRequest request, PwMissMatchException e) {
		  ModelAndView mv = new ModelAndView("/hr/loginform");
		  
		  mv.addObject("errorCode", -4);
		  mv.addObject("errorMsg", e.getMessage());
	      System.out.println("#######################PwMissMatchException#################1");
	     	      
	      log.error("Request: " + request.getRequestURL() +"\n"+ " raised " + e);
	      return mv;
	  }
	  @org.springframework.web.bind.annotation.ExceptionHandler(PwNotFoundException.class)
	  public ModelAndView pwNotFoundExceptionHandler(HttpServletRequest request, PwNotFoundException e) {
		  ModelAndView mv = new ModelAndView("/hr/loginform");
		  
		  mv.addObject("errorCode", -3);
		  mv.addObject("errorMsg", e.getMessage());
	      System.out.println("#######################PwNotFoundException#################1");
	     	      
	      log.error("Request: " + request.getRequestURL() +"\n"+ " raised " + e);
	      return mv;
	  }
	  
	  @org.springframework.web.bind.annotation.ExceptionHandler(DataAccessException.class)
	  public ModelAndView pwNotFoundExceptionHandler(HttpServletRequest request, DataAccessException e) {
		  ModelAndView mv = new ModelAndView("/errorPage");
		  
		  mv.addObject("errorCode", -3);
		  mv.addObject("errorMsg", e.getMessage());
	      System.out.println("#####################DataAccessException###################1");
	     	      
	      log.error("Request: " + request.getRequestURL() +"\n"+ " raised " + e);
	      return mv;
	  }
	  
	 @org.springframework.web.bind.annotation.ExceptionHandler(Exception.class)
	 public ModelAndView defaultExceptionHandler(HttpServletRequest request,Exception exception){ 
		 ModelAndView mv = new ModelAndView("/errorPage"); 
		 mv.addObject("exception", exception);
		 System.out.println("******************** 전체익셉션");
		 log.error("defaultExceptionHandler", exception);
		 return mv; 
	 }
	 
//	LoggerAspect
	 @Component
	 @Aspect
	 public class LoggerAspect {
		  //Logger log = LoggerFactory.getLogger(getClass());
		
		@Around("execution(* kr..controller.*.*(..)) or execution(* kr..service.*.*(..)) or execution(* kr..mapper.*.*(..))")
		public Object logPrint(ProceedingJoinPoint joinPoint) throws Throwable {
			String type = "";
			String name = joinPoint.getSignature().getDeclaringTypeName();
			if (name.indexOf("Controller") > -1) {
				type = "Controller  \t:  ";
			}
			else if (name.indexOf("Service") > -1) {
				type = "ServiceImpl  \t:  ";
			}
			else if (name.indexOf("Mapper") > -1) {
				type = "Mapper  \t\t:  ";
			}
			log.info(type + name + "." + joinPoint.getSignature().getName() + "()");
			Object obj = joinPoint.proceed();
			
			return obj;
		}
	 }
	
//	TransactionAspect
	 @Configuration
	 public class TransactionAspect {
	 	private static final String AOP_TRANSACTION_METHOD_NAME = "*";
	 	private static final String AOP_TRANSACTION_EXPRESSION = "execution(* kr.co.seoulit..service.*.*(..) ) "; 
	 	
	 	@Autowired
	 	private PlatformTransactionManager transactionManager;
	 	
	 	@SuppressWarnings("deprecation")
		@Bean	
	 	public TransactionInterceptor transactionAdvice(){
	 		MatchAlwaysTransactionAttributeSource source = new MatchAlwaysTransactionAttributeSource();
	 		RuleBasedTransactionAttribute transactionAttribute = new RuleBasedTransactionAttribute();
	 		transactionAttribute.setName(AOP_TRANSACTION_METHOD_NAME);
	 		transactionAttribute.setRollbackRules(Collections.singletonList(new RollbackRuleAttribute(DataAccessException.class)));
	 		source.setTransactionAttribute(transactionAttribute);
	 		return new TransactionInterceptor(transactionManager, source);
	 	}
	 	
	 	@Bean
	 	public Advisor transactionAdviceAdvisor(){
	 		AspectJExpressionPointcut pointcut = new AspectJExpressionPointcut();
	 		pointcut.setExpression(AOP_TRANSACTION_EXPRESSION);
	 		return new DefaultPointcutAdvisor(pointcut, transactionAdvice());
	 	}
	}
}