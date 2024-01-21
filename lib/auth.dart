// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

/// A mock authentication service.
class DaangnAuth extends ChangeNotifier {
  bool _signedIn = false;

  /// Whether user has signed in.
  bool get signedIn => _signedIn;

  /// Signs out the current user.
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // Sign out.
    _signedIn = false;
    notifyListeners();
  }

  /// Signs in a user.
  Future<bool> signIn(String username, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // Sign in. Allow any password.
    _signedIn = true;
    notifyListeners();
    return _signedIn;
  }
}

/// An inherited notifier to host [DaangnAuth] for the subtree.
class DaangnAuthScope extends InheritedNotifier<DaangnAuth> {
  /// Creates a [DaangnAuthScope].
  const DaangnAuthScope({
    required DaangnAuth super.notifier,
    required super.child,
    super.key,
  });

  /// Gets the [DaangnAuth] above the context.
  static DaangnAuth of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<DaangnAuthScope>()!
      .notifier!;
}