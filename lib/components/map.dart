import 'dart:async';

import 'package:eco_conscience/components/collision_block.dart';
import 'package:eco_conscience/components/interaction_point.dart';
import 'package:eco_conscience/components/utils.dart';
import 'package:eco_conscience/eco_conscience.dart';
import 'package:eco_conscience/components/story_progress.dart';
import 'package:eco_conscience/providers/eco_meter_provider.dart';
import 'package:eco_conscience/providers/start_menu_provider.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/parallax.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame/rendering.dart';
import 'package:provider/provider.dart';

import 'go_to_next_map.dart';
import 'other_interaction_point.dart';

class Map extends World with HasGameRef<EcoConscience>, HasDecorator {
  Map({required this.name, this.nextSpawnX, this.nextSpawnY});

  double? nextSpawnX;
  double? nextSpawnY;
  final String name;
  late TiledComponent level;
  ParallaxComponent? parallaxComponent;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(
      '$name.tmx', Vector2.all(32),
      // can lead to performance issues
      // atlasMaxX: 20000, atlasMaxY: 20000
    );
    addStartingSequence();
    loadParallaxBg();
    await add(level);
    _addSpawnPoints();
    _addCollisions();
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    try {
      canvas.drawRect(
        Rect.fromPoints(const Offset(0, 0),
            Offset(game.currentMap.level.width, game.currentMap.level.height)),
        Paint()..color = const Color(0xff62626f),
      );
    } catch (e) {
      if (kDebugMode) print(e);
    }
    super.render(canvas);
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
    // spawn the player
    if (nextSpawnX != null) {
      Vector2 spawn =
          Vector2(nextSpawnX!, nextSpawnY ?? game.player.position.y);
      game.player.position = spawn;
      add(game.player);
    }

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');
    if (spawnPointsLayer == null) return;
    for (final spawnPoint in spawnPointsLayer.objects) {
      switch (spawnPoint.class_) {
        case 'Interaction':
          final storyArc = spawnPoint.properties.getValue('storyArc') as String;
          if (StoryProgress.allStoryArcsProgress[storyArc] != null &&
              !StoryProgress.allStoryArcsProgress[storyArc]!) {
            InteractionPoint point = InteractionPoint(
                position: Vector2(spawnPoint.x, spawnPoint.y),
                size: Vector2(spawnPoint.width, spawnPoint.height),
                storyArc: storyArc,
                hitBoxOffset: Vector2(spawnPoint.properties.getValue('offsetX'),
                    spawnPoint.properties.getValue('offsetY')));
            add(point);
          }
          if (storyArc == StoryTitles.houseLightsArc.name &&
              StoryProgress.isHouseLightsOn) {
            final glowingLight = PolygonComponent.relative(
              [
                Vector2(-0.3, -1.0),
                Vector2(0.3, -1.0),
                Vector2(2.0, 1.0),
                Vector2(-2.0, 1.0),
              ],
              position: Vector2(spawnPoint.x + 16, spawnPoint.y + 16 + 64),
              anchor: Anchor.center,
              paint: Paint()..color = const Color(0xfffcfe5f).withOpacity(0.2),
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
              nextSpawnX: spawnPoint.properties.getValue('NextSpawnX'),
              nextSpawnY: spawnPoint.properties.getValue('NextSpawnY'),
              mapResMultiplier:
                  spawnPoint.properties.getValue('MapResMultiplier'));
          add(point);
          break;
        case 'OtherInteraction':
          OtherInteractionPoint point = OtherInteractionPoint(
            position: Vector2(spawnPoint.x, spawnPoint.y),
            size: Vector2(spawnPoint.width, spawnPoint.height),
            imageName: spawnPoint.properties.getValue('imageName') as String,
          );
          add(point);
          break;
      }
    }
  }

  removeInteractionPoint(bool isAccepted) {
    removeWhere((component) =>
        component is InteractionPoint &&
        component.storyArc == game.currentStoryArc);

    if (game.currentStoryArc == StoryTitles.houseLightsArc.name && isAccepted) {
      StoryProgress.isHouseLightsOn = false;
      removeWhere((component) => component is PolygonComponent);
    }
  }

  Future<void> loadParallaxBg() async {
    final provider = gameRef.buildContext?.read<EcoMeterProvider>();
    if (name.contains('outdoors')) {
      parallaxComponent = await game.loadParallaxComponent([
        ParallaxImageData('Exteriors/skyline/1.png'),
        ParallaxImageData('Exteriors/skyline/2.png'),
        ParallaxImageData('Exteriors/skyline/3.png'),
        ParallaxImageData('Exteriors/skyline/cloudsOverlay.png'),
        ParallaxImageData('Exteriors/skyline/4.png'),
        ParallaxImageData('Exteriors/skyline/5.png'),
      ],
          baseVelocity: Vector2(0, 0),
          velocityMultiplierDelta: Vector2(1.15, 1.0),
          repeat: ImageRepeat.repeat,
          fill: LayerFill.none,
          alignment: Alignment.topLeft,
          size: Vector2(
              game.currentMap.level.width, game.currentMap.level.height),
          priority: -10);
      parallaxComponent?.decorator.replaceLast(PaintDecorator.tint(
          getBgColorBasedOnEcoMeter(provider?.ecoMeter ?? 100)));

      add(parallaxComponent!);
    }
  }

  void updateParallax(double horizontalMovement) {
    if (parallaxComponent != null) {
      parallaxComponent?.parallax?.baseVelocity =
          Vector2(horizontalMovement * 1, 0);
    }
  }

  addStartingSequence() async {
    if (name == 'startingSequence') {
      final p1 = await game.loadParallaxComponent([
        ParallaxImageData('Exteriors/skyline/longBg.png'),
      ],
          baseVelocity: Vector2(0, 0),
          repeat: ImageRepeat.repeat,
          fill: LayerFill.none,
          alignment: Alignment.topLeft,
          size: Vector2(
              game.currentMap.level.width, game.currentMap.level.height),
          priority: -10);
      final p2 = await game.loadParallaxComponent([
        ParallaxImageData('Exteriors/skyline/longCloudsOverlay.png'),
      ],
          baseVelocity: Vector2(25, 0),
          repeat: ImageRepeat.repeat,
          fill: LayerFill.none,
          alignment: Alignment.topCenter,
          size: Vector2(
              game.currentMap.level.width, game.currentMap.level.height),
          priority: -10);

      add(p1);
      add(p2);

      game.cam.stop();
      game.cam.viewfinder.add(
        MoveToEffect(
            Vector2(0, 400),
            EffectController(
                startDelay: 3,
                duration: 3,
                // duration: 1,
                onMax: () {
                  if (game.overlays.activeOverlays
                      .contains(PlayState.startScreen.name)) {
                    final provider =
                        gameRef.buildContext?.read<StartMenuProvider>();
                    provider?.showMenu = true;
                  }
                })),
      );

      game.overlays.add(PlayState.startScreen.name);
    }
  }
}
