import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<GeoPoint?> {
  LocationCubit() : super(null);

  final office = GeoPoint(latitude: -6.277878, longitude: 106.635743);

  bool insideOffice = false;

  Future<void> updateLocation(GeoPoint? point) async {
    if (point == null) {
      emit(null);
      return;
    }

    final distance = await distance2point(point, office);
    insideOffice = distance <= 200;

    emit(point);
  }
}
