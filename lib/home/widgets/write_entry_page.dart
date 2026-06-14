import 'package:flutter/material.dart';
import '../../data/data.dart';
import '../../data/entry.dart';
import '../../mood/face.dart';
import '../../services/mood_service_instance.dart';
import '../../theme/app_constants.dart';

class WriteEntryPage extends StatefulWidget {
  final String tag;
  const WriteEntryPage({super.key, required this.tag});

  @override
  State<WriteEntryPage> createState() => _WriteEntryPageState();
}

class _WriteEntryPageState extends State<WriteEntryPage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _bodyFocus = FocusNode();
  DateTime _entryDate = DateTime.now();
  int _selectedMood = -1;
  TextSelection _lastBodySel = const TextSelection.collapsed(offset: 0);

  @override
  void initState() {
    super.initState();
    _entryDate = DateTime.now();
    final existing = moodService.getMoodForDate(_entryDate);
    if (existing != null) _selectedMood = existing.mood;
    // Track selection so format buttons work after focus is lost
    _bodyController.addListener(() {
      if (_bodyFocus.hasFocus) {
        _lastBodySel = _bodyController.selection;
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _bodyFocus.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    if (title.isEmpty && body.isEmpty) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    final String note;
    if (title.isNotEmpty && body.isNotEmpty) {
      note = '$title\n$body';
    } else if (title.isNotEmpty) {
      note = title;
    } else {
      note = body;
    }

    final moodIndex =
        _selectedMood >= 0 ? _selectedMood : (widget.tag == 'rant' ? 2 : 1);

    final entry = MoodEntry(
      date: _entryDate,
      mood: moodIndex,
      note: note,
      tag: widget.tag,
    );
    await moodService.saveMood(entry);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  // Wraps selected text (or inserts markers at cursor) with prefix/suffix
  void _applyInlineFormat(String prefix, String suffix) {
    final text = _bodyController.text;
    final sel = _lastBodySel;
    if (!sel.isValid) return;

    if (sel.isCollapsed) {
      final pos = sel.baseOffset.clamp(0, text.length);
      final newText =
          text.substring(0, pos) + prefix + suffix + text.substring(pos);
      _bodyController.value = _bodyController.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: pos + prefix.length),
      );
    } else {
      final start = sel.start.clamp(0, text.length);
      final end = sel.end.clamp(0, text.length);
      final selected = text.substring(start, end);
      final newText =
          text.substring(0, start) + prefix + selected + suffix + text.substring(end);
      _bodyController.value = _bodyController.value.copyWith(
        text: newText,
        selection: TextSelection(
          baseOffset: start,
          extentOffset: start + prefix.length + selected.length + suffix.length,
        ),
      );
    }
    _bodyFocus.requestFocus();
  }

  // Prepends a marker to the current line
  void _applyLinePrefix(String linePrefix) {
    final text = _bodyController.text;
    final sel = _lastBodySel;
    if (!sel.isValid) return;

    int lineStart = sel.baseOffset.clamp(0, text.length);
    while (lineStart > 0 && text[lineStart - 1] != '\n') {
      lineStart--;
    }

    final newText =
        text.substring(0, lineStart) + linePrefix + text.substring(lineStart);
    _bodyController.value = _bodyController.value.copyWith(
      text: newText,
      selection:
          TextSelection.collapsed(offset: sel.baseOffset + linePrefix.length),
    );
    _bodyFocus.requestFocus();
  }

  void _showFormatSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(Radii.card)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
              Insets.pageHorizontal, Insets.base,
              Insets.pageHorizontal, Insets.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Format',
                      style: TextStyle(
                          fontSize: FontSizes.lg,
                          fontWeight: FontWeights.bold)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(ctx).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(Insets.xs),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: FontSizes.lg),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Insets.lg),
              // Text style buttons
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(Radii.sm),
                ),
                child: Row(
                  children: [
                    _fmtBtn(ctx, label: 'B', weight: FontWeights.bold,
                        onTap: () => _applyInlineFormat('**', '**')),
                    _fmtSep(),
                    _fmtBtn(ctx, label: 'I', italic: true,
                        onTap: () => _applyInlineFormat('_', '_')),
                    _fmtSep(),
                    _fmtBtn(ctx, label: 'U', underline: true,
                        onTap: () => _applyInlineFormat('__', '__')),
                    _fmtSep(),
                    _fmtBtn(ctx, label: 'S', strikethrough: true,
                        onTap: () => _applyInlineFormat('~~', '~~')),
                  ],
                ),
              ),
              const SizedBox(height: Insets.base),
              // List / block buttons
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(Radii.sm),
                ),
                child: Row(
                  children: [
                    _fmtIconBtn(ctx, icon: Icons.format_list_bulleted,
                        onTap: () => _applyLinePrefix('• ')),
                    _fmtSep(),
                    _fmtIconBtn(ctx, icon: Icons.format_list_numbered,
                        onTap: () => _applyLinePrefix('1. ')),
                    _fmtSep(),
                    _fmtIconBtn(ctx, icon: Icons.format_indent_increase,
                        onTap: () => _applyLinePrefix('    ')),
                    _fmtSep(),
                    _fmtIconBtn(ctx, icon: Icons.format_quote,
                        onTap: () => _applyLinePrefix('> ')),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _fmtBtn(BuildContext ctx, {
    required String label,
    FontWeight? weight,
    bool italic = false,
    bool underline = false,
    bool strikethrough = false,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () { Navigator.of(ctx).pop(); onTap(); },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Insets.lg),
          child: Center(
            child: Text(label,
                style: TextStyle(
                  fontSize: FontSizes.lg,
                  fontWeight: weight ?? FontWeights.medium,
                  fontStyle: italic ? FontStyle.italic : FontStyle.normal,
                  decoration: underline
                      ? TextDecoration.underline
                      : strikethrough
                          ? TextDecoration.lineThrough
                          : null,
                )),
          ),
        ),
      ),
    );
  }

  Widget _fmtIconBtn(BuildContext ctx, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () { Navigator.of(ctx).pop(); onTap(); },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Insets.lg),
          child: Center(child: Icon(icon, size: FontSizes.xl)),
        ),
      ),
    );
  }

  Widget _fmtSep() {
    return Container(
      width: 1,
      height: Insets.xxl,
      color: Colors.grey.shade300,
    );
  }

  void _showMoodPicker() {
    int tempMood = _selectedMood;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(Radii.card)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheet) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                  Insets.pageHorizontal, Insets.base,
                  Insets.pageHorizontal, Insets.xxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('How are you feeling?',
                      style: TextStyle(
                          fontSize: FontSizes.lg,
                          fontWeight: FontWeights.bold)),
                  const SizedBox(height: Insets.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(moodLibrary.length, (i) {
                      final mood = moodLibrary[i];
                      final isSelected = tempMood == i;
                      return GestureDetector(
                        onTap: () => setSheet(() => tempMood = i),
                        child: Column(
                          children: [
                            Container(
                              width: Sizes.moodFaceMedium,
                              height: Sizes.moodFaceMedium,
                              decoration: BoxDecoration(
                                color: mood.bgColor,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(
                                        color: const Color(0xFF6C63FF),
                                        width: 2)
                                    : null,
                              ),
                              child: ClipOval(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Padding(
                                    padding: const EdgeInsets.all(Insets.lg),
                                    child: MoodFace(data: mood),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: Insets.xs),
                            Text(mood.label,
                                style: TextStyle(
                                  fontSize: FontSizes.xs,
                                  fontWeight: isSelected
                                      ? FontWeights.semibold
                                      : FontWeights.medium,
                                  color: isSelected
                                      ? const Color(0xFF6C63FF)
                                      : Colors.grey.shade600,
                                )),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: Insets.xl),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _selectedMood = tempMood);
                        Navigator.of(ctx).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: Insets.base),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Radii.card),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Done',
                          style: TextStyle(
                              fontSize: FontSizes.md,
                              fontWeight: FontWeights.semibold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(Radii.card)),
      ),
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Insets.sm),
            Container(
              width: Insets.xxl,
              height: Insets.xs,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(Radii.xs),
              ),
            ),
            const SizedBox(height: Insets.sm),
            _moreItem(
              ctx,
              icon: Icons.calendar_today_outlined,
              label: 'Entry Date',
              trailing: _formatDate(_entryDate),
              onTap: () async {
                Navigator.of(ctx).pop();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _entryDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _entryDate = picked);
              },
            ),
            Divider(
                height: 1,
                indent: Insets.pageHorizontal,
                endIndent: Insets.pageHorizontal,
                color: Colors.grey.shade200),
            _moreItem(
              ctx,
              icon: Icons.title,
              label: 'Remove Title',
              onTap: () {
                _titleController.clear();
                Navigator.of(ctx).pop();
              },
            ),
            Divider(
                height: 1,
                indent: Insets.pageHorizontal,
                endIndent: Insets.pageHorizontal,
                color: Colors.grey.shade200),
            _moreItem(
              ctx,
              icon: Icons.delete_outline,
              label: 'Delete',
              color: Colors.red,
              onTap: () {
                Navigator.of(ctx).pop();
                _confirmDelete();
              },
            ),
            SizedBox(
                height:
                    MediaQuery.of(context).padding.bottom + Insets.base),
          ],
        );
      },
    );
  }

  Widget _moreItem(BuildContext ctx, {
    required IconData icon,
    required String label,
    String? trailing,
    Color? color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black87, size: FontSizes.xl),
      title: Text(label,
          style: TextStyle(
              fontSize: FontSizes.md,
              color: color ?? Colors.black87,
              fontWeight: FontWeights.medium)),
      trailing: trailing != null
          ? Text(trailing,
              style: TextStyle(
                  fontSize: FontSizes.sm, color: Colors.grey.shade500))
          : const Icon(Icons.chevron_right, color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(
          horizontal: Insets.pageHorizontal, vertical: Insets.xs),
      onTap: onTap,
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Entry?'),
        content: const Text('This entry will be discarded.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child:
                const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: Insets.pageHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Insets.lg),
                    TextField(
                      controller: _titleController,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => _bodyFocus.requestFocus(),
                      style: const TextStyle(
                        fontSize: FontSizes.xl,
                        fontWeight: FontWeights.semibold,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(
                          fontSize: FontSizes.xl,
                          fontWeight: FontWeights.semibold,
                          color: Colors.grey.shade400,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: Insets.sm),
                    Divider(height: 1, color: Colors.grey.shade200),
                    const SizedBox(height: Insets.sm),
                    TextField(
                      controller: _bodyController,
                      focusNode: _bodyFocus,
                      autofocus: true,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(
                        fontSize: FontSizes.md,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Start writing...',
                        hintStyle: TextStyle(
                          fontSize: FontSizes.md,
                          color: Colors.grey.shade400,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Insets.base, vertical: Insets.sm),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: Sizes.moodFaceSmall,
              height: Sizes.moodFaceSmall,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chevron_left,
                  size: Sizes.navIcon, color: Colors.black87),
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(Radii.pill),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: Insets.sm, vertical: Insets.xs),
            child: Row(
              children: [
                _groupBtn(label: 'Aa', onTap: _showFormatSheet),
                const SizedBox(width: Insets.xs),
                _groupBtn(
                    icon: Icons.mood_outlined, onTap: _showMoodPicker),
                const SizedBox(width: Insets.xs),
                _groupBtn(
                    icon: Icons.more_horiz, onTap: _showMoreMenu),
              ],
            ),
          ),
          const SizedBox(width: Insets.base),
          GestureDetector(
            onTap: _save,
            child: Container(
              width: Sizes.moodFaceSmall,
              height: Sizes.moodFaceSmall,
              decoration: const BoxDecoration(
                color: Color(0xFF6C63FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check,
                  size: FontSizes.xxl, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _groupBtn({String? label, IconData? icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Insets.sm, vertical: Insets.xs),
        child: label != null
            ? Text(label,
                style: const TextStyle(
                    fontSize: FontSizes.md,
                    fontWeight: FontWeights.medium,
                    color: Colors.black54))
            : Icon(icon, size: FontSizes.xl, color: Colors.black54),
      ),
    );
  }
}
