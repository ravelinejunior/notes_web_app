// Mocks generated by Mockito 5.4.4 from annotations
// in notes_web_app/test/domain/provider/note_provider_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:notes_web_app/src/data/services/notes_api_service.dart' as _i3;
import 'package:notes_web_app/src/domain/model/note.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeNote_0 extends _i1.SmartFake implements _i2.Note {
  _FakeNote_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [NotesApiService].
///
/// See the documentation for Mockito's code generation for more information.
class MockNotesApiService extends _i1.Mock implements _i3.NotesApiService {
  MockNotesApiService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<List<_i2.Note>> getNotes() => (super.noSuchMethod(
        Invocation.method(
          #getNotes,
          [],
        ),
        returnValue: _i4.Future<List<_i2.Note>>.value(<_i2.Note>[]),
      ) as _i4.Future<List<_i2.Note>>);

  @override
  _i4.Future<_i2.Note> getNoteById(int? id) => (super.noSuchMethod(
        Invocation.method(
          #getNoteById,
          [id],
        ),
        returnValue: _i4.Future<_i2.Note>.value(_FakeNote_0(
          this,
          Invocation.method(
            #getNoteById,
            [id],
          ),
        )),
      ) as _i4.Future<_i2.Note>);

  @override
  _i4.Future<void> addNote(_i2.Note? note) => (super.noSuchMethod(
        Invocation.method(
          #addNote,
          [note],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> updateNote(
    int? id,
    _i2.Note? note,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateNote,
          [
            id,
            note,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> deleteNote(int? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteNote,
          [id],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}
