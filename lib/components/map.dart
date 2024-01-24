import 'dart:async';

import 'package:eco_conscience/components/collision_block.dart';
import 'package:eco_conscience/components/interaction_point.dart';
import 'package:eco_conscience/components/player.dart';
import 'package:eco_conscience/eco_conscience.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'go_to_next_map.dart';

class Map extends World with HasGameRef<EcoConscience> {
  Map({required this.name, required this.player});

  final Player player;
  final String name;
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$name.tmx', Vector2.all(32));
    game.worldDimensions = Vector2(level.width, level.height);
    add(level);
    _addSpawnPoints();
    _addCollisions();
    return super.onLoad();
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if(collisionsLayer == null) return;
    for (final collision in collisionsLayer.objects) {
      switch (collision.class_) {
        default:
          CollisionBlock block = CollisionBlock(
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height),
          );
          collisionBlocks.add(block);
      }
    }
    addAll(collisionBlocks);
    player.collisionBlocks = collisionBlocks;
  }

  void _addSpawnPoints() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');
    if(spawnPointsLayer == null) return;
    for (final spawnPoint in spawnPointsLayer.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          player.size = Vector2(spawnPoint.width, spawnPoint.height);
          add(player);
          break;
        case 'Interaction':
          InteractionPoint point = InteractionPoint(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height));
          add(point);
          break;
        case 'GoToNextMap':
          GoToNextMap point = GoToNextMap(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            nextMapName: spawnPoint.properties.getValue('NextMapName') as String,
          );
          add(point);
          break;
      }
    }
  }
}
