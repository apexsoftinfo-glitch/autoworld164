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
  late TextEditingController _estimatedValueController;
  
  final List<File> _newImages = [];
  final List<String> _remainingPhotoPaths = [];
  final List<String> _internetPhotoUrls = [];
  DateTime? _purchaseDate;

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
    _estimatedValueController = TextEditingController(
      text: widget.car?.estimatedValue.toString() ?? '',
    );
    
    _remainingPhotoPaths.addAll(widget.car?.photoPaths ?? []);
    if (widget.car?.photoPath != null && !_remainingPhotoPaths.contains(widget.car!.photoPath)) {
      _remainingPhotoPaths.insert(0, widget.car!.photoPath!);
    }
    
    _purchaseDate = widget.car?.purchaseDate ?? DateTime.now();
  }

  Future<void> _searchInternet(BuildContext context) async {
    final query = '${_toyMakerController.text} ${_brandController.text} ${_nameController.text} ${_seriesController.text} 1/64'
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (query.isEmpty) return;
    
    final url = await SearchPhotosDialog.show(context, query);
    if (url != null) {
      setState(() => _internetPhotoUrls.add(url));
    }
  }

  Future<void> _aiEstimate(BuildContext context, CarFormCubit cubit) async {
    final query = '${_brandController.text} ${_nameController.text} ${_seriesController.text}'
        .trim();
    if (query.isEmpty) return;
    
    final value = await cubit.estimateValue(query);
    if (value != null) {
      _estimatedValueController.text = value.toStringAsFixed(2);
    }
  }


  @override
  void dispose() {
    _brandController.dispose();
    _nameController.dispose();
    _toyMakerController.dispose();
    _seriesController.dispose();
    _purchasePriceController.dispose();
    _estimatedValueController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final total = _newImages.length + _remainingPhotoPaths.length + _internetPhotoUrls.length;
    if (total >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maksymalnie 5 zdjęć')),
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
          SnackBar(content: Text('Błąd podczas otwierania galerii/aparatu: $e')),
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
            final availableSeries = state is CarFormInitial ? state.availableSeries : <String>[];

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
                        image: const AssetImage('assets/images/warm_garage.png'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          const Color(0xFF2D1B0D).withValues(alpha: 0.7),
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
                                hint: 'np. Porsche 911 GT3',
                                validator: (v) => v!.isEmpty ? '...' : null,
                              ),
                              const SizedBox(height: 16),

                              _ProducerInput(
                                controller: _toyMakerController,
                                label: l10n.carProducerLabel,
                                onChanged: (v) => setState(() {}),
                              ),
                              const SizedBox(height: 16),

                              _SeriesAutocomplete(
                                controller: _seriesController,
                                label: l10n.carSeriesLabel,
                                options: availableSeries,
                              ),
                              const SizedBox(height: 16),

                              _DatePickerButton(
                                label: l10n.carPurchaseDateLabel,
                                date: _purchaseDate,
                                onTap: () => _selectDate(context),
                              ),
                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  Expanded(
                                    child: _GlassInput(
                                      controller: _purchasePriceController,
                                      label: '${l10n.carPurchasePriceLabel} (${currencyFormat.currencySymbol})',
                                      keyboardType: TextInputType.number,
                                      validator: (v) => double.tryParse(v ?? '') == null ? '?' : null,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _GlassInput(
                                      controller: _estimatedValueController,
                                      label: '${l10n.carEstimatedValueLabel} (${currencyFormat.currencySymbol})',
                                      keyboardType: TextInputType.number,
                                      suffix: IconButton(
                                        icon: const Icon(Icons.auto_fix_high, color: Color(0xFFFFD700), size: 18),
                                        onPressed: () => _aiEstimate(context, context.read<CarFormCubit>()),
                                      ),
                                      validator: (v) => double.tryParse(v ?? '') == null ? '?' : null,
                                    ),
                                  ),
                                ],
                              ),
                              
                              if (state is CarFormError) ...[
                                const SizedBox(height: 24),
                                Text(
                                  state.errorKey,
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
                                      estimatedValue: double.parse(_estimatedValueController.text),
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
                style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w900),
              ),
              const Spacer(),
              Text(
                '$total / 5',
                style: const TextStyle(color: Colors.white38, fontSize: 10),
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
                _AddPhotoBox(onTap: () => onAdd(ImageSource.camera), label: 'APARAT'),
              if (total < 5)
                _AddPhotoBox(onTap: () => onAdd(ImageSource.gallery), label: 'GALERIA', icon: Icons.photo_library_outlined),
              if (total < 5)
                _AddPhotoBox(onTap: onSearchOnline, label: 'INTERNET', icon: Icons.public),
              
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
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.w900)),
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

class _ProducerInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final ValueChanged<String> onChanged;

  const _ProducerInput({
    required this.controller,
    required this.label,
    required this.onChanged,
  });

  static const _producers = [
    ('Hot Wheels', 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/de/Hot_Wheels_logo.svg/512px-Hot_Wheels_logo.svg.png'),
    ('Matchbox', 'https://upload.wikimedia.org/wikipedia/en/thumb/f/f6/Matchbox_Logo.svg/512px-Matchbox_Logo.svg.png'),
    ('Majorette', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Majorette_logo.svg/512px-Majorette_logo.svg.png'),
    ('Mini GT', 'https://minigt.com/assets/images/logo.png'),
    ('Tomica', 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Tomica_logo.svg/512px-Tomica_logo.svg.png'),
    ('Maisto', 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Maisto_logo.svg/512px-Maisto_logo.svg.png'),
    ('Jada', 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Jada_Toys_logo.svg/512px-Jada_Toys_logo.svg.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.5),
          ),
        ),
        SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: _producers.length + 1,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == _producers.length) {
                return _InnyProducerBox(
                  controller: controller,
                  onChanged: onChanged,
                );
              }

              final p = _producers[index];
              final isSelected = controller.text == p.$1;

              return _ProducerLogoBox(
                logoUrl: p.$2,
                name: p.$1,
                isSelected: isSelected,
                onTap: () {
                  controller.text = p.$1;
                  onChanged(p.$1);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProducerLogoBox extends StatelessWidget {
  final String logoUrl;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const _ProducerLogoBox({
    required this.logoUrl,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFD700).withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFD700) : Colors.white12,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: logoUrl.endsWith('.png') || logoUrl.endsWith('.jpg')
            ? Image.network(
                logoUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => _FallbackText(name: name),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white24)));
                },
              )
            : _FallbackText(name: name),
      ),
    );
  }
}

class _FallbackText extends StatelessWidget {
  final String name;
  const _FallbackText({required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        name.toUpperCase(),
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white70, fontSize: 8, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _InnyProducerBox extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _InnyProducerBox({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isCustom = !['Hot Wheels', 'Matchbox', 'Majorette', 'Mini GT', 'Tomica', 'Maisto', 'Jada'].contains(controller.text) && controller.text.isNotEmpty;

    return GestureDetector(
      onTap: () async {
        final result = await _showCustomProducerDialog(context, controller.text);
        if (result != null) {
          controller.text = result;
          onChanged(result);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isCustom ? const Color(0xFFFFD700).withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCustom ? const Color(0xFFFFD700) : Colors.white12,
            width: isCustom ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.more_horiz, color: isCustom ? const Color(0xFFFFD700) : Colors.white38),
            const SizedBox(height: 2),
            Text(
              isCustom ? controller.text.toUpperCase() : 'INNY',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isCustom ? Colors.white : Colors.white38,
                fontSize: 8,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showCustomProducerDialog(BuildContext context, String current) async {
    final textController = TextEditingController(text: current);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A120B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: const BorderSide(color: Colors.white12)),
        title: const Text('PODAJ PRODUCENTA', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
        content: TextField(
          controller: textController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'np. Inno64',
            hintStyle: TextStyle(color: Colors.white24),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white12)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFFD700))),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ANULUJ', style: TextStyle(color: Colors.white38)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, textController.text),
            child: const Text('ZAPISZ', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _SeriesAutocomplete extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final List<String> options;

  const _SeriesAutocomplete({
    required this.controller,
    required this.label,
    required this.options,
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
            style: const TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.5),
          ),
        ),
        Autocomplete<String>(
          optionsBuilder: (textEditingValue) {
            if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
            return options.where((o) => o.toLowerCase().contains(textEditingValue.text.toLowerCase()));
          },
          onSelected: (selection) => controller.text = selection,
          fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
            // Sync with parent controller if needed, but here parent provides controller
            return _GlassInputBase(
              controller: controller,
              focusNode: focusNode,
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: MediaQuery.of(context).size.width - 48,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D1B0D),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, i) {
                      final option = options.elementAt(i);
                      return ListTile(
                        title: Text(option, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        onTap: () => onSelected(option),
                      );
                    },
                  ),
                ),
              ),
            );
          },
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
            style: const TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.5),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
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
  final Widget? suffix;

  const _GlassInput({
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.validator,
    this.suffix,
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
            style: const TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.5),
          ),
        ),
        _GlassInputBase(
          controller: controller,
          hint: hint,
          keyboardType: keyboardType,
          validator: validator,
          suffix: suffix,
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
  final Widget? suffix;
  final FocusNode? focusNode;

  const _GlassInputBase({
    required this.controller,
    this.hint,
    this.keyboardType,
    this.validator,
    this.suffix,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            suffixIcon: suffix,
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

