package com.samyang.winplus.common.system.security.xss;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Enumeration;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Part;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.util.FileCopyUtils;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.multipart.MultipartException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.support.AbstractMultipartHttpServletRequest;

import com.samyang.winplus.common.system.util.ExceltoJava;


public class CustomMultipartHttpServletRequest extends AbstractMultipartHttpServletRequest {
	
	private static final String CONTENT_DISPOSITION = "content-disposition";

	private static final String FILENAME_KEY = "filename=";

	private static final String FILENAME_WITH_CHARSET_KEY = "filename*=";

	static Logger logger = LoggerFactory.getLogger(ExceltoJava.class);
	
	private Set<String> multipartParameterNames;


	/**
	 * Create a new StandardMultipartHttpServletRequest wrapper for the given request,
	 * immediately parsing the multipart content.
	 * @param request the servlet request to wrap
	 * @throws MultipartException if parsing failed
	 */
	public CustomMultipartHttpServletRequest(HttpServletRequest request) throws MultipartException {
		this(request, false);
	}

	/**
	 * Create a new StandardMultipartHttpServletRequest wrapper for the given request.
	 * @param request the servlet request to wrap
	 * @param lazyParsing whether multipart parsing should be triggered lazily on
	 * first access of multipart files or parameters
	 * @throws MultipartException if an immediate parsing attempt failed
	 */
	public CustomMultipartHttpServletRequest(HttpServletRequest request, boolean lazyParsing) throws MultipartException {
		super(request);
		if (!lazyParsing) {
			parseRequest(request);
		}
	}


	private void parseRequest(HttpServletRequest request) {
		try {
			Collection<Part> parts = request.getParts();
			this.multipartParameterNames = new LinkedHashSet<>(parts.size());
			MultiValueMap<String, MultipartFile> files = new LinkedMultiValueMap<>(parts.size());
			for (Part part : parts) {
				String disposition = part.getHeader(CONTENT_DISPOSITION);
				String filename = extractFilename(disposition);
				if (filename == null) {
					filename = extractFilenameWithCharset(disposition);
				}
				if (filename != null) {
					files.add(part.getName(), getNewStandardMultipartFile(part, filename));
				} else {
					this.multipartParameterNames.add(part.getName());
				}
			}
			setMultipartFiles(files);
		}
		catch (Exception ex) {
			throw new MultipartException("Could not parse multipart servlet request", ex);
		}
	}
	
	public StandardMultipartFile getNewStandardMultipartFile(Part part, String filename){
		return new StandardMultipartFile(part, filename);
	}

	private String extractFilename(String contentDisposition) {
		return extractFilename(contentDisposition, FILENAME_KEY);
	}

	private String extractFilename(String contentDisposition, String key) {
		if (contentDisposition == null) {
			return null;
		}
		int startIndex = contentDisposition.indexOf(key);
		if (startIndex == -1) {
			return null;
		}
		String filename = contentDisposition.substring(startIndex + key.length());
		if (filename.startsWith("\"")) {
			int endIndex = filename.indexOf("\"", 1);
			if (endIndex != -1) {
				return filename.substring(1, endIndex);
			}
		}
		else {
			int endIndex = filename.indexOf(";");
			if (endIndex != -1) {
				return filename.substring(0, endIndex);
			}
		}
		return filename;
	}

	private String extractFilenameWithCharset(String contentDisposition) {
		String filename = extractFilename(contentDisposition, FILENAME_WITH_CHARSET_KEY);
		if (filename == null) {
			return null;
		}
		int index = filename.indexOf("'");
		if (index != -1) {
			Charset charset = null;
			try {
				charset = Charset.forName(filename.substring(0, index));
			}
			catch (IllegalArgumentException ex) {
				// ignore
				logger.error(ex.toString());
			}
			filename = filename.substring(index + 1);
			// Skip language information..
			index = filename.indexOf("'");
			if (index != -1) {
				filename = filename.substring(index + 1);
			}
			if (charset != null) {
				filename = new String(filename.getBytes(StandardCharsets.US_ASCII), charset);
			}
		}
		return filename;
	}


	@Override
	protected void initializeMultipart() {
		parseRequest(getRequest());
	}

	@Override
	public Enumeration<String> getParameterNames() {
		if (this.multipartParameterNames == null) {
			initializeMultipart();
		}
		if (this.multipartParameterNames.isEmpty()) {
			return super.getParameterNames();
		}

		// Servlet 3.0 getParameterNames() not guaranteed to include multipart form items
		// (e.g. on WebLogic 12) -> need to merge them here to be on the safe side
		Set<String> paramNames = new LinkedHashSet<>();
		Enumeration<String> paramEnum = super.getParameterNames();
		while (paramEnum.hasMoreElements()) {
			paramNames.add(paramEnum.nextElement());
		}
		paramNames.addAll(this.multipartParameterNames);
		return Collections.enumeration(paramNames);
	}

	@Override
	public Map<String, String[]> getParameterMap() {
		if (this.multipartParameterNames == null) {
			initializeMultipart();
		}
		if (this.multipartParameterNames.isEmpty()) {
			return super.getParameterMap();
		}

		// Servlet 3.0 getParameterMap() not guaranteed to include multipart form items
		// (e.g. on WebLogic 12) -> need to merge them here to be on the safe side
		Map<String, String[]> paramMap = new LinkedHashMap<>();
		paramMap.putAll(super.getParameterMap());
		for (String paramName : this.multipartParameterNames) {
			if (!paramMap.containsKey(paramName)) {
				paramMap.put(paramName, getParameterValues(paramName));
			}
		}
		return paramMap;
	}

	@Override
	public String getMultipartContentType(String paramOrFileName) {
		try {
			Part part = getPart(paramOrFileName);
			return (part != null ? part.getContentType() : null);
		}
		catch (Exception ex) {
			throw new MultipartException("Could not access multipart servlet request", ex);
		}
	}

	@Override
	public HttpHeaders getMultipartHeaders(String paramOrFileName) {
		try {
			Part part = getPart(paramOrFileName);
			if (part != null) {
				HttpHeaders headers = new HttpHeaders();
				for (String headerName : part.getHeaderNames()) {
					headers.put(headerName, new ArrayList<>(part.getHeaders(headerName)));
				}
				return headers;
			}
			else {
				return null;
			}
		}
		catch (Exception ex) {
			throw new MultipartException("Could not access multipart servlet request", ex);
		}
	}


	/**
	 * Spring MultipartFile adapter, wrapping a Servlet 3.0 Part object.
	 */
	@SuppressWarnings("serial")
	private static class StandardMultipartFile implements MultipartFile, Serializable {

		private final Part part;

		private final String filename;
		
		public StandardMultipartFile(Part part, String filename) {
			this.part = part;
			this.filename = filename;
		}

		@Override
		public String getName() {
			return this.part.getName();
		}

		@Override
		public String getOriginalFilename() {
			//순수 FileName만 가져오게 수정
			if(this.filename == null) {
				return null;
			}
			if(this.filename.equals("")) {
				return  "";
			}
			String[] filePath = this.filename.split("\\\\");
			return filePath[filePath.length-1];
		}

		@Override
		public String getContentType() {
			return this.part.getContentType();
		}

		@Override
		public boolean isEmpty() {
			return this.part.getSize() == 0;
		}

		@Override
		public long getSize() {
			return this.part.getSize();
		}

		@Override
		public byte[] getBytes() throws IOException {
			return FileCopyUtils.copyToByteArray(this.part.getInputStream());
		}

		@Override
		public InputStream getInputStream() throws IOException {
			return this.part.getInputStream();
		}

		@Override
		public void transferTo(File dest) throws IOException, IllegalStateException {
			this.part.write(dest.getPath());
		}
	}

}