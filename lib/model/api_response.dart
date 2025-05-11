sealed class ApiResponse<T> {}

class Success<T> extends ApiResponse<T> {
  T data;

  Success(this.data);
}

class Error<T> extends ApiResponse<T> {
  int statusCode;
  String message;

  Error(this.statusCode, this.message);
}
