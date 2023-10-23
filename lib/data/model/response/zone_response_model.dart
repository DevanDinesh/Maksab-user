class ZoneResponseModel {
  bool _isSuccess;
  List<int> _zoneIds;
  String _message;
  List<ZoneData> _zoneData;
  ZoneResponseModel(this._isSuccess, this._message, this._zoneIds, this._zoneData);

  String get message => _message;
  List<int> get zoneIds => _zoneIds;
  bool get isSuccess => _isSuccess;
  List<ZoneData> get zoneData => _zoneData;
}

class ZoneData {
  int id;
  int status;
  double minimumShippingCharge;
  double maximumShippingCharge;
  double perKmShippingCharge;
   double minimumKm;

  ZoneData(
      {this.id,
        this.status,
        this.minimumShippingCharge,
        this.maximumShippingCharge,
        this.perKmShippingCharge,
       this.minimumKm
        });

  ZoneData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    // minimumShippingCharge = json['minimum_shipping_charge'] != null ? json['minimum_shipping_charge'].toDouble() : null;
    // maximumShippingCharge = json['maximum_shipping_charge'] != null ? json['maximum_shipping_charge'].toDouble() : null;
    // perKmShippingCharge = json['per_km_shipping_charge'] != null ? json['per_km_shipping_charge'].toDouble() : null;
     minimumShippingCharge = json['minimum_shipping_charge'] != null ? json['minimum_shipping_charge'].toDouble() : 0;
    maximumShippingCharge = json['maximum_shipping_charge'] != null ? json['maximum_shipping_charge'].toDouble() : 0;
    perKmShippingCharge = json['per_km_shipping_charge'] != null ? json['per_km_shipping_charge'].toDouble() : 0;
   minimumKm = json['minimum_km'] != null ? json['minimum_km'].toDouble() : 0;
    // minimumShippingCharge = json['minimum_shipping_charge'] != null ? double.tryParse(json['minimum_shipping_charge']) : null;
    // maximumShippingCharge = json['maximum_shipping_charge'] != null ? double.tryParse(json['maximum_shipping_charge']) : null;
    // perKmShippingCharge = json['per_km_shipping_charge'] != null ? double.tryParse(json['per_km_shipping_charge']) : null;
    
    // perKmShippingCharge = json['per_km_shipping_charge'] != null ? json['per_km_shipping_charge'].toDouble() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['minimum_shipping_charge'] = this.minimumShippingCharge;
    data['maximum_shipping_charge'] = this.maximumShippingCharge;
    data['per_km_shipping_charge'] = this.perKmShippingCharge;
   data['minimum_km'] = this.minimumKm;
    return data;
  }
}

