import 'dart:async';

import 'package:super_liquid_galaxy_controller/data_class/PlaceSuggestionResponse.dart';
import 'package:super_liquid_galaxy_controller/utils/api_manager.dart';

const Duration debounceDuration = Duration(milliseconds: 500);

class AutocompleteController {
  // The query currently being searched for. If null, there is no pending request.
  String? _currentQuery;

  // The most recent options received from the API.
  Iterable<Features> lastOptions = <Features>[];

  late final _Debounceable<Iterable<Features>?, String> debouncedSearch;

  // Whether to consider the network to be offline.
  bool apiEnabled = true;

  // A network error was received on the most recent query.
  bool networkError = false;

  AutocompleteController() {
    debouncedSearch = _debounce<Iterable<Features>?, String>(_search);
  }

  // Calls the "remote" API to search with the given query. Returns null when the call has been made obsolete.
  Future<Iterable<Features>?> _search(String query) async {
    _currentQuery = query;

    late final Iterable<Features> options;
    try {
      var apiClient = ApiManager.instance;
      var response = await apiClient.getAutoCompleteResponse(query);
      if(response.statusCode != 200) {
        return null;
      }
      /*List<String> list = [];
      var suggestions = PlaceSuggestionResponse.fromJson(response.data);
      if(suggestions.features != null)
        {
         for(final place in suggestions.features!)
           {
             list.add(place.properties!.name!);
           }
        }
      options = list.where((String option){
        return true;
      });*/
      var suggestions = PlaceSuggestionResponse.fromJson(response.data);
      if(suggestions.features==null) {
        return null;
      }

      options = suggestions.features!.where((Features place){
        return true;
      });

      // options = await // Replace with your actual API Manager
    } catch (error) {
      if (error is NetworkException) {
        networkError = true;
        return <Features>[];
      }
      rethrow;
    }

    // If another search happened after this one, throw away these options.
    if (_currentQuery != query) {
      return null;
    }
    _currentQuery = null;

    return options;
  }
}

typedef _Debounceable<S, T> = Future<S?> Function(T parameter);

/// Returns a new function that is a debounced version of the given function.
/// This means that the original function will be called only after no calls have been made for the given Duration.
_Debounceable<S, T> _debounce<S, T>(_Debounceable<S?, T> function) {
  _DebounceTimer? debounceTimer;

  return (T parameter) async {
    if (debounceTimer != null && !debounceTimer!.isCompleted) {
      debounceTimer!.cancel();
    }
    debounceTimer = _DebounceTimer();
    try {
      await debounceTimer!.future;
    } catch (error) {
      if (error is _CancelException) {
        return null;
      }
      rethrow;
    }
    return function(parameter);
  };
}

// A wrapper around Timer used for debouncing.
class _DebounceTimer {
  _DebounceTimer() {
    _timer = Timer(debounceDuration, _onComplete);
  }

  late final Timer _timer;
  final Completer<void> _completer = Completer<void>();

  void _onComplete() {
    _completer.complete();
  }

  Future<void> get future => _completer.future;

  bool get isCompleted => _completer.isCompleted;

  void cancel() {
    _timer.cancel();
    _completer.completeError(const _CancelException());
  }
}

// An exception indicating that the timer was canceled.
class _CancelException implements Exception {
  const _CancelException();
}

// An exception indicating that a network request has failed.
class NetworkException implements Exception {
  const NetworkException();
}
