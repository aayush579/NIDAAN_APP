import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class MapSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback onFilterTap;

  const MapSearchBar({
    super.key,
    required this.onSearch,
    required this.onFilterTap,
  });

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isSearchActive = false;

  final List<String> _recentSearches = [
    'Downtown Park',
    'Main Street',
    'City Hall',
    'Community Center',
    'Public Library'
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isSearchActive = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.1),
                offset: const Offset(0, 2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  onChanged: widget.onSearch,
                  decoration: InputDecoration(
                    hintText: 'Search location...',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'search',
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 20,
                      ),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              widget.onSearch('');
                            },
                            icon: CustomIconWidget(
                              iconName: 'clear',
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              size: 20,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                  ),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              Container(
                width: 1,
                height: 6.h,
                color: theme.dividerColor,
              ),
              InkWell(
                onTap: widget.onFilterTap,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'filter_list',
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_isSearchActive && _recentSearches.isNotEmpty)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Text(
                    'Recent Searches',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recentSearches.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: theme.dividerColor,
                  ),
                  itemBuilder: (context, index) {
                    final search = _recentSearches[index];
                    return ListTile(
                      leading: CustomIconWidget(
                        iconName: 'history',
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 20,
                      ),
                      title: Text(
                        search,
                        style: theme.textTheme.bodyMedium,
                      ),
                      onTap: () {
                        _searchController.text = search;
                        widget.onSearch(search);
                        _focusNode.unfocus();
                      },
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            _recentSearches.removeAt(index);
                          });
                        },
                        icon: CustomIconWidget(
                          iconName: 'close',
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.4),
                          size: 16,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
