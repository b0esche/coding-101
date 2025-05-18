import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

import 'package:tapstories/home_screen.dart';

// Definieren von Konstanten für die Standardwerte
const Color _defaultColor = Colors.black;
const double _defaultStrokeWidth = 5.0;

// Definition der verschiedenen Zeichenmodi
enum DrawMode { freeDraw, line, rectangle, circle, square, star, wave, arrow }

// Hilfsklasse zum Speichern von Zeichenpfaden und Eigenschaften
class DrawingPath {
  List<Offset> points;
  Color color;
  double strokeWidth;
  DrawMode drawMode;
  Offset? startPoint;
  Offset? endPoint;
  DrawingPath({
    required this.points,
    required this.color,
    required this.strokeWidth,
    required this.drawMode,
    this.startPoint,
    this.endPoint,
  });
}

// Hilfsklasse für Undo/Redo Operationen
class DrawingHistory {
  final List<DrawingPath?> paths;
  final int historyIndex;

  DrawingHistory({required this.paths, required this.historyIndex});

  DrawingHistory copyWith({List<DrawingPath?>? paths, int? historyIndex}) {
    return DrawingHistory(
      paths: paths ?? this.paths,
      historyIndex: historyIndex ?? this.historyIndex,
    );
  }
}

class DrawPad extends StatefulWidget {
  final Color? initialColor;
  final double? initialStrokeWidth;
  final List<DrawingPath?>? initialPaths;
  final bool? showShapes;
  final bool? showColorPalette;
  final bool? showStrokeWidthSlider;

  DrawPad({
    Key? key,
    this.initialColor,
    this.initialStrokeWidth,
    this.initialPaths,
    this.showShapes,
    this.showColorPalette,
    this.showStrokeWidthSlider,
  }) : super(key: key);

  @override
  _DrawPadState createState() => _DrawPadState();
}

class _DrawPadState extends State<DrawPad> {
  // Aktuelle Zeichenfarbe und Strichstärke
  late Color _currentColor;
  late double _currentStrokeWidth;
  // Liste aller gezeichneten Pfade und aktueller Zeichenmodus
  List<DrawingPath?> _paths = [];
  DrawMode _drawMode = DrawMode.freeDraw;
  //GameMode
  bool _isShapesVisible = true;
  //Undo Redo
  late DrawingHistory _history;
  final List<DrawingHistory> _historyStack = [];

  //Globale Key
  final GlobalKey _globalKey = GlobalKey();

  // Zustand für die Sichtbarkeit der Menüs
  bool _showColorPalette = false;
  bool _showStrokeWidthSlider = false;
  bool _showDrawModeSelector = false;

  @override
  void initState() {
    super.initState();
    // Initialisieren der Zeichenfarbe und Strichstärke mit Standardwerten oder übergebenen Werten
    _currentColor = widget.initialColor ?? _defaultColor;
    _currentStrokeWidth = widget.initialStrokeWidth ?? _defaultStrokeWidth;
    // Initialisiere Pfade aus dem Widget, falls vorhanden, oder mit einer leeren Liste
    _paths = widget.initialPaths ?? [];
    _isShapesVisible = widget.showShapes ?? true;
    _history = DrawingHistory(paths: _paths, historyIndex: _paths.length);
    _historyStack.add(_history);
    _showColorPalette =
        widget.showColorPalette ?? false; // Standardwert beibehalten
    _showStrokeWidthSlider =
        widget.showStrokeWidthSlider ?? false; // Standardwert beibehalten
  }

  // Methode zum Hinzufügen eines Pfades zur Liste
  void _addPath(DrawingPath? path) {
    if (path != null) {
      List<DrawingPath?> updatedPaths = List.from(_history.paths);
      updatedPaths.add(path);
      _history = _history.copyWith(
        paths: updatedPaths,
        historyIndex: updatedPaths.length,
      );
      _historyStack.add(_history);
    }
  }

  // Methode zum Entfernen des letzten Pfades (Undo)
  void _undo() {
    if (_history.historyIndex > 0) {
      List<DrawingPath?> updatedPaths = List.from(_history.paths);
      updatedPaths.removeLast();
      _history = _history.copyWith(
        paths: updatedPaths,
        historyIndex: updatedPaths.length,
      );
      _historyStack.add(_history);
      setState(() {
        _paths = updatedPaths;
      });
    }
  }

  //Methode zum Wiederherstellen des letzten Rückgängig gemachten Schrittes (Redo)
  void _redo() {
    if (_history.historyIndex < _historyStack.length - 1) {
      final nextHistory = _historyStack[_history.historyIndex + 1];
      _history = nextHistory;
      setState(() {
        _paths = nextHistory.paths;
      });
    }
  }

  // Methode zum Zurücksetzen des Zeichenbereichs
  void _clearCanvas() {
    setState(() {
      _paths.clear();
      _history = _history.copyWith(paths: [], historyIndex: 0);
      _historyStack.clear();
      _historyStack.add(_history);
    });
  }

  // Methode zum Zeichnen von Formen basierend auf dem aktuellen Zeichenmodus
  void _drawShape(Canvas canvas, DrawingPath path) {
    final paint =
        Paint()
          ..color = path.color
          ..strokeWidth = path.strokeWidth
          ..style = PaintingStyle.stroke;

    if (path.startPoint == null || path.endPoint == null) return;

    final startPoint = path.startPoint!;
    final endPoint = path.endPoint!;

    switch (path.drawMode) {
      case DrawMode.line:
        canvas.drawLine(startPoint, endPoint, paint);
        break;
      case DrawMode.rectangle:
        final rect = Rect.fromPoints(startPoint, endPoint);
        canvas.drawRect(rect, paint);
        break;
      case DrawMode.square:
        final size = (endPoint - startPoint).distance;
        final rect = Rect.fromPoints(
          startPoint,
          startPoint + Offset(size, size),
        );
        canvas.drawRect(rect, paint);
        break;
      case DrawMode.circle:
        final center = startPoint;
        final radius = (endPoint - startPoint).distance;
        canvas.drawCircle(center, radius, paint);
        break;
      case DrawMode.star:
        _drawStar(canvas, startPoint, endPoint, paint);
        break;
      case DrawMode.wave:
        _drawWave(canvas, startPoint, endPoint, paint);
        break;
      case DrawMode.arrow:
        _drawArrow(canvas, startPoint, endPoint, paint);
        break;
      default:
        break;
    }
  }

  // Methode zum Zeichnen eines Sterns
  void _drawStar(Canvas canvas, Offset center, Offset endPoint, Paint paint) {
    final radius = (endPoint - center).distance;
    const int numberOfPoints = 5;
    final anglePerPoint = 360 / (numberOfPoints * 2);
    final outerRadius = radius;
    final innerRadius = radius * 0.5;

    Path path = Path();
    for (int i = 0; i < numberOfPoints * 2; i++) {
      final currentRadius = i % 2 == 0 ? outerRadius : innerRadius;
      final angle = (i * anglePerPoint - 90).toRadians();
      final x = center.dx + currentRadius * cos(angle);
      final y = center.dy + currentRadius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  // Methode zum Zeichnen einer Welle
  void _drawWave(
    Canvas canvas,
    Offset startPoint,
    Offset endPoint,
    Paint paint,
  ) {
    final width = endPoint.dx - startPoint.dx;
    final height = endPoint.dy - startPoint.dy;
    final waveLength = width / 5;
    final amplitude = height / 2;

    if (waveLength <= 0 || amplitude == 0) return;

    Path path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);

    for (double x = startPoint.dx; x <= endPoint.dx; x += 10) {
      final y =
          startPoint.dy +
          amplitude * sin((x - startPoint.dx) / waveLength * 2 * pi);
      path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  //Methode um einen Pfeil zu zeichnen
  void _drawArrow(
    Canvas canvas,
    Offset startPoint,
    Offset endPoint,
    Paint paint,
  ) {
    final arrowLength = 20.0;
    final arrowAngle = 0.3;

    final dx = endPoint.dx - startPoint.dx;
    final dy = endPoint.dy - startPoint.dy;
    final angle = atan2(dy, dx);

    final path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    path.lineTo(endPoint.dx, endPoint.dy);

    final arrowPoint1X = endPoint.dx - arrowLength * cos(angle - arrowAngle);
    final arrowPoint1Y = endPoint.dy - arrowLength * sin(angle - arrowAngle);
    final arrowPoint2X = endPoint.dx - arrowLength * cos(angle + arrowAngle);
    final arrowPoint2Y = endPoint.dy - arrowLength * sin(angle + arrowAngle);

    path.lineTo(arrowPoint1X, arrowPoint1Y);
    path.lineTo(endPoint.dx, endPoint.dy);
    path.lineTo(arrowPoint2X, arrowPoint2Y);
    path.lineTo(endPoint.dx, endPoint.dy);

    canvas.drawPath(path, paint);
  }

  // Methode zum Speichern des aktuellen Zeichenbereichs als Bild
  Future<void> _saveImage() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage();
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData?.buffer.asUint8List();

    if (pngBytes != null) {
      img.Image? capturedImage = img.decodePng(pngBytes);
      if (capturedImage != null) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath =
            '${directory.path}/draw_pad_image_${DateTime.now().millisecondsSinceEpoch}.png';
        File(filePath).writeAsBytesSync(img.encodePng(capturedImage));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bild erfolgreich gespeichert unter: $filePath'),
            duration: Duration(seconds: 5),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fehler beim Dekodieren des PNG-Bildes.'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fehler beim Erfassen des Zeichenbereichs.'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showColorPalette = widget.showColorPalette ?? true;
    final bool showStrokeWidthSlider = widget.showStrokeWidthSlider ?? true;
    return Scaffold(
      appBar: AppBar(
        title: const Text('DrawPad'),
        actions: [
          IconButton(icon: const Icon(Icons.undo), onPressed: _undo),
          IconButton(icon: const Icon(Icons.redo), onPressed: _redo),
          IconButton(icon: const Icon(Icons.clear), onPressed: _clearCanvas),
          IconButton(icon: const Icon(Icons.save), onPressed: _saveImage),
        ],
      ),
      body: Stack(
        children: [
          RepaintBoundary(
            key: _globalKey,
            child: GestureDetector(
              onPanStart: (details) {
                if (_drawMode == DrawMode.freeDraw) {
                  setState(() {
                    _addPath(
                      DrawingPath(
                        points: [details.localPosition],
                        color: _currentColor,
                        strokeWidth: _currentStrokeWidth,
                        drawMode: _drawMode,
                      ),
                    );
                  });
                } else {
                  setState(() {
                    _addPath(
                      DrawingPath(
                        points: [],
                        color: _currentColor,
                        strokeWidth: _currentStrokeWidth,
                        drawMode: _drawMode,
                        startPoint: details.localPosition,
                        endPoint: details.localPosition,
                      ),
                    );
                  });
                }
              },
              onPanUpdate: (details) {
                if (_drawMode == DrawMode.freeDraw) {
                  setState(() {
                    List<DrawingPath?> updatedPaths = List.from(_history.paths);
                    if (updatedPaths.isNotEmpty && updatedPaths.last != null) {
                      updatedPaths.last!.points.add(details.localPosition);
                    }
                    _history = _history.copyWith(paths: updatedPaths);
                    _paths = updatedPaths;
                  });
                } else {
                  setState(() {
                    List<DrawingPath?> updatedPaths = List.from(_history.paths);
                    if (updatedPaths.isNotEmpty && updatedPaths.last != null) {
                      updatedPaths.last!.endPoint = details.localPosition;
                    }
                    _history = _history.copyWith(paths: updatedPaths);
                    _paths = updatedPaths;
                  });
                }
              },
              onPanEnd: (details) {
                if (_drawMode != DrawMode.freeDraw) {
                  setState(() {
                    List<DrawingPath?> updatedPaths = List.from(_history.paths);
                    if (updatedPaths.isNotEmpty && updatedPaths.last != null) {
                      updatedPaths.last!.endPoint = details.localPosition;
                    }
                    _history = _history.copyWith(paths: updatedPaths);
                    _paths = updatedPaths;
                  });
                }
              },
              child: CustomPaint(
                size: Size.infinite,
                painter: _DrawPadPainter(paths: _paths),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Column(
              children: [
                _buildColorPalette(),
                _buildStrokeWidthSlider(),
                _buildDrawModeSelector(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget für die Farbauswahl-Palette
  Widget _buildColorPalette() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _showColorPalette = !_showColorPalette;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              'Farbe wählen',
            ), // Titel für den ausklappbaren Bereich
          ),
        ),
        if (_showColorPalette)
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Wrap(
              spacing: 5.0,
              runSpacing: 5.0,
              children: [
                _buildColorButton(Colors.black),
                _buildColorButton(Colors.red),
                _buildColorButton(Colors.green),
                _buildColorButton(Colors.blue),
                _buildColorButton(Colors.yellow),
                _buildColorButton(Colors.orange),
                _buildColorButton(Colors.purple),
                _buildColorButton(Colors.pink),
                _buildColorButton(Colors.teal),
                _buildColorButton(Colors.amber),
                _buildColorButton(Colors.cyan),
                _buildColorButton(Colors.lime),
              ],
            ),
          ),
      ],
    );
  }

  // Widget für einen einzelnen Farbbutton
  Widget _buildColorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentColor = color;
        });
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: _currentColor == color ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }

  // Widget für den Strichstärken-Slider
  Widget _buildStrokeWidthSlider() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _showStrokeWidthSlider = !_showStrokeWidthSlider;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Text('Strichstärke wählen'), // Titel
          ),
        ),
        if (_showStrokeWidthSlider)
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SizedBox(
              width: 200,
              child: Slider(
                value: _currentStrokeWidth,
                min: 1,
                max: 20,
                onChanged: (value) {
                  setState(() {
                    _currentStrokeWidth = value;
                  });
                },
                label: _currentStrokeWidth.toStringAsFixed(0),
              ),
            ),
          ),
      ],
    );
  }

  // Widget für die Auswahl des Zeichenmodus
  Widget _buildDrawModeSelector() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _showDrawModeSelector = !_showDrawModeSelector;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Text('Zeichenmodus wählen'), // Titel
          ),
        ),
        if (_showDrawModeSelector)
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildDrawModeButton(DrawMode.freeDraw, Icons.draw, 'Freihand'),
                _buildDrawModeButton(
                  DrawMode.line,
                  Icons.horizontal_rule,
                  'Linie',
                ),
                _buildDrawModeButton(
                  DrawMode.rectangle,
                  Icons.rectangle_outlined,
                  'Rechteck',
                ),
                _buildDrawModeButton(
                  DrawMode.square,
                  Icons.square_outlined,
                  'Quadrat',
                ),
                _buildDrawModeButton(
                  DrawMode.circle,
                  Icons.circle_outlined,
                  'Kreis',
                ),
                _buildDrawModeButton(
                  DrawMode.star,
                  Icons.star_outline,
                  'Stern',
                ),
                _buildDrawModeButton(DrawMode.wave, Icons.waves, 'Welle'),
                _buildDrawModeButton(
                  DrawMode.arrow,
                  Icons.arrow_forward,
                  'Pfeil',
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Widget für einen einzelnen Button zur Auswahl des Zeichenmodus
  Widget _buildDrawModeButton(DrawMode mode, IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _drawMode = mode;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color:
                _drawMode == mode ? Colors.blue.shade100 : Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

// CustomPainter-Klasse zum Zeichnen auf dem Canvas
class _DrawPadPainter extends CustomPainter {
  final List<DrawingPath?> paths;

  _DrawPadPainter({required this.paths});

  @override
  void paint(Canvas canvas, Size size) {
    for (var path in paths) {
      if (path == null) continue;
      if (path.points.isNotEmpty && path.drawMode == DrawMode.freeDraw) {
        final paint =
            Paint()
              ..color = path.color
              ..strokeWidth = path.strokeWidth
              ..style = PaintingStyle.stroke
              ..strokeCap = StrokeCap.round;
        for (int i = 0; i < path.points.length - 1; i++) {
          if (path.points[i] != null && path.points[i + 1] != null) {
            canvas.drawLine(path.points[i], path.points[i + 1], paint);
          }
        }
      } else if (path.startPoint != null && path.endPoint != null) {
        _drawShape(canvas, path);
      }
    }
  }

  // Methode zum Zeichnen von Formen (ausgelagert aus der DrawPad-Klasse)
  void _drawShape(Canvas canvas, DrawingPath path) {
    final paint =
        Paint()
          ..color = path.color
          ..strokeWidth = path.strokeWidth
          ..style = PaintingStyle.stroke;

    final startPoint = path.startPoint;
    final endPoint = path.endPoint;

    if (startPoint == null || endPoint == null) return;

    switch (path.drawMode) {
      case DrawMode.line:
        canvas.drawLine(startPoint, endPoint, paint);
        break;
      case DrawMode.rectangle:
        final rect = Rect.fromPoints(startPoint, endPoint);
        canvas.drawRect(rect, paint);
        break;
      case DrawMode.square:
        final size = (endPoint - startPoint).distance;
        final rect = Rect.fromPoints(
          startPoint,
          startPoint + Offset(size, size),
        );
        canvas.drawRect(rect, paint);
        break;
      case DrawMode.circle:
        final center = startPoint;
        final radius = (endPoint - startPoint).distance;
        canvas.drawCircle(center, radius, paint);
        break;
      case DrawMode.star:
        _drawStar(canvas, startPoint, endPoint, paint);
        break;
      case DrawMode.wave:
        _drawWave(canvas, startPoint, endPoint, paint);
        break;
      case DrawMode.arrow:
        _drawArrow(canvas, startPoint, endPoint, paint);
        break;
      default:
        break;
    }
  }

  void _drawStar(Canvas canvas, Offset center, Offset endPoint, Paint paint) {
    final radius = (endPoint - center).distance;
    const int numberOfPoints = 5;
    final anglePerPoint = 360 / (numberOfPoints * 2);
    final outerRadius = radius;
    final innerRadius = radius * 0.5;

    Path path = Path();
    for (int i = 0; i < numberOfPoints * 2; i++) {
      final currentRadius = i % 2 == 0 ? outerRadius : innerRadius;
      final angle = (i * anglePerPoint - 90).toRadians();
      final x = center.dx + currentRadius * cos(angle);
      final y = center.dy + currentRadius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawWave(
    Canvas canvas,
    Offset startPoint,
    Offset endPoint,
    Paint paint,
  ) {
    final width = endPoint.dx - startPoint.dx;
    final height = endPoint.dy - startPoint.dy;
    final waveLength = width / 5;
    final amplitude = height / 2;

    if (waveLength <= 0 || amplitude == 0) return;

    Path path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);

    for (double x = startPoint.dx; x <= endPoint.dx; x += 10) {
      final y =
          startPoint.dy +
          amplitude * sin((x - startPoint.dx) / waveLength * 2 * pi);
      path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  void _drawArrow(
    Canvas canvas,
    Offset startPoint,
    Offset endPoint,
    Paint paint,
  ) {
    final arrowLength = 20.0;
    final arrowAngle = 0.3;

    final dx = endPoint.dx - startPoint.dx;
    final dy = endPoint.dy - startPoint.dy;
    final angle = atan2(dy, dx);

    final path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    path.lineTo(endPoint.dx, endPoint.dy);

    final arrowPoint1X = endPoint.dx - arrowLength * cos(angle - arrowAngle);
    final arrowPoint1Y = endPoint.dy - arrowLength * sin(angle - arrowAngle);
    final arrowPoint2X = endPoint.dx - arrowLength * cos(angle + arrowAngle);
    final arrowPoint2Y = endPoint.dy - arrowLength * sin(angle + arrowAngle);

    path.lineTo(arrowPoint1X, arrowPoint1Y);
    path.lineTo(endPoint.dx, endPoint.dy);
    path.lineTo(arrowPoint2X, arrowPoint2Y);
    path.lineTo(endPoint.dx, endPoint.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DrawPadPainter oldDelegate) {
    return oldDelegate.paths != paths;
  }
}

extension on num {
  double toRadians() {
    return (this * pi) / 180.0;
  }
}
