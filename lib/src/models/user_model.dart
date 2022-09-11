class UserModel {
  String? name;
  String? email;
  String? phone;
  String? cpf;
  String? password;
  String? id;
  String? token;

  UserModel({
    this.name,
    this.email,
    this.phone,
    this.cpf,
    this.password,
    this.id,
    this.token
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      cpf: json['cpf'],
      email: json['email'],
      id: json['id'],
      name: json['fullname'],
      password: json['password'],
      token: json['token'],
      phone: json['phone']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cpf': cpf,
      'email': email,
      'id': id,
      'fullname': name,
      'password': password,
      'phone': phone,
      'token': token
    };
  }
}