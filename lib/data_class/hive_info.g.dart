// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveInfoAdapter extends TypeAdapter<HiveInfo> {
  @override
  final int typeId = 12;

  @override
  HiveInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveInfo(
      lat: fields[0] as double,
      long: fields[1] as double,
      label: fields[2] as String,
      address: fields[3] as String,
      category: fields[4] as String,
      name: fields[5] as String,
      description: fields[9] as String?,
      imageLink: fields[8] as String?,
      state: fields[6] as String?,
      country: fields[7] as String?,
      nearbyPlaces: (fields[10] as List?)?.cast<HiveInfo>(),
    )
      ..wikiMediaTag = fields[11] as String?
      ..wikipediaLang = fields[12] as String?
      ..wikipediaTitle = fields[13] as String?;
  }

  @override
  void write(BinaryWriter writer, HiveInfo obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.lat)
      ..writeByte(1)
      ..write(obj.long)
      ..writeByte(2)
      ..write(obj.label)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.state)
      ..writeByte(7)
      ..write(obj.country)
      ..writeByte(8)
      ..write(obj.imageLink)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.nearbyPlaces)
      ..writeByte(11)
      ..write(obj.wikiMediaTag)
      ..writeByte(12)
      ..write(obj.wikipediaLang)
      ..writeByte(13)
      ..write(obj.wikipediaTitle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
