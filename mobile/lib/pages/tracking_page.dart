import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/tracking_service.dart';

class TrackingPage extends StatefulWidget {
  final String trackingNumber;

  const TrackingPage({
    super.key,
    required this.trackingNumber,
  });

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  final TrackingService _trackingService = TrackingService();
  final TextEditingController _searchController = TextEditingController();

  Map<String, dynamic>? _shipmentData;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.trackingNumber != "-" && widget.trackingNumber.isNotEmpty) {
      _searchController.text = widget.trackingNumber;
      _fetchShipment(widget.trackingNumber);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchShipment(String trackingNumber) async {
    if (trackingNumber.isEmpty || trackingNumber == "-") return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _shipmentData = null;
    });

    final token = context.read<AuthProvider>().token;
    if (token != null) {
      _trackingService.setToken(token);
    }

    try {
      final data =
          await _trackingService.getShipmentByTracking(trackingNumber);

      setState(() {
        _shipmentData = data;
        _isLoading = false;
        if (data == null) {
          _errorMessage = "Data pengiriman tidak ditemukan";
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Gagal mengambil data pengiriman";
      });
    }
  }

  int _getStatusStep(String? status) {
    switch (status?.toUpperCase()) {
      case 'PENDING':
        return 0;
      case 'PICKED_UP':
        return 1;
      case 'IN_TRANSIT':
        return 2;
      case 'DELIVERED':
        return 3;
      default:
        return 0;
    }
  }

  String _getStatusLabel(String? status) {
    switch (status?.toUpperCase()) {
      case 'PENDING':
        return 'Menunggu Pickup';
      case 'PICKED_UP':
        return 'Sudah Diambil Kurir';
      case 'IN_TRANSIT':
        return 'Dalam Perjalanan';
      case 'DELIVERED':
        return 'Terkirim';
      default:
        return status ?? 'Tidak Diketahui';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Tracking Pengiriman",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: "Masukkan nomor resi...",
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onSubmitted: (value) => _fetchShipment(value.trim()),
                  ),
                ),
                const SizedBox(width: 12),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () => _fetchShipment(_searchController.text.trim()),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      child: const Icon(
                        Icons.local_shipping,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF2E7D32)),
            SizedBox(height: 16),
            Text("Mencari data pengiriman..."),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_shipping_outlined,
                size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () =>
                  _fetchShipment(_searchController.text.trim()),
              icon: const Icon(Icons.refresh),
              label: const Text("Coba Lagi"),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2E7D32),
              ),
            ),
          ],
        ),
      );
    }

    if (_shipmentData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_shipping_outlined,
                size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              "Masukkan nomor resi\nuntuk melacak pengiriman",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return _buildShipmentDetails();
  }

  Widget _buildShipmentDetails() {
    final status = _shipmentData!["status"] as String?;
    final currentStep = _getStatusStep(status);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Tracking number card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.qr_code_2,
                        color: Color(0xFF2E7D32),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Nomor Resi",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _shipmentData!["trackingNumber"] ?? "-",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30),
                _buildInfoRow(
                  Icons.business,
                  "Kurir",
                  _shipmentData!["courierName"] ?? "-",
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.person,
                  "Penerima",
                  _shipmentData!["recipientName"] ?? "-",
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.location_on,
                  "Alamat",
                  _shipmentData!["deliveryAddress"] ?? "-",
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Status card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Status Pengiriman",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(currentStep).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getStatusLabel(status),
                        style: TextStyle(
                          color: _getStatusColor(currentStep),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Timeline
                _buildTimelineStep(
                  0,
                  currentStep,
                  "Pesanan Dibuat",
                  "Menunggu kurir mengambil paket",
                  Icons.inventory_2,
                ),
                _buildTimelineStep(
                  1,
                  currentStep,
                  "Diambil Kurir",
                  "Paket telah diambil oleh kurir",
                  Icons.person_pin_circle,
                ),
                _buildTimelineStep(
                  2,
                  currentStep,
                  "Dalam Perjalanan",
                  "Paket sedang dikirim ke alamat tujuan",
                  Icons.local_shipping,
                ),
                _buildTimelineStep(
                  3,
                  currentStep,
                  "Terkirim",
                  "Paket telah diterima",
                  Icons.check_circle,
                  isLast: true,
                ),
              ],
            ),
          ),
        ),

        // Notes
        if (_shipmentData!["notes"] != null &&
            (_shipmentData!["notes"] as String).isNotEmpty) ...[
          const SizedBox(height: 20),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.note, color: Color(0xFF2E7D32)),
                      SizedBox(width: 8),
                      Text(
                        "Catatan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _shipmentData!["notes"],
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineStep(
    int stepIndex,
    int currentStep,
    String title,
    String subtitle,
    IconData icon, {
    bool isLast = false,
  }) {
    final isCompleted = stepIndex <= currentStep;
    final isActive = stepIndex == currentStep;
    final color = isCompleted ? const Color(0xFF2E7D32) : Colors.grey.shade300;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF2E7D32)
                    : isCompleted
                        ? const Color(0xFF2E7D32).withOpacity(0.2)
                        : Colors.grey.shade100,
                shape: BoxShape.circle,
                border: Border.all(
                  color: color,
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                size: 18,
                color: isActive
                    ? Colors.white
                    : isCompleted
                        ? const Color(0xFF2E7D32)
                        : Colors.grey.shade400,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted && stepIndex < currentStep
                    ? const Color(0xFF2E7D32)
                    : Colors.grey.shade200,
              ),
          ],
        ),

        const SizedBox(width: 14),

        // Content
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        isActive ? FontWeight.bold : FontWeight.w500,
                    color: isCompleted ? Colors.black87 : Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(int step) {
    switch (step) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.indigo;
      case 3:
        return const Color(0xFF2E7D32);
      default:
        return Colors.grey;
    }
  }
}
