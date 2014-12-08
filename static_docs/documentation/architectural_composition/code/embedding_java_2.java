package example;

import jolie.runtime.JavaService;

public class Twice extends JavaService {

	public Integer twiceInt( Integer request ){
		Integer result = request + request;
		return result;
	}

	public Double twiceDoub( Double request ){
		Double result = request + request;
		return result;
	}
}