package kr.co.seoulit.logistics.sys.response;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public class Success<T> implements Result{
    private T data;
}
