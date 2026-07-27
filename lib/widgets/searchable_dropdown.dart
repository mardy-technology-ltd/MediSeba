import 'package:flutter/material.dart';

class SearchableDropdown<T> extends StatefulWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool isEnabled;
  final T? selectedValue;
  final List<T> items;
  final String Function(T) itemAsString;
  final void Function(T) onChanged;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const SearchableDropdown({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.isEnabled = true,
    this.selectedValue,
    required this.items,
    required this.itemAsString,
    required this.onChanged,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  void _showSelectionSheet(BuildContext context) {
    if (!widget.isEnabled || widget.isLoading) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SelectionSheet<T>(
        title: widget.label,
        items: widget.items,
        itemAsString: widget.itemAsString,
        onSelected: (val) {
          Navigator.pop(context);
          widget.onChanged(val);
        },
        errorMessage: widget.errorMessage,
        onRetry: widget.onRetry,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: widget.isEnabled ? Colors.grey.shade800 : Colors.grey.shade400,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showSelectionSheet(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: widget.isEnabled ? Colors.white : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.errorMessage != null
                    ? Colors.red.shade300
                    : (widget.isEnabled ? Colors.grey.shade300 : Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  widget.prefixIcon,
                  color: widget.isEnabled ? Colors.grey.shade600 : Colors.grey.shade400,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: widget.isLoading
                      ? Row(
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Loading...',
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          ],
                        )
                      : Text(
                          widget.selectedValue != null
                              ? widget.itemAsString(widget.selectedValue as T)
                              : widget.hintText,
                          style: TextStyle(
                            fontSize: 15,
                            color: widget.selectedValue != null
                                ? Colors.black87
                                : Colors.grey.shade500,
                          ),
                        ),
                ),
                if (widget.errorMessage != null && widget.onRetry != null && !widget.isLoading)
                  GestureDetector(
                    onTap: widget.onRetry,
                    child: const Icon(Icons.refresh, color: Colors.red),
                  )
                else
                  Icon(
                    Icons.arrow_drop_down,
                    color: widget.isEnabled ? Colors.grey.shade600 : Colors.grey.shade400,
                  ),
              ],
            ),
          ),
        ),
        if (widget.errorMessage != null && !widget.isLoading) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorMessage!,
            style: TextStyle(color: Colors.red.shade600, fontSize: 12),
          ),
        ],
      ],
    );
  }
}

class _SelectionSheet<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final String Function(T) itemAsString;
  final void Function(T) onSelected;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const _SelectionSheet({
    required this.title,
    required this.items,
    required this.itemAsString,
    required this.onSelected,
    this.errorMessage,
    this.onRetry,
  });

  @override
  State<_SelectionSheet<T>> createState() => _SelectionSheetState<T>();
}

class _SelectionSheetState<T> extends State<_SelectionSheet<T>> {
  final TextEditingController _searchController = TextEditingController();
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = widget.items.where((item) {
        return widget.itemAsString(item).toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Select ${widget.title}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Search Box
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // List or Empty/Error State
          Expanded(
            child: widget.errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(widget.errorMessage!),
                        if (widget.onRetry != null) ...[
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: widget.onRetry,
                            child: const Text('Retry'),
                          )
                        ]
                      ],
                    ),
                  )
                : _filteredItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'No ${widget.title} found',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          return ListTile(
                            title: Text(widget.itemAsString(item)),
                            onTap: () => widget.onSelected(item),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
