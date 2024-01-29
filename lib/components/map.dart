import 'dart:async';
import 'dart:ui';

import 'package:eco_conscience/components/collision_block.dart';
import 'package:eco_conscience/components/interaction_point.dart';
import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/widgets/stories.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

import 'go_to_next_map.dart';

class Map extends World with HasGameRef<EcoConscience> {
  Map({required this.name, this.nextSpawn});

  Vector2? nextSpawn;
  final String name;
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$name.tmx', Vector2.all(32));
    add(level);
    _addSpawnPoints();
    _addCollisions();
    return super.onLoad();
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer == null) return;
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
    game.player.collisionBlocks = collisionBlocks;
  }

  void _addSpawnPoints() {
    // if player has teleported, he won't be in the spawn points
    if (nextSpawn != null) {
      print('setting spawn $nextSpawn');
      game.player.position = Vector2(nextSpawn!.x, nextSpawn!.y);
      add(game.player);
    }

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');
    if (spawnPointsLayer == null) return;
    for (final spawnPoint in spawnPointsLayer.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          // first time spawn in the game
          if (nextSpawn == null) {
            game.player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(game.player);
          }
          break;
        case 'Interaction':
          final storyArc = spawnPoint.properties.getValue('storyArc');
          if (allStoryArcs[storyArc] != null && !allStoryArcs[storyArc]!) {
            InteractionPoint point = InteractionPoint(
                position: Vector2(spawnPoint.x, spawnPoint.y),
                size: Vector2(spawnPoint.width, spawnPoint.height),
                storyArc: storyArc,
                hitBoxOffset: Vector2(spawnPoint.properties.getValue('offsetX'),
                    spawnPoint.properties.getValue('offsetY')));
            add(point);
          }
          if (storyArc == 'houseLightsArc' && game.isHouseLightsOn) {
            final glowingLight = PolygonComponent.relative(
              [
                Vector2(-0.3, -1.0),
                Vector2(0.3, -1.0),
                Vector2(2.0, 1.0),
                Vector2(-2.0, 1.0),
              ],
              position: Vector2(spawnPoint.x + 16, spawnPoint.y + 16 + 64),
              anchor: Anchor.center,
              paint: Paint()
                ..color = const Color(0xfffcfe5f).withOpacity(0.2),
              parentSize: Vector2(spawnPoint.width, spawnPoint.height),
            )..add(
              GlowEffect(
                  10,
                  EffectController(
                    duration: 2,
                    infinite: true,
                    alternate: true,
                  ),
                  style: BlurStyle.solid),
            );
            add(glowingLight);
          }
          break;
        case 'GoToNextMap':
          GoToNextMap point = GoToNextMap(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              nextMapName:
                  spawnPoint.properties.getValue('NextMapName') as String,
              nextSpawn: Vector2(spawnPoint.properties.getValue('NextSpawnX'),
                  spawnPoint.properties.getValue('NextSpawnY')));
          add(point);
          break;
      }
    }
  }

  removeInteractionPoint(bool isAccepted) {
    removeWhere((component) =>
        component is InteractionPoint &&
        component.storyArc == game.currentStoryArc);

    if(game.currentStoryArc == 'houseLightsArc' && isAccepted) {
      game.isHouseLightsOn = false;
      removeWhere((component) =>
      component is PolygonComponent);
    }
  }
}
