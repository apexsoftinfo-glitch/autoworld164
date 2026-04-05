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

  Future<void> _pickImage() async {
    final total = _newImages.length + _remainingPhotoPaths.length + _internetPhotoUrls.length;
    if (total >= 5) return;
    
    final l10n = context.l10n;
    
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: const Color(0xFF1A120B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                title: Text(l10n.cameraButtonLabel, style: const TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: Colors.white),
                title: Text(l10n.galleryButtonLabel, style: const TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

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
                                  onAdd: _pickImage,
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
  final VoidCallback onAdd;
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
                _AddPhotoBox(onTap: onAdd, label: 'APARAT'),
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
      return Image.network(
        url!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error_outline, color: Colors.white24)),
      );
    }
    return Image.network(
      'https://laapoqdayvmszqcijyob.supabase.co/storage/v1/object/public/autoworld_photos/$path',
      fit: BoxFit.cover,
    );
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

  @override
  Widget build(BuildContext context) {
    final producer = controller.text.toLowerCase();
    Widget? logo;
    
    if (producer.contains('hot wheels') || producer.contains('hotwheels')) {
      logo = const Icon(Icons.local_fire_department, color: Colors.orange, size: 20); // Simplified logo for demo
    } else if (producer.contains('matchbox')) {
      logo = const Icon(Icons.square, color: Colors.blueAccent, size: 16);
    }

    return _GlassInput(
      controller: controller,
      label: label,
      onChanged: onChanged,
      suffix: logo != null ? Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black26, 
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            logo,
            const SizedBox(width: 4),
            Text(
              producer.toUpperCase(), 
              style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ) : null,
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
              onChanged: (v) {},
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
  final ValueChanged<String>? onChanged;

  const _GlassInput({
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.validator,
    this.suffix,
    this.onChanged,
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
          onChanged: onChanged,
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
  final ValueChanged<String>? onChanged;

  const _GlassInputBase({
    required this.controller,
    this.hint,
    this.keyboardType,
    this.validator,
    this.suffix,
    this.focusNode,
    this.onChanged,
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
          onChanged: onChanged,
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

