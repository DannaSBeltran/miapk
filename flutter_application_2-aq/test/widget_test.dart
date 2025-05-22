import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/main.dart'; // Asegúrate de que el nombre del paquete es correcto

void main() {
  testWidgets('Test de la aplicación de streaming', (WidgetTester tester) async {
    // Construir la app y cargarla en el tester
    await tester.pumpWidget(const MyApp());  // Debe coincidir con el nombre de la clase MyApp

    // Verificar que la App muestra el título esperado en la appBar
    expect(find.text('Sports Streaming'), findsOneWidget);

    // Verificar que el título del primer canal de deportes esté en la lista
    expect(find.text('ESPN Premium'), findsOneWidget);

    // Verificar que el botón del canal sea visible
    expect(find.byType(ElevatedButton), findsWidgets);

    // Puedes agregar más pruebas según lo necesites
  });
}
