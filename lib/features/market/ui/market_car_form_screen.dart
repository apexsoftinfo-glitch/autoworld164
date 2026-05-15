import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/di/injection.dart';
import '../../../l10n/l10n.dart';
import '../models/market_car_model.dart';
import '../presentation/cubit/market_form_cubit.dart';
import '../../garage/models/car_model.dart';
import '../../garage/ui/widgets/car_photo.dart';

class MarketCarFormScreen extends StatefulWidget {
  final MarketCarModel? car;
  final CarModel? garageCar;

  const MarketCarFormScreen({super.key, this.car, this.garageCar});

  @override
  State<MarketCarFormScreen> createState() => _MarketCarFormScreenState();
}

class _MarketCarFormScreenState extends State<MarketCarFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _brandController;
  late TextEditingController _toyMakerController;
  late TextEditingController _seriesController;
  late TextEditingController _priceController;
  
  final List<File> _newImages = [];
  final List<String> _remainingPhotoPaths = [];
  final List<String> _internetPhotoUrls = [];
  late String _status;
  late bool _isExchange;
  late bool _isSale;

  AppLocalizations get l10n => context.l10n;

  @override
  void initState() {
    super.initState();
    final garageCar = widget.garageCar;
    String initialBrandModel = widget.car != null
        ? '${widget.car!.brand} ${widget.car!.modelName}'.trim()
        : (garageCar != null ? '${garageCar.brand} ${garageCar.modelName}'.trim() : '');
    
    final initialToyMaker = widget.car?.toyMaker ?? widget.garageCar?.toyMaker;
    final initialSeries = widget.car?.series ?? widget.garageCar?.series;
    final initialPrice = widget.car?.price ?? widget.garageCar?.purchasePrice ?? 0.0;

    _brandController = TextEditingController(text: initialBrandModel);
    _toyMakerController = TextEditingController(text: initialToyMaker);
    _seriesController = TextEditingController(text: initialSeries);
    _priceController = TextEditingController(
      text: initialPrice > 0 ? initialPrice.toString() : '',
    );
    
    _remainingPhotoPaths.addAll(widget.car?.photoPaths ?? widget.garageCar?.allPhotoPaths ?? []);
    _status = widget.car?.status ?? widget.garageCar?.status ?? 'Nowy';
    _isExchange = widget.car?.isExchange ?? true;
    _isSale = widget.car?.isSale ?? true;
  }

  @override
  void dispose() {
    _brandController.dispose();
    _toyMakerController.dispose();
    _seriesController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Removed _searchInternet as per user request (real photos only)


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MarketFormCubit>()..loadInitialData(),
      child: BlocConsumer<MarketFormCubit, MarketFormState>(
        listener: (context, state) {
          if (state is MarketFormSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Success!'), backgroundColor: Colors.green),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final isLoading = state is MarketFormLoading;

          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                widget.car == null ? l10n.homeAddCar : l10n.carFormEditTitle,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 2),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                if (widget.car != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () => _confirmDelete(context),
                  ),
              ],
            ),
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/add_model_bg.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.8),
                          Colors.black.withValues(alpha: 0.4),
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
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
                            folderName: widget.garageCar != null ? 'autoworld_photos' : 'autoworld_market_photos',
                            onAdd: (source) async {
                              final picker = ImagePicker();
                              final picked = await picker.pickImage(source: source, imageQuality: 70);
                              if (picked != null) setState(() => _newImages.add(File(picked.path)));
                            },
                            onRemoveNew: (i) => setState(() => _newImages.removeAt(i)),
                            onRemoveExisting: (p) => setState(() => _remainingPhotoPaths.remove(p)),
                            onRemoveInternet: (u) => setState(() => _internetPhotoUrls.remove(u)),
                            onSearchOnline: () {}, // Disabled as per user request
                          ),
                          const SizedBox(height: 32),
                          _ProducerSelector(
                            controller: _toyMakerController,
                            label: l10n.carProducerPlaceholder,
                            dynamicProducers: state.maybeWhen(
                              initial: (p, s) => p,
                              loading: (p, s) => p,
                              error: (e, p, s) => p,
                              orElse: () => [],
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 16),
                          _GlassInput(
                            controller: _brandController,
                            label: '${l10n.carBrandLabel} / MODEL',
                            validator: (v) => v?.isEmpty ?? true ? l10n.carBrandLabel : null,
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
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 16),
                          _GlassInput(
                            controller: _priceController,
                            label: l10n.carPurchasePriceLabel.toUpperCase(),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          _StatusInput(
                            label: l10n.carFormConditionLabel,
                            selectedStatus: _status,
                            onChanged: (v) => setState(() => _status = v),
                          ),
                          const SizedBox(height: 16),
                          _MarketOptions(
                            isExchange: _isExchange,
                            isSale: _isSale,
                            onExchangeChanged: (v) => setState(() => _isExchange = v),
                            onSaleChanged: (v) => setState(() => _isSale = v),
                          ),
                          if (state is MarketFormError) ...[
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
                                context.read<MarketFormCubit>().saveCar(
                                  existingCar: widget.car,
                                  fromGarageCar: widget.garageCar,
                                  brand: _brandController.text,
                                  modelName: '',
                                  toyMaker: _toyMakerController.text,
                                  series: _seriesController.text.isEmpty ? null : _seriesController.text,
                                  price: double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0.0,
                                  status: _status,
                                  isExchange: _isExchange,
                                  isSale: _isSale,
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
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final cubit = context.read<MarketFormCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1A120B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: const BorderSide(color: Colors.white12)),
        title: Text(l10n.carDetailsDeleteConfirmTitle.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
        content: Text(l10n.carDetailsDeleteConfirmBody, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l10n.cancelButtonLabel.toUpperCase(), style: const TextStyle(color: Colors.white60))),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.deleteCar(widget.car!.id);
            },
            child: Text(l10n.carDetailsDeleteConfirmTitle.toUpperCase(), style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _MarketOptions extends StatelessWidget {
  final bool isExchange;
  final bool isSale;
  final ValueChanged<bool> onExchangeChanged;
  final ValueChanged<bool> onSaleChanged;

  const _MarketOptions({
    required this.isExchange,
    required this.isSale,
    required this.onExchangeChanged,
    required this.onSaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassBox(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          SwitchListTile(
            value: isExchange,
            onChanged: onExchangeChanged,
            title: const Text('EXCHANGE / WYMIANA', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            activeThumbColor: const Color(0xFFFFD700),
          ),
          SwitchListTile(
            value: isSale,
            onChanged: onSaleChanged,
            title: const Text('FOR SALE / NA SPRZEDAŻ', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            activeThumbColor: const Color(0xFFFFD700),
          ),
        ],
      ),
    );
  }
}

// Reused widgets from CarFormScreen (simplified or copied)
class _MultiPhotoPicker extends StatelessWidget {
  final List<File> newImages;
  final List<String> remainingPaths;
  final List<String> internetUrls;
  final String? folderName;
  final Function(ImageSource) onAdd;
  final Function(int) onRemoveNew;
  final Function(String) onRemoveExisting;
  final Function(String) onRemoveInternet;
  final VoidCallback onSearchOnline;

  const _MultiPhotoPicker({
    required this.newImages,
    required this.remainingPaths,
    required this.internetUrls,
    this.folderName,
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
              
              ...newImages.asMap().entries.map((e) => _Thumbnail(
                image: e.value,
                onRemove: () => onRemoveNew(e.key),
              )),
              
              ...remainingPaths.map((p) => _Thumbnail(
                path: p,
                folderName: folderName,
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
  final String? folderName;
  final VoidCallback onRemove;

  const _Thumbnail({this.image, this.path, this.url, this.folderName, required this.onRemove});

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
    if (url != null) return CarPhoto(path: url!, fit: BoxFit.cover, folderName: folderName ?? 'autoworld_market_photos');
    return CarPhoto(path: path!, fit: BoxFit.cover, folderName: folderName ?? 'autoworld_market_photos');
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

  static const _fixedProducers = ['Hot Wheels', 'Matchbox', 'Majorette', 'Mini GT', 'Tomica', 'Maisto', 'Jada'];

  @override
  Widget build(BuildContext context) {
    final current = controller.text;
    final Set<String> itemsSet = {..._fixedProducers, ...dynamicProducers};
    if (current.isNotEmpty && !itemsSet.contains(current)) itemsSet.add(current);
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
          final result = await _showCustomDialog(context, label, current);
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

  @override
  Widget build(BuildContext context) {
    final current = controller.text;
    final Set<String> itemsSet = {...dynamicSeries};
    if (current.isNotEmpty && !itemsSet.contains(current)) itemsSet.add(current);
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
          final result = await _showCustomDialog(context, label, current);
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
}

Future<String?> _showCustomDialog(BuildContext context, String title, String current) async {
  final textController = TextEditingController(text: current);
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF1A120B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: const BorderSide(color: Colors.white12)),
      title: Text(title.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
      content: TextField(
        controller: textController,
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(hintText: '...', hintStyle: TextStyle(color: Colors.white24)),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.cancelButtonLabel.toUpperCase(), style: const TextStyle(color: Colors.white60))),
        TextButton(
          onPressed: () => Navigator.pop(context, textController.text.trim()),
          child: Text(context.l10n.carFormSaveButton.toUpperCase(), style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}

class _StatusInput extends StatelessWidget {
  final String label;
  final String selectedStatus;
  final ValueChanged<String> onChanged;

  const _StatusInput({required this.label, required this.selectedStatus, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final options = ['Nowy', 'Używany', 'Uszkodzony', 'Custom'];
    return _GlassDropdown<String>(
      label: label,
      value: selectedStatus,
      items: options.map((s) => DropdownMenuItem(value: s, child: Text(s.toUpperCase(), style: const TextStyle(fontSize: 12)))).toList(),
      onChanged: (v) => v != null ? onChanged(v) : null,
    );
  }
}

class _GlassInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _GlassInput({required this.controller, required this.label, this.keyboardType, this.validator});

  @override
  Widget build(BuildContext context) {
    return _GlassBox(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          labelText: label.toUpperCase(),
          labelStyle: const TextStyle(color: Color(0xFFFFD700), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.5),
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}

class _GlassDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _GlassDropdown({required this.label, this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _GlassBox(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: const TextStyle(color: Color(0xFFFFD700), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: onChanged,
              dropdownColor: const Color(0xFF1A120B),
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFFFD700), size: 18),
              isExpanded: true,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
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
      height: 56,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: const Color(0xFFFFD700).withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFFFD700),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(label.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
      ),
    );
  }
}

class _GlassBox extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _GlassBox({required this.child, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: child,
        ),
      ),
    );
  }
}
