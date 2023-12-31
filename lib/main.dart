import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crush_client/repositories/repositories.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'app/app.dart';
import 'app/app_bloc_observer.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestoreRepository = FirestoreRepository(
    firebaseFirestore: FirebaseFirestore.instance,
  );
  final authenticationRepository = AuthenticationRepository(
    firebaseAuth: FirebaseAuth.instance,
    googleSignIn: GoogleSignIn(),
    firestoreRepository: firestoreRepository,
  );
  final coordiRepository = CoordiRepository(
    firebaseStorage: FirebaseStorage.instance,
    firebaseFirestore: FirebaseFirestore.instance,
  );

  runZonedGuarded(
    () => runApp(
      App(
        authenticationRepository: authenticationRepository,
        firestoreRepository: firestoreRepository,
        coordiRepository: coordiRepository,
      ),
    ),
    (error, stackTrace) {
      print(error);
      print(stackTrace);
    },
  );
}
