package kr.co.seoulit.logistics.sys.configuration;

import java.nio.charset.Charset;

import javax.servlet.Filter;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import kr.co.seoulit.logistics.sys.interceptor.LoggerInterceptor;
import kr.co.seoulit.logistics.sys.interceptor.LoginInterceptor;

@Configuration
public class WebMvcConfiguration implements WebMvcConfigurer{
	private final long MAX_AGE_SEC = 3600;

	@Override
	public void addCorsMappings(CorsRegistry registry) {
		registry.addMapping("/**")
				.allowedOriginPatterns("${FRONTEND_SERVICE_URL}")  // 포트 제외
				.allowedMethods("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
				.allowedHeaders("*")
				.allowCredentials(true)  // 필요한 경우 활성화
				.maxAge(MAX_AGE_SEC);
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry){
		registry.addInterceptor(new LoginInterceptor())
			.addPathPatterns("/")
			.addPathPatterns("/*")
			//.addPathPatterns("/*/*.html")
			.excludePathPatterns("/*logout*")
			.excludePathPatterns("/*login*")
			.excludePathPatterns("/error");

		registry.addInterceptor(new LoggerInterceptor());

		WebMvcConfigurer.super.addInterceptors(registry);
	}

	// 2개의 빈은 인코딩 관련.
	@Bean
	public Filter characterEncodingFilter(){
		CharacterEncodingFilter characterEncodingFilter = new CharacterEncodingFilter();    //CharacterEncodingFilter는 스프링이 제공하는 클래스로 웹에서 주고받는 데이터의 헤더값을 UTF-8로 인코딩 해줌.
		characterEncodingFilter.setEncoding("UTF-8");
		characterEncodingFilter.setForceEncoding(true);  //기본값은 false로 설정되어 있음.
		
		return characterEncodingFilter;
	}
	
	@Bean
	public HttpMessageConverter<String> responseBodyConverter(){
		return new StringHttpMessageConverter(Charset.forName("UTF-8"));
	}

	@Bean
	public CommonsMultipartResolver multipartResolver() {
		CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver();
		multipartResolver.setDefaultEncoding("UTF-8"); 
		multipartResolver.setMaxUploadSizePerFile(10 * 1024 * 1024);
		return multipartResolver;
	  }

}
