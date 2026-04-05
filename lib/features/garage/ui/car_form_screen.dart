import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/di/injection.dart';
import '../../../l10n/l10n.dart';
import '../models/car_model.dart';
import '../presentation/cubit/car_form_cubit.dart';

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
  late TextEditingController _seriesController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _estimatedValueController;
  File? _image;

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController(text: widget.car?.brand);
    _nameController = TextEditingController(text: widget.car?.modelName);
    _seriesController = TextEditingController(text: widget.car?.series);
    _purchasePriceController = TextEditingController(
      text: widget.car?.purchasePrice.toString() ?? '',
    );
    _estimatedValueController = TextEditingController(
      text: widget.car?.estimatedValue.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _brandController.dispose();
    _nameController.dispose();
    _seriesController.dispose();
    _purchasePriceController.dispose();
    _estimatedValueController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEditing = widget.car != null;

    return BlocProvider(
      create: (context) => getIt<CarFormCubit>(),
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
                          const Color(0xFF2D1B0D).withValues(alpha: 0.6),
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
                              _PhotoPicker(
                                image: _image,
                                oldPhotoPath: widget.car?.photoPath,
                                onPick: _pickImage,
                                onReset: () => setState(() => _image = null),
                              ),
                              const SizedBox(height: 32),
                              _GlassInput(
                                controller: _brandController,
                                label: l10n.carBrandLabel,
                                validator: (v) => v!.isEmpty ? '...' : null,
                              ),
                              const SizedBox(height: 16),
                              _GlassInput(
                                controller: _nameController,
                                label: l10n.carModelNameLabel,
                                validator: (v) => v!.isEmpty ? '...' : null,
                              ),
                              const SizedBox(height: 16),
                              _GlassInput(
                                controller: _seriesController,
                                label: l10n.carSeriesLabel,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _GlassInput(
                                      controller: _purchasePriceController,
                                      label: l10n.carPurchasePriceLabel,
                                      keyboardType: TextInputType.number,
                                      validator: (v) => double.tryParse(v ?? '') == null ? '?' : null,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _GlassInput(
                                      controller: _estimatedValueController,
                                      label: l10n.carEstimatedValueLabel,
                                      keyboardType: TextInputType.number,
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
                                      modelName: _nameController.text,
                                      series: _seriesController.text.isEmpty ? null : _seriesController.text,
                                      purchasePrice: double.parse(_purchasePriceController.text),
                                      estimatedValue: double.parse(_estimatedValueController.text),
                                      newPhoto: _image,
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

class _PhotoPicker extends StatelessWidget {
  final File? image;
  final String? oldPhotoPath;
  final VoidCallback onPick;
  final VoidCallback onReset;

  const _PhotoPicker({
    required this.image,
    required this.oldPhotoPath,
    required this.onPick,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return GestureDetector(
      onTap: onPick,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: _buildBody(context, l10n),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    if (image != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(image!, fit: BoxFit.cover),
          Positioned(
            right: 8,
            top: 8,
            child: IconButton.filled(
              onPressed: onReset,
              icon: const Icon(Icons.close, size: 20),
              style: IconButton.styleFrom(backgroundColor: Colors.black54),
            ),
          ),
        ],
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.camera_alt_outlined, color: Color(0xFFFFD700), size: 48),
          const SizedBox(height: 12),
          Text(
            l10n.carFormAddPhotoLabel,
            style: const TextStyle(color: Colors.white38, fontSize: 13, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}

class _GlassInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _GlassInput({
    required this.controller,
    required this.label,
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
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              validator: validator,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.white12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.white12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFFFD700), width: 0.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
        ),
      ],
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
