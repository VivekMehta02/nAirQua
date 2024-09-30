class DeviceItem {
  String? topic;
  List<Data>? data;

  DeviceItem({this.topic, this.data});

  DeviceItem.fromJson(Map<String, dynamic> json) {
    topic = json['topic'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['topic'] = topic;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? name;
  String? type;
  String? lat;
  String? long;
  String? createdAt;
  String? updatedAt;
  List<Sensors>? sensors;

  Data(
      {this.id,
      this.name,
      this.type,
      this.lat,
      this.long,
      this.createdAt,
      this.updatedAt,
      this.sensors});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    lat = json['lat'];
    long = json['long'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['sensors'] != null) {
      sensors = [];
      json['sensors'].forEach((v) {
        sensors!.add(Sensors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['lat'] = lat;
    data['long'] = long;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (sensors != null) {
      data['sensors'] = sensors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sensors {
  String? id;
  String? type;
  String? unit;
  String? createdAt;
  String? updatedAt;
  List<Readings>? readings;

  Sensors(
      {this.id,
      this.type,
      this.unit,
      this.createdAt,
      this.updatedAt,
      this.readings});

  Sensors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    unit = json['unit'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['readings'] != null) {
      readings = [];
      json['readings'].forEach((v) {
        readings!.add(Readings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['type'] = type;
    data['unit'] = unit;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (readings != null) {
      data['readings'] = readings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Readings {
  String? id;
  double? value;
  String? timestamp;
  String? quality;
  Metadata? metadata;
  String? createdAt;
  String? updatedAt;

  Readings(
      {this.id,
      this.value,
      this.timestamp,
      this.quality,
      this.metadata,
      this.createdAt,
      this.updatedAt});

  Readings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    timestamp = json['timestamp'];
    quality = json['quality'];
    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['value'] = value;
    data['timestamp'] = timestamp;
    data['quality'] = quality;
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Metadata {
  String? unit;
  double? rawValue;

  Metadata({this.unit, this.rawValue});

  Metadata.fromJson(Map<String, dynamic> json) {
    unit = json['unit'];
    rawValue = json['raw_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['unit'] = unit;
    data['raw_value'] = rawValue;
    return data;
  }
}
