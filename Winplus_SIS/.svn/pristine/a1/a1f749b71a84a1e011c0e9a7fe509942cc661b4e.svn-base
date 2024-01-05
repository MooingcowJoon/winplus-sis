package com.samyang.winplus.common.system.util;

public class CommonException extends Exception{

	/**
	 * 
	 */
	
	
	private Object[] messageArgs;
	
	private static final long serialVersionUID = 1829725144942845472L;

	public CommonException(String message){
		super(message);
	}
	
	public CommonException(String message, Object[] messageArgs){		
		super(message);
		this.setMessageArgs(messageArgs);
	}

	public Object[] getMessageArgs() {
		return messageArgs;
	}

	public void setMessageArgs(Object[] messageArgs) {
		this.messageArgs = messageArgs;
	}
}
