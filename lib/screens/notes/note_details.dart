import 'package:escooter_notes_app/screens/common/e_notes_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/security.dart';
import '../../managers/caching/cashing_key.dart';
import '../../models/notes_model.dart';
import '../../view_models/notes/notes_provider.dart';

class NoteDetails extends StatefulWidget {
  final String? noteId;

  const NoteDetails({super.key, this.noteId});

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  final TextEditingController _controller = TextEditingController();

  bool _hasSaved = false;

  Future<void> _handleBackNavigation(BuildContext context) async {
    if (_hasSaved) return; // prevent double execution
    _hasSaved = true;

    final fullText = _controller.text.trim();
    if (fullText.isEmpty) return;

    final lines = fullText.split('\n');
    final title = lines.isNotEmpty ? lines.first.trim() : '';
    final body = lines.length > 1 ? lines.sublist(1).join('\n').trim() : '';

    final userId =
        await SecureStorage().readSecureData(CachingKey.USER_ID.value);

    final note = Note.createNew(
      title: title,
      body: body,
      userId: userId,
    );

    debugPrint('📝 Note saved: $note');

    if (context.mounted) {
      final provider = context.read<NotesProvider>();
      provider.addNote(note);
      await provider.syncNotesWithDatabase();
    }

    if (context.mounted) Navigator.of(context).pop(note);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        if (!_hasSaved) {
          await _handleBackNavigation(context);
        }
      },
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: const TextSelectionThemeData(
            selectionColor: Color.fromARGB(180, 158, 158, 158),
          ),
        ),
        child: ENotesCommon(
          appBarIconButton: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.of(context).maybePop()),
          screenContent: SafeArea(
              child: Stack(
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  cursorColor: Colors.white,
                  cursorWidth: 2,
                  cursorHeight:
                      Theme.of(context).textTheme.displayMedium?.fontSize ??
                          25.sp,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        height: 1.2,
                        fontFamily: '',
                        decoration: TextDecoration.none,
                        decorationThickness: 0,
                      ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
