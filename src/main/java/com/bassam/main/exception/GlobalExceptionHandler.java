package com.bassam.main.exception;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

@ControllerAdvice
public class GlobalExceptionHandler {
    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler({Exception.class, RuntimeException.class})
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    @ResponseBody
    public ErrorResponse handleGenericException(Exception ex) {
        String traceId = MDC.get("traceId");
        logger.error("Handling exception with trace ID: {} - Exception: {}", traceId, ex);
        return new ErrorResponse(HttpStatus.INTERNAL_SERVER_ERROR.value(), ex.getMessage(), traceId);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ResponseBody
    public ErrorResponse handleValidationException(MethodArgumentNotValidException ex) {
        String traceId = MDC.get("traceId");
        logger.error("Handling validation exception with trace ID: {} - Exception: {}", traceId, ex);
        return new ErrorResponse(HttpStatus.BAD_REQUEST.value(), ex.getMessage(), traceId);
    }
}

class ErrorResponse {
    private int code;
    private String message;
    private String traceId;

    public ErrorResponse(int code, String message, String traceId) {
        this.code = code;
        this.message = message;
        this.traceId = traceId;
    }

    // Getters and setters
}