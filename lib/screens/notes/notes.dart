import 'package:escooter_notes_app/managers/navigator/named_navigator.dart';
import 'package:escooter_notes_app/managers/navigator/named_navigator_implementation.dart';
import 'package:escooter_notes_app/screens/common/e_notes_common.dart';
import 'package:escooter_notes_app/utils/constants/text_strings.dart';
import 'package:escooter_notes_app/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../view_models/notes/notes_provider.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesProvider>().loadNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = context.watch<NotesProvider>();
    final notes = notesProvider.notes;

    return ENotesCommon(
      appBarTitle: ETexts.notes,
      screenContent: notes.isEmpty
          ? RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.background,
              onRefresh: () => context.read<NotesProvider>().loadNotes(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: Text("No notes yet",
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.background,
              onRefresh: () => context.read<NotesProvider>().loadNotes(),
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Dismissible(
                    key: ValueKey(note.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      context.read<NotesProvider>().removeNote(note.id);
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                      child: Material(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(8.r),
                        elevation: 2,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          title: Text(
                            note.title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.white),
                          ),
                          subtitle: Text(
                            note.body,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.white70),
                          ),
                          onTap: () {
                            NamedNavigatorImpl().push(
                              Routes.NOTE_DETAILS
                                  .replaceFirst(':noteId', note.id),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.0.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0.h),
              child: GestureDetector(
                onTap: () {
                  NamedNavigatorImpl().push(
                    Routes.NOTE_DETAILS.replaceFirst(':noteId', "new"),
                  );
                },
                child:
                    Icon(Iconsax.edit, color: AppColors.primary, size: 25.sp),
              ),
            )
          ],
        ),
      ),
    );
  }
}
