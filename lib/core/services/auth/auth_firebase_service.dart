import 'dart:io';
import 'dart:async';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth.service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthFirebaseService implements AuthService {
  static ChatUser? _currentUser;
  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toChatUser(user);
      controller.add(_currentUser);
    }
  });

  @override
  ChatUser? get currentUser {
    return _currentUser;
  }

  @override
  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  @override
  Future<void> signup(
      String name, String email, String password, File? image) async {
    final signup = await Firebase.initializeApp(
      name: 'userSignup',
      options: Firebase.app().options,
    );

    final auth = FirebaseAuth.instanceFor(app: signup);

    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user != null) {
      // 1. Upload da foto do usuário
      final imageName = '${credential.user!.uid}.jpg';
      final imageUrl = await _uploadUserImage(image, imageName);

      // 2. atualizar os atributos do usuário
      await credential.user?.updateDisplayName(name);
      await credential.user?.updatePhotoURL(imageUrl);

      // 2.5 fazer o login do usuário
      await login(email, password);

      // 3. salvar usuário no banco de dados (opcional)
      _currentUser = _toChatUser(credential.user!, name, imageUrl);
      await _saveChatUser(_currentUser!);
    }

    await signup.delete();
  }

  @override
  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  Future<String> _uploadUserImage(File? image, String imageName) async {
    try {
      // Acessar instância do Firebase Storage
      final FirebaseStorage storage =
          FirebaseStorage.instanceFor(bucket: 'chat0-8942b.appspot.com');

      // Criar referência para a pasta "user_images" (ou a pasta desejada)
      final storageRef = storage.ref().child('user_images');

      // Gerar nome de arquivo único usando o último componente do caminho de imageName
      final uniqueFilename = imageName.split('/').last;

      // Criar referência para o caminho do arquivo único
      final imageRef = storageRef.child(uniqueFilename);

      // Fazer upload da imagem com tratamento de erro robusto
      final uploadTask = imageRef.putFile(image!);

      // Monitorar progresso do upload (opcional)
      final snapshot = await uploadTask
          .asStream()
          .firstWhere((event) => event.bytesTransferred == event.totalBytes);

      // Obter URL de download após upload bem-sucedido
      return await snapshot.ref.getDownloadURL();
    } on FirebaseException {
      // Tratar erros específicos do Firebase
      rethrow; // Repassar a exceção para tratamento posterior
    } catch (e) {
      // Tratar outros erros potenciais
      rethrow; // Repassar a exceção para permitir gerenciamento adequado de erros
    }
  }

  Future<void> _saveChatUser(ChatUser user) async {
    final store = FirebaseFirestore.instance;
    final docRef = store.collection('users').doc(user.id);

    return docRef.set({
      'name': user.name,
      'email': user.email,
      'imageUrl': user.imageURL,
    });
  }

  static ChatUser _toChatUser(User user, [String? name, String? imageUrl]) {
    return ChatUser(
      id: user.uid,
      name: name ?? user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageURL: imageUrl ?? user.photoURL ?? 'assets/images/avatar.png',
    );
  }
}
