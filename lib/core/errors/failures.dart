// lib/core/errors/failures.dart

import 'package:equatable/equatable.dart';

/// Abstract base class for all failures
/// Failures represent domain-level errors
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object?> get props => [message];
}

/// Server failure - API/Backend errors
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Network failure - Connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Cache failure - Local storage errors
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Validation failure - Input validation errors
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Authentication failure - Auth-related errors
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}

/// Authorization failure - Permission errors
class AuthorizationFailure extends Failure {
  const AuthorizationFailure(super.message);
}

/// Data parsing failure - JSON/Data format errors
class DataParsingFailure extends Failure {
  const DataParsingFailure(super.message);
}

/// Unexpected failure - Unknown errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}

/// Not found failure - Resource not found
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// Timeout failure - Request timeout
class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message);
}
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}
