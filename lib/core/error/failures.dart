import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Gagal memuat buku. Periksa koneksi internet Anda.',
  ]);
}

class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Server sedang bermasalah. Silakan coba lagi nanti.',
  ]);
}

class ParseFailure extends Failure {
  const ParseFailure([
    super.message = 'Gagal memproses data buku. Silakan coba lagi.',
  ]);
}

class CacheFailure extends Failure {
  const CacheFailure([
    super.message = 'Gagal mengakses data favorit. Silakan coba lagi.',
  ]);
}
