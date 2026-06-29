import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/asset.dart';
import '../providers/auth_provider.dart';
import '../providers/transaction_provider.dart';
import '../utils/validators.dart';
import '../utils/snackbar_helper.dart';
import 'payment_page.dart';

class DetailPage extends StatefulWidget {
  final Asset asset;

  const DetailPage({
    super.key,
    required this.asset,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  int quantity = 1;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));
  bool _isLoading = false;

  int get totalDays => endDate.difference(startDate).inDays + 1;
  int get totalPrice => widget.asset.rentalPrice * quantity * totalDays;

  @override
  void initState() {
    super.initState();
    // Pre-fill from user profile
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      _nameController.text = user.name;
      _phoneController.text = user.phone ?? '';
      _addressController.text = user.address ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String getImage() {
    switch (widget.asset.name) {
      case "Kursi Lipat":
        return "assets/images/kursi.jpg";
      case "Hammock Outdoor":
        return "assets/images/hammock.jpg";
      case "Carrier 60L":
        return "assets/images/carrier.jpg";
      case "Tracking pool":
        return "assets/images/tracking.jpg";
      case "Matras Camp":
        return "assets/images/matras.jpg";
      case "Senter":
        return "assets/images/senter.jpg";
      case "Jacket":
        return "assets/images/jacket.jpg";
      case "Kompor dan Gas":
        return "assets/images/kompor.jpg";
      case "Sleeping Bag Outdoor":
        return "assets/images/sleeping_bag.jpg";
      default:
        return "assets/images/tenda.jpg";
    }
  }

  String _formatPrice(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write('.');
        count = 0;
      }
    }
    return buffer.toString().split('').reversed.join('');
  }

  Future<void> _handleRental() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final txProvider = context.read<TransactionProvider>();

    final transactionId = await txProvider.createTransaction(
      assetId: widget.asset.id,
      customerName: _nameController.text.trim(),
      customerPhone: _phoneController.text.trim(),
      customerAddress: _addressController.text.trim(),
      quantity: quantity,
      startDate: startDate,
      endDate: endDate,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (transactionId != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentPage(
            transactionId: transactionId,
            totalPrice: totalPrice,
          ),
        ),
      );

      if (!mounted) return;
      SnackbarHelper.showSuccess(context, "Penyewaan berhasil dibuat!");
      Navigator.pop(context);
    } else {
      SnackbarHelper.showError(
        context,
        txProvider.errorMessage ?? "Gagal membuat penyewaan",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // Hero Image App Bar
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'asset_${widget.asset.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      getImage(),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.green.shade100,
                        child: const Icon(Icons.backpack, size: 80),
                      ),
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                    // Asset info overlay
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.asset.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              _buildBadge(
                                "Rp ${_formatPrice(widget.asset.rentalPrice)}/hari",
                                const Color(0xFF2E7D32),
                              ),
                              const SizedBox(width: 8),
                              _buildBadge(
                                "Stok: ${widget.asset.stock}",
                                Colors.blue.shade700,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.info_outline,
                                    color: Color(0xFF2E7D32), size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Deskripsi",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.asset.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Form section title
                    const Text(
                      "Data Penyewa",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Name
                    TextFormField(
                      controller: _nameController,
                      validator: Validators.name,
                      decoration: _inputDecoration(
                        "Nama Penyewa",
                        Icons.person_outline,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Phone
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: Validators.phone,
                      decoration: _inputDecoration(
                        "Nomor HP",
                        Icons.phone_outlined,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Address
                    TextFormField(
                      controller: _addressController,
                      maxLines: 2,
                      validator: Validators.address,
                      decoration: _inputDecoration(
                        "Alamat Pengiriman",
                        Icons.location_on_outlined,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Quantity section
                    const Text(
                      "Jumlah & Durasi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Quantity
                    Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.shopping_bag_outlined,
                                color: Color(0xFF2E7D32)),
                            const SizedBox(width: 12),
                            const Text(
                              "Jumlah",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            _buildQuantityButton(
                              Icons.remove,
                              quantity > 1,
                              () => setState(() => quantity--),
                            ),
                            Container(
                              width: 45,
                              alignment: Alignment.center,
                              child: Text(
                                "$quantity",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _buildQuantityButton(
                              Icons.add,
                              quantity < widget.asset.stock,
                              () => setState(() => quantity++),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Dates
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateCard(
                            "Mulai Pinjam",
                            startDate,
                            () => _pickDate(isStart: true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDateCard(
                            "Tanggal Kembali",
                            endDate,
                            () => _pickDate(isStart: false),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Total summary
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2E7D32).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow(
                            "Harga per hari",
                            "Rp ${_formatPrice(widget.asset.rentalPrice)}",
                          ),
                          const SizedBox(height: 8),
                          _buildSummaryRow(
                            "Jumlah",
                            "$quantity unit",
                          ),
                          const SizedBox(height: 8),
                          _buildSummaryRow(
                            "Durasi",
                            "$totalDays hari",
                          ),
                          const Divider(color: Colors.white30, height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Rp ${_formatPrice(totalPrice)}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // CTA Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _handleRental,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.shopping_cart_checkout),
                        label: Text(
                          _isLoading ? "Memproses..." : "Sewa Sekarang",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 3,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildQuantityButton(
    IconData icon,
    bool enabled,
    VoidCallback onTap,
  ) {
    return Material(
      color: enabled
          ? const Color(0xFF2E7D32).withOpacity(0.1)
          : Colors.grey.shade100,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 20,
            color: enabled ? const Color(0xFF2E7D32) : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  Widget _buildDateCard(String label, DateTime date, VoidCallback onTap) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Color(0xFF2E7D32),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "${date.day}/${date.month}/${date.year}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.85),
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF2E7D32)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
      ),
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate : endDate,
      firstDate: isStart ? DateTime.now() : startDate,
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D32),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          if (endDate.isBefore(startDate)) {
            endDate = startDate.add(const Duration(days: 1));
          }
        } else {
          endDate = picked;
        }
      });
    }
  }
}
