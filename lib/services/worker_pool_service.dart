import 'dart:async';

import 'package:pgtk_common/pgtk_common.dart';
import 'package:pgtk_pub_sub/models/chunk_model.dart';
import 'package:pgtk_pub_sub/models/worker_model.dart';

class WorkerPoolService {
  WorkerPoolService({
    required this.workers,
    required this.publisher,
    required this.subscriber,
  });

  final PostgresConnectionInfo publisher;
  final PostgresConnectionInfo subscriber;
  final List<Worker> workers;
  final Map<int, bool> _workerAvailability = {};

  /// Initialize the worker pool by marking all workers as available
  /// and setting up their database connections
  Future<void> initialize(String snapshotName) async {
    for (var i = 0; i < workers.length; i++) {
      _workerAvailability[i] = true;

      // Initialize the worker with connection info
      await workers[i].initialize(snapshotName, publisher, subscriber);
    }
  }

  /// Process a list of chunks using the worker pool
  Future<void> processChunks(List<Chunk> chunks) async {
    final pendingChunks = List<Chunk>.from(chunks);
    final completionCompleter = Completer<void>();

    // Process initial batch of chunks
    _assignChunksToAvailableWorkers(pendingChunks);

    // Set up a timer to check periodically for newly available workers
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (pendingChunks.isEmpty && _allWorkersAvailable()) {
        timer.cancel();
        completionCompleter.complete();
      } else if (pendingChunks.isNotEmpty) {
        _assignChunksToAvailableWorkers(pendingChunks);
      }
    });

    return completionCompleter.future;
  }

  /// Assign chunks to available workers
  void _assignChunksToAvailableWorkers(List<Chunk> pendingChunks) {
    for (var i = 0; i < workers.length; i++) {
      if (pendingChunks.isEmpty) break;

      if (_workerAvailability[i] ?? true) {
        final chunk = pendingChunks.removeAt(0);
        _workerAvailability[i] = false;

        // Process the chunk and mark worker as available when done
        _processChunkWithWorker(i, chunk);
      }
    }
  }

  /// Process a chunk with a specific worker
  Future<void> _processChunkWithWorker(int workerIndex, Chunk chunk) async {
    try {
      // Send just the chunk to the worker - connections are already established
      final result = await workers[workerIndex].processChunk(chunk);

      // Process the result in the main thread
      if (result is String) {
        print(result);
      }
    } on Exception catch (e) {
      print('Error processing chunk ${chunk.id}: $e');
    } finally {
      // Mark the worker as available again
      _workerAvailability[workerIndex] = true;
    }
  }

  /// Check if all workers are available (not processing chunks)
  bool _allWorkersAvailable() {
    return _workerAvailability.values.every((available) => available);
  }

  /// Close all workers in the pool
  void closeAll() {
    for (final worker in workers) {
      worker.close();
    }
  }
}
