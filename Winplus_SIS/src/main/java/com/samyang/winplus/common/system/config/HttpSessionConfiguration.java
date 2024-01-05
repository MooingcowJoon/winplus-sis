package com.samyang.winplus.common.system.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.session.ExpiringSession;
import org.springframework.session.MapSessionRepository;
import org.springframework.session.SessionRepository;
import org.springframework.session.jdbc.JdbcOperationsSessionRepository;
import org.springframework.session.web.http.CookieHttpSessionStrategy;
import org.springframework.session.web.http.CookieSerializer;
import org.springframework.session.web.http.SessionRepositoryFilter;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.util.AntPathMatcher;
import org.springframework.util.PathMatcher;
import org.springframework.web.util.UrlPathHelper;

import javax.annotation.PostConstruct;
import javax.servlet.FilterChain;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

/**
 * Spring Session 을 구성하는 설정정보
 *
 * @author ykpark@woowahan.com
 */
@Configuration
public class HttpSessionConfiguration {

	//private String tableName = JdbcOperationsSessionRepository.DEFAULT_TABLE_NAME;
	private String tableName = "SPRING_SESSION_SIS";
	private Integer maxInactiveIntervalInSeconds = 10 /* Hour */ * 3600 /* Secs/Hour */;

	private ServletContext servletContext;
	private CookieSerializer cookieSerializer;
	private CookieHttpSessionStrategy httpSessionStrategy = new CookieHttpSessionStrategy();

	@PostConstruct
	public void init() {
		if (this.cookieSerializer != null) {
			this.httpSessionStrategy.setCookieSerializer(this.cookieSerializer);
		}
		this.httpSessionStrategy.setSessionAliasParamName(null);
	}

	@Bean
	public JdbcOperationsSessionRepository sessionRepository(@Qualifier("proxyDataSource") DataSource dataSource,
			PlatformTransactionManager transactionManager) {
		JdbcOperationsSessionRepository sessionRepository = new JdbcOperationsSessionRepository(
				new JdbcTemplate(dataSource), transactionManager);
		sessionRepository.setTableName(tableName);
		sessionRepository.setDefaultMaxInactiveInterval(this.maxInactiveIntervalInSeconds);

		return sessionRepository;
	}

	@Bean
	public <S extends ExpiringSession> javax.servlet.Filter springSessionRepositoryFilter(
			SessionRepository<S> sessionRepository) {
		SessionRepositoryFilter<S> sessionRepositoryFilter = new SessionRepositoryFilter<>(sessionRepository);
		sessionRepositoryFilter.setServletContext(this.servletContext);
		sessionRepositoryFilter.setHttpSessionStrategy(this.httpSessionStrategy);

		return new ExcludeSessionRepositoryFilter(sessionRepositoryFilter);
	}

	@Autowired(required = false)
	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
	}

	@Autowired(required = false)
	public void setCookieSerializer(CookieSerializer cookieSerializer) {
		this.cookieSerializer = cookieSerializer;
	}

	static class ExcludeSessionRepositoryFilter extends org.springframework.web.filter.OncePerRequestFilter {

		private final SessionRepositoryFilter<?> sessionRepositoryFilter;

		private final UrlPathHelper pathHelper = new UrlPathHelper();
		private final PathMatcher pathMatcher = new AntPathMatcher();
		private final List<String> excludePaths = Arrays.asList("/resources/**", "/healthcheck.do");

		public ExcludeSessionRepositoryFilter(SessionRepositoryFilter<?> sessionRepositoryFilter) {
			this.sessionRepositoryFilter = Objects.requireNonNull(sessionRepositoryFilter);
		}

		@Override
		protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
				FilterChain filterChain) throws ServletException, IOException {
			String requestPath = pathHelper.getOriginatingRequestUri(request);
			if (checkExcludePath(requestPath)) {
				//logger.debug("proceed without invoking spring session filter.");
				filterChain.doFilter(request, response);
			} else {
				sessionRepositoryFilter.doFilter(request, response, filterChain);
			}
		}

		protected boolean checkExcludePath(String path) {
			return excludePaths.stream().anyMatch(excludePath -> pathMatcher.match(excludePath, path));
		}

		@SuppressWarnings("unused")
		public static void main(String[] args) {
			ExcludeSessionRepositoryFilter filter = new ExcludeSessionRepositoryFilter(
					new SessionRepositoryFilter<>(new MapSessionRepository()));

			// System.out.println(filter.checkExcludePath("/resources/common/css/default.css"));
			// System.out.println(filter.checkExcludePath("/resources/common/img/default/error.jpg"));
			// System.out.println(filter.checkExcludePath("/login.sis"));
		}

	}

}