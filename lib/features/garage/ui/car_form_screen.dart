import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../core/di/injection.dart';
import '../../../l10n/l10n.dart';
import '../models/car_model.dart';
import '../presentation/cubit/car_form_cubit.dart';
import 'search_photos_dialog.dart';
import 'widgets/car_photo.dart';
import '../../../shared/sound_helper.dart';
import '../../../shared/error_messages.dart';

class CarFormScreen extends StatefulWidget {
  final CarModel? car;

  const CarFormScreen({super.key, this.car});

  @override
  State<CarFormScreen> createState() => _CarFormScreenState();
}

class _CarFormScreenState extends State<CarFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _brandController;
  late TextEditingController _nameController;
  late TextEditingController _toyMakerController;
  late TextEditingController _seriesController;
  late TextEditingController _purchasePriceController;
  
  final List<File> _newImages = [];
  final List<String> _remainingPhotoPaths = [];
  final List<String> _internetPhotoUrls = [];
  DateTime? _purchaseDate;
  late String _status;
  AppLocalizations get l10n => context.l10n;

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController(text: widget.car?.brand);
    _nameController = TextEditingController(text: widget.car?.modelName);
    _toyMakerController = TextEditingController(text: widget.car?.toyMaker);
    _seriesController = TextEditingController(text: widget.car?.series);
    _purchasePriceController = TextEditingController(
      text: widget.car?.purchasePrice.toString() ?? '',
    );
    
    _remainingPhotoPaths.addAll(widget.car?.photoPaths ?? []);
    if (widget.car?.photoPath != null && !_remainingPhotoPaths.contains(widget.car!.photoPath)) {
      _remainingPhotoPaths.insert(0, widget.car!.photoPath!);
    }
    
    _purchaseDate = widget.car?.purchaseDate ?? DateTime.now();
    _status = widget.car?.status ?? 'Nowy';
  }

  Future<void> _searchInternet(BuildContext context) async {
    final brand = _brandController.text.trim();
    final producer = _toyMakerController.text.trim();
    final series = _seriesController.text.trim();

    if (brand.isEmpty || producer.isEmpty || series.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1A120B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Colors.white12),
          ),
          title: Text(
            l10n.carFormSearchRequiredTitle.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            l10n.carFormSearchRequiredBody,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                l10n.closeButtonLabel.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFFFFD700),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    final query = '$producer $brand ${_nameController.text} $series 1/64'
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    
    final url = await SearchPhotosDialog.show(context, query);
    if (url != null) {
      setState(() => _internetPhotoUrls.add(url));
    }
  }


  @override
  void dispose() {
    _brandController.dispose();
    _nameController.dispose();
    _toyMakerController.dispose();
    _seriesController.dispose();
    _purchasePriceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final total = _newImages.length + _remainingPhotoPaths.length + _internetPhotoUrls.length;
    if (total >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.carFormMaxPhotos)),
      );
      return;
    }
    
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _newImages.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.carFormImageError}: $e')),
        );
      }
    }
  }


  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? DateTime.now(),
      firstDate: DateTime(1968), // Hot Wheels started in 1968
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _purchaseDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEditing = widget.car != null;
    final currencyFormat = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).languageCode == 'pl' ? 'pl_PL' : 'en_US',
      name: Localizations.localeOf(context).languageCode == 'pl' ? 'PLN' : null,
    );

    return BlocProvider(
      create: (context) => getIt<CarFormCubit>()..loadInitialData(),
      child: BlocListener<CarFormCubit, CarFormState>(
        listener: (context, state) {
          state.whenOrNull(
            success: () {
              if (!isEditing) {
                SoundHelper.playSuccessChime();
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isEditing ? l10n.carFormSuccessEdited : l10n.carFormSuccessAdded,
                  ),
                  backgroundColor: Colors.green.shade800,
                ),
              );
            },
          );
        },
        child: BlocBuilder<CarFormCubit, CarFormState>(
          builder: (context, state) {
            final isLoading = state is CarFormLoading;

            return Stack(
              children: [
                Scaffold(
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    title: Text(
                      (isEditing ? l10n.carFormEditTitle : l10n.carFormAddTitle).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                        letterSpacing: 4,
                        fontSize: 14,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  body: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/add_model_bg.png',
                        ),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          const Color(0xFF1A120B).withValues(alpha: 0.75),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: SafeArea(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                _MultiPhotoPicker(
                                  newImages: _newImages,
                                  remainingPaths: _remainingPhotoPaths,
                                  internetUrls: _internetPhotoUrls,
                                  onAdd: (source) => _pickImage(source),
                                  onRemoveNew: (i) => setState(() => _newImages.removeAt(i)),
                                  onRemoveExisting: (p) => setState(() => _remainingPhotoPaths.remove(p)),
                                  onRemoveInternet: (u) => setState(() => _internetPhotoUrls.remove(u)),
                                  onSearchOnline: () => _searchInternet(context),
                                ),
                              const SizedBox(height: 32),
                              
                              _GlassInput(
                                controller: _brandController,
                                label: '${l10n.carBrandLabel} / MODEL',
                                hint: l10n.carFormBrandPlaceholder,
                                validator: (v) => v!.isEmpty ? '...' : null,
                              ),
                              const SizedBox(height: 16),

                              _ProducerSelector(
                                controller: _toyMakerController,
                                label: l10n.carProducerLabel,
                                dynamicProducers: state.maybeWhen(
                                  initial: (p, s) => p,
                                  loading: (p, s) => p,
                                  error: (e, p, s) => p,
                                  orElse: () => [],
                                ),
                                onChanged: (v) => setState(() {}),
                              ),
                              const SizedBox(height: 16),

                              _SeriesSelector(
                                controller: _seriesController,
                                label: l10n.carSeriesLabel,
                                dynamicSeries: state.maybeWhen(
                                  initial: (p, s) => s,
                                  loading: (p, s) => s,
                                  error: (e, p, s) => s,
                                  orElse: () => [],
                                ),
                                onChanged: (v) => setState(() {}),
                              ),
                              const SizedBox(height: 16),

                              _DatePickerButton(
                                label: l10n.carPurchaseDateLabel,
                                date: _purchaseDate,
                                onTap: () => _selectDate(context),
                              ),
                              const SizedBox(height: 16),

                              _GlassInput(
                                controller: _purchasePriceController,
                                label: '${l10n.carPurchasePriceLabel} (${currencyFormat.currencySymbol})',
                                keyboardType: TextInputType.number,
                                validator: (v) => double.tryParse(v ?? '') == null ? '?' : null,
                              ),
                              const SizedBox(height: 16),

                              _StatusInput(
                                label: l10n.carFormConditionLabel,
                                selectedStatus: _status,
                                onChanged: (v) => setState(() => _status = v),
                              ),
                              
                               if (state is CarFormError) ...[
                                const SizedBox(height: 24),
                                Text(
                                  messageForErrorKey(l10n, state.errorKey),
                                  style: const TextStyle(color: Colors.redAccent),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                              const SizedBox(height: 48),
                              _SaveButton(
                                label: l10n.carFormSaveButton,
                                onPressed: isLoading ? null : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<CarFormCubit>().saveCar(
                                      existingCar: widget.car,
                                      brand: _brandController.text,
                                      modelName: _nameController.text, // For now split logic or join later
                                      toyMaker: _toyMakerController.text,
                                      series: _seriesController.text.isEmpty ? null : _seriesController.text,
                                      purchaseDate: _purchaseDate,
                                      purchasePrice: double.parse(_purchasePriceController.text),
                                      status: _status,
                                      newPhotos: _newImages,
                                      photoUrls: _internetPhotoUrls,
                                      remainingPhotoPaths: _remainingPhotoPaths,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isLoading)
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: Colors.black45,
                        child: const Center(
                          child: CircularProgressIndicator(color: Color(0xFFFFD700)),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MultiPhotoPicker extends StatelessWidget {
  final List<File> newImages;
  final List<String> remainingPaths;
  final List<String> internetUrls;
  final Function(ImageSource) onAdd;
  final Function(int) onRemoveNew;
  final Function(String) onRemoveExisting;
  final Function(String) onRemoveInternet;
  final VoidCallback onSearchOnline;

  const _MultiPhotoPicker({
    required this.newImages,
    required this.remainingPaths,
    required this.internetUrls,
    required this.onAdd,
    required this.onRemoveNew,
    required this.onRemoveExisting,
    required this.onRemoveInternet,
    required this.onSearchOnline,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final total = newImages.length + remainingPaths.length + internetUrls.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Text(
                l10n.carGalleryLabel.toUpperCase(),
                style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w900),
              ),
              const Spacer(),
              Text(
                '$total / 5',
                style: const TextStyle(color: Colors.white60, fontSize: 10),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              if (total < 5)
                _AddPhotoBox(onTap: () => onAdd(ImageSource.camera), label: l10n.carGalleryCameraLabel),
              if (total < 5)
                _AddPhotoBox(onTap: () => onAdd(ImageSource.gallery), label: l10n.carGalleryGalleryLabel, icon: Icons.photo_library_outlined),
              if (total < 5)
                _AddPhotoBox(onTap: onSearchOnline, label: l10n.carGalleryInternetLabel, icon: Icons.public),
              
              ...newImages.asMap().entries.map((e) => _Thumbnail(
                image: e.value,
                onRemove: () => onRemoveNew(e.key),
              )),
              
              ...remainingPaths.map((p) => _Thumbnail(
                path: p,
                onRemove: () => onRemoveExisting(p),
              )),

              ...internetUrls.map((u) => _Thumbnail(
                url: u,
                onRemove: () => onRemoveInternet(u),
              )),
            ],
          ),
        ),
      ],
    );
  }
}

class _AddPhotoBox extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final IconData icon;

  const _AddPhotoBox({
    required this.onTap,
    required this.label,
    this.icon = Icons.camera_alt_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFFFD700), size: 24),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.white60, fontSize: 8, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final File? image;
  final String? path;
  final String? url;
  final VoidCallback onRemove;

  const _Thumbnail({this.image, this.path, this.url, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _buildImage(),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                child: const Icon(Icons.close, color: Colors.white, size: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (image != null) return Image.file(image!, fit: BoxFit.cover);
    if (url != null) {
      return CarPhoto(path: url!, fit: BoxFit.cover);
    }
    return CarPhoto(path: path!, fit: BoxFit.cover);
  }
}

class _ProducerSelector extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final List<String> dynamicProducers;
  final ValueChanged<String> onChanged;

  const _ProducerSelector({
    required this.controller,
    required this.label,
    required this.dynamicProducers,
    required this.onChanged,
  });

  static const _fixedProducers = [
    'Hot Wheels',
    'Matchbox',
    'Majorette',
    'Mini GT',
    'Tomica',
    'Maisto',
    'Jada',
  ];

  @override
  Widget build(BuildContext context) {
    final current = controller.text;
    final isKnown = _fixedProducers.contains(current) || dynamicProducers.contains(current);
    final isCustom = current.isNotEmpty && !isKnown;
    
    final Set<String> itemsSet = {..._fixedProducers, ...dynamicProducers};
    if (isCustom) {
      itemsSet.add(current);
    }
    final List<String> items = itemsSet.toList()..sort();
    items.add(context.l10n.commonOther);

    return _GlassDropdown<String>(
      label: label,
      value: current.isEmpty ? null : (items.contains(current) ? current : null),
      items: items.map((s) => DropdownMenuItem(
        value: s,
        child: Text(s.toUpperCase(), style: const TextStyle(fontSize: 12)),
      )).toList(),
      onChanged: (val) async {
        if (val == context.l10n.commonOther) {
          final result = await _showCustomProducerDialog(context, current);
          if (result != null && result.isNotEmpty) {
            controller.text = result;
            onChanged(result);
          }
        } else if (val != null) {
          controller.text = val;
          onChanged(val);
        }
      },
    );
  }

  Future<String?> _showCustomProducerDialog(BuildContext context, String current) async {
    final l10n = context.l10n;
    final textController = TextEditingController(text: current);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A120B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: const BorderSide(color: Colors.white12)),
        title: Text(l10n.carFormProducerDialogTitle, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
        content: TextField(
          controller: textController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: l10n.carFormProducerPlaceholder,
            hintStyle: const TextStyle(color: Colors.white54),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white12)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFFD700))),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButtonLabel.toUpperCase(), style: const TextStyle(color: Colors.white60)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, textController.text),
            child: Text(l10n.carFormSaveButton.toUpperCase(), style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
class _SeriesSelector extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final List<String> dynamicSeries;
  final ValueChanged<String> onChanged;

  const _SeriesSelector({
    required this.controller,
    required this.label,
    required this.dynamicSeries,
    required this.onChanged,
  });

  static const _fixedOptions = [
    'Main',
    'Silver series',
    'Premium',
    'Boulevard',
    'TH',
    'STH',
    'RLC',
  ];

  @override
  Widget build(BuildContext context) {
    final current = controller.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _showSeriesBottomSheet(context),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        current.isNotEmpty ? current.toUpperCase() : "WYBIERZ SERIĘ...",
                        style: TextStyle(
                          color: current.isNotEmpty ? Colors.white : Colors.white54,
                          fontSize: 15,
                          fontWeight: current.isNotEmpty ? FontWeight.w600 : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down, color: Color(0xFFFFD700)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSeriesBottomSheet(BuildContext context) {
    final current = controller.text;
    final isKnown = _fixedOptions.contains(current) || dynamicSeries.contains(current);
    final isCustom = current.isNotEmpty && !isKnown;
    
    final Set<String> itemsSet = {..._fixedOptions, ...dynamicSeries};
    if (isCustom) {
      itemsSet.add(current);
    }
    final List<String> items = itemsSet.toList()..sort();
    final l10n = context.l10n;

    showModalBottomSheet(
      context: context,
      enableDrag: false,
      backgroundColor: const Color(0xFF1A120B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Przytrzymaj serię dłużej, aby ją usunąć",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length + 1,
                    itemBuilder: (ctx, index) {
                      if (index == items.length) {
                        return ListTile(
                          title: Text(
                            l10n.commonOther.toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFFFFD700),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          trailing: const Icon(Icons.add, color: Color(0xFFFFD700)),
                          onTap: () async {
                            Navigator.pop(bottomSheetContext);
                            final result = await _showCustomSeriesDialog(context, current);
                            if (result != null && result.isNotEmpty) {
                              controller.text = result;
                              onChanged(result);
                            }
                          },
                        );
                      }

                      final s = items[index];
                      final isFixed = _fixedOptions.contains(s);
                      final isSelected = current == s;

                      return ListTile(
                        title: Text(
                          s.toUpperCase(),
                          style: TextStyle(
                            color: isSelected ? const Color(0xFFFFD700) : Colors.white,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                        trailing: isSelected ? const Icon(Icons.check, color: Color(0xFFFFD700)) : null,
                        onTap: () {
                          Navigator.pop(bottomSheetContext);
                          controller.text = s;
                          onChanged(s);
                        },
                        onLongPress: isFixed ? null : () async {
                          Navigator.pop(bottomSheetContext);
                          final confirm = await _showDeleteSeriesConfirmDialog(context, s);
                          if (confirm == true && context.mounted) {
                            context.read<CarFormCubit>().deleteSeries(s);
                            if (current == s) {
                              controller.clear();
                              onChanged('');
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _showDeleteSeriesConfirmDialog(BuildContext context, String name) {
    final l10n = context.l10n;
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1A120B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Colors.white12),
        ),
        title: Text(
          l10n.carFormSeriesDeleteConfirmTitle.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        content: Text(
          '${l10n.carFormSeriesDeleteConfirmBody}\n\nSeria: $name',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              l10n.cancelButtonLabel.toUpperCase(),
              style: const TextStyle(color: Colors.white60),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              l10n.deleteAccountConfirmButtonLabel.toUpperCase(),
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _showCustomSeriesDialog(BuildContext context, String current) async {
    final l10n = context.l10n;
    final textController = TextEditingController(text: current);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A120B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: const BorderSide(color: Colors.white12)),
        title: Text(l10n.carFormSeriesDialogTitle, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
        content: TextField(
          controller: textController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: l10n.carFormSeriesPlaceholder,
            hintStyle: const TextStyle(color: Colors.white54),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white12)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFFD700))),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButtonLabel.toUpperCase(), style: const TextStyle(color: Colors.white60)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, textController.text),
            child: Text(l10n.carFormSaveButton.toUpperCase(), style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _StatusInput extends StatelessWidget {
  final String label;
  final String selectedStatus;
  final ValueChanged<String> onChanged;

  const _StatusInput({
    required this.label,
    required this.selectedStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    
    // Status list is internally snake_case or specific Polish words from legacy
    // To maintain compatibility, we keep the internal values but localize the display
    final Map<String, String> statusMap = {
      'Nowy': l10n.carConditionNew,
      'Idealny': l10n.carConditionMint,
      'Dobry': l10n.carConditionGood,
      'Lekko uszkodzony': l10n.carConditionFair,
      'Uszkodzony': l10n.carConditionPoor,
      'Luzak (bez opakowania)': l10n.carConditionLoose,
      'Inne': l10n.carConditionOther,
    };

    return _GlassDropdown<String>(
      label: label,
      value: statusMap.containsKey(selectedStatus) ? selectedStatus : 'Inne',
      items: statusMap.entries.map((e) => DropdownMenuItem(
        value: e.key,
        child: Text(e.value.toUpperCase(), style: const TextStyle(fontSize: 12)),
      )).toList(),
      onChanged: (val) {
        if (val != null) onChanged(val);
      },
    );
  }
}

class _GlassDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _GlassDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: onChanged,
              dropdownColor: const Color(0xFF2D1B0D),
              borderRadius: BorderRadius.circular(16),
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFFFD700)),
              isExpanded: true,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

class _DatePickerButton extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _DatePickerButton({required this.label, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateStr = date != null ? DateFormat('dd / MM / yyyy').format(date!) : '...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, color: Color(0xFFFFD700), size: 18),
                    const SizedBox(width: 12),
                    Text(dateStr, style: const TextStyle(color: Colors.white, fontSize: 15)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  const _GlassInput({
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5),
          ),
        ),
        _GlassInputBase(
          controller: controller,
          hint: hint,
          keyboardType: keyboardType,
          validator: validator,
        ),
      ],
    );
  }
}

class _GlassInputBase extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  const _GlassInputBase({
    required this.controller,
    this.hint,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white54, fontSize: 13),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.white12)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.white12)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFFFD700), width: 0.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ),
    );
   }
}

class _SaveButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _SaveButton({required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD700),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
      ),
    );
  }
}


