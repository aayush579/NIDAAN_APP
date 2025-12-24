import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CommentsSection extends StatefulWidget {
  final List<Map<String, dynamic>> comments;

  const CommentsSection({
    super.key,
    required this.comments,
  });

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  bool _isExpanded = false;

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppTheme.shadowDark : AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'comment',
                size: 20,
                color: AppTheme.lightTheme.primaryColor,
              ),
              SizedBox(width: 2.w),
              Text(
                'Comments',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${widget.comments.length}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Add Comment Field
          _buildAddCommentField(context),

          SizedBox(height: 3.h),

          // Comments List
          if (widget.comments.isNotEmpty)
            ...widget.comments
                .map((comment) => _buildCommentItem(context, comment))
                .toList()
          else
            _buildEmptyCommentsState(context),
        ],
      ),
    );
  }

  Widget _buildAddCommentField(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: _isExpanded
              ? AppTheme.lightTheme.primaryColor
              : theme.colorScheme.onSurface.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          TextField(
            controller: _commentController,
            focusNode: _commentFocusNode,
            onTap: () {
              setState(() {
                _isExpanded = true;
              });
            },
            maxLines: _isExpanded ? 4 : 1,
            decoration: InputDecoration(
              hintText: 'Add a comment...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(3.w),
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            style: theme.textTheme.bodyMedium,
          ),
          if (_isExpanded)
            Container(
              padding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 2.h),
              child: Row(
                children: [
                  Text(
                    '${_commentController.text.length}/500',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = false;
                        _commentController.clear();
                      });
                      _commentFocusNode.unfocus();
                    },
                    child: Text(
                      'Cancel',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  ElevatedButton(
                    onPressed: _commentController.text.trim().isNotEmpty
                        ? () => _submitComment()
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Post',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(BuildContext context, Map<String, dynamic> comment) {
    final theme = Theme.of(context);
    final userName = (comment["userName"] as String?) ?? "Anonymous User";
    final userAvatar = (comment["userAvatar"] as String?) ??
        "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png";
    final content = (comment["content"] as String?) ?? "";
    final timestamp = (comment["timestamp"] as DateTime?) ?? DateTime.now();
    final likes = (comment["likes"] as int?) ?? 0;
    final dislikes = (comment["dislikes"] as int?) ?? 0;
    final isLiked = (comment["isLiked"] as bool?) ?? false;
    final isDisliked = (comment["isDisliked"] as bool?) ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Row
          Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: userAvatar,
                    width: 10.w,
                    height: 10.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _formatCommentTimestamp(timestamp),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),

              // More Options
              GestureDetector(
                onTap: () => _showCommentOptions(context, comment),
                child: CustomIconWidget(
                  iconName: 'more_vert',
                  size: 20,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Comment Content
          Padding(
            padding: EdgeInsets.only(left: 13.w),
            child: Text(
              content,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.4,
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Action Buttons
          Padding(
            padding: EdgeInsets.only(left: 13.w),
            child: Row(
              children: [
                _buildActionButton(
                  context,
                  isLiked ? 'thumb_up' : 'thumb_up_outlined',
                  '$likes',
                  isLiked ? AppTheme.lightTheme.primaryColor : null,
                  () => _toggleLike(comment),
                ),
                SizedBox(width: 4.w),
                _buildActionButton(
                  context,
                  isDisliked ? 'thumb_down' : 'thumb_down_outlined',
                  '$dislikes',
                  isDisliked ? Colors.red : null,
                  () => _toggleDislike(comment),
                ),
                SizedBox(width: 4.w),
                _buildActionButton(
                  context,
                  'reply',
                  'Reply',
                  null,
                  () => _replyToComment(comment),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String iconName, String label,
      Color? activeColor, VoidCallback onPressed) {
    final theme = Theme.of(context);
    final color =
        activeColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: iconName,
            size: 16,
            color: color,
          ),
          SizedBox(width: 1.w),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight:
                  activeColor != null ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCommentsState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(6.w),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'chat_bubble_outline',
            size: 48,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          SizedBox(height: 2.h),
          Text(
            'No comments yet',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Be the first to share your thoughts on this issue',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _submitComment() {
    if (_commentController.text.trim().isNotEmpty) {
      // Handle comment submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Comment posted successfully'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

      setState(() {
        _isExpanded = false;
        _commentController.clear();
      });
      _commentFocusNode.unfocus();
    }
  }

  void _toggleLike(Map<String, dynamic> comment) {
    // Handle like toggle
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(comment["isLiked"] == true ? 'Like removed' : 'Comment liked'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _toggleDislike(Map<String, dynamic> comment) {
    // Handle dislike toggle
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(comment["isDisliked"] == true
            ? 'Dislike removed'
            : 'Comment disliked'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _replyToComment(Map<String, dynamic> comment) {
    // Handle reply to comment
    _commentController.text = '@${comment["userName"]} ';
    _commentFocusNode.requestFocus();
    setState(() {
      _isExpanded = true;
    });
  }

  void _showCommentOptions(BuildContext context, Map<String, dynamic> comment) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'flag', size: 24, color: Colors.red),
              title: const Text('Report Comment'),
              onTap: () {
                Navigator.pop(context);
                _reportComment(comment);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'block', size: 24, color: Colors.orange),
              title: const Text('Block User'),
              onTap: () {
                Navigator.pop(context);
                _blockUser(comment);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _reportComment(Map<String, dynamic> comment) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comment reported successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _blockUser(Map<String, dynamic> comment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User ${comment["userName"]} blocked'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatCommentTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
