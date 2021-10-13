
class UserAddress {
  final String customer_id;
  final String address_id;
  final String customer_address;
  final String customer_locality;
  final String google_address;
  final String latitude;
  final String longitude;

  UserAddress(
      {this.latitude,
        this.longitude,
        this.customer_address,
        this.address_id,
        this.customer_id,
        this.customer_locality,
        this.google_address});

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      customer_id: json['customer_id'],
      address_id: json['address_id'],
      customer_locality: json['customer_locality'],
      customer_address: json['customer_address'],
      google_address: json['google_address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
