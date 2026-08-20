import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:river_blog/core/base/base_events.dart';
import 'package:river_blog/modules/app/events/loading_events.dart';
import 'package:river_blog/modules/app/widgets/loading/loading_overlay_widget.dart';
import 'package:river_blog/shared/providers.dart';

class LoadingWidget extends ConsumerStatefulWidget {
  final Widget child;

  const new({
    required this.child,
    super.key,
  });

  @override
  ConsumerState<LoadingWidget> createState() => _LoadingHostState();
}

class _LoadingHostState extends ConsumerState<LoadingWidget> {
  bool _isLoading = false;
  String? _description;

  late final StreamSubscription<BaseEvent> _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = ref.read(eventBusProvider)
      .on<BaseEvent>()
      .listen(_onEvent);
  }

  @override
  void dispose() {
    _subscription.cancel().ignore();

    super.dispose();
  }

  void _onEvent(BaseEvent event) {
    if (event is LoadingStartedEvent) {
      setState(() {
        _isLoading = true;
        _description = null;
      });
      return;
    }

    if (event is LoadingProgressEvent) {
      setState(() => _description = event.message);
      return;
    }

    if (event is LoadingFinishedEvent) {
      setState(() {
        _isLoading = false;
        _description = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayWidget(
      isLoading: _isLoading,
      description: _description,
      child: widget.child,
    );
  }
}
