# EcoShift Chronicles
EcoShift Chronicles is live! [Try it out here](https://toseefkhan403.github.io/EcoConscience/)
[Available](https://drive.google.com/drive/folders/11WUSuBVBJ2bkoXtuM_RQgYM5vfZ82h5e?usp=sharing) on Web, Android, iOS, Windows, Linux and macOS.

## Description
A 2D-pixel art video game built using Flutter and Flame where your choices matter and transform the world!

## Inspiration
In our daily choices lies the power to create a healthier planet. Small decisions, when combined, have a profound impact. This game aims to raise awareness about the consequences of our actions, inspiring positive choices for a greener and more sustainable future.

## What it does
EcoShift Chronicles is an engaging 2D-pixel art game where players make choices influencing the environment. Every decision impacts the world, presenting dilemmas influenced by angels and devils, and shaping branching storylines. It combines vibrant graphics, music, and real-life choices for an immersive experience. Players have the option to select distinct characters, save their game progress, and experience gameplay in Japanese.

## How we built it
- Built with Flutter and Flame
- Uses Flame Tiled for 2D maps and graphics
- Animations feature sprite animation, parallax components, and Flutter animation widgets
- Dialogs are created using Flutter overlays
- Flame Audio is employed for music
- Game progress is saved with Shared Preferences
- State management handled through Provider
- Japanese localization is integrated
- Generic pass from Google Wallet API is included

## Challenges we ran into
The main challenge was making it work on the web. The graphics looked distorted and sometimes didn't load properly. We fixed this by changing how we load the map. Instead of loading it directly, we combined a layer of the map into a component to show it as one image. This made the game run better on big maps. Creating animations and dialogues also took some time.
Another tough part was adding the generic passes feature because Dart support is limited in the Google Wallet API.

## Accomplishments that we're proud of
Creating a game that not only entertains but also raises awareness about real-world environmental choices is something that we're proud of. Pushing the boundaries of the Flame package in the Flutter ecosystem, the integration of dynamic storytelling, graphics, and user choices is an accomplishment in itself.

## What we learned
Throughout the development, we gained insights into effectively merging educational elements with gameplay. Understanding the nuances of Flutter and Flame for game development expanded our technical expertise. Player feedback played a crucial role in refining the game's narrative and mechanics.

## What's next for EcoShift Chronicles
The journey continues with ongoing updates, introducing new storylines, characters, and environmental challenges. We plan to add more choices and integrate community-driven features. Expanding to other languages ensures EcoShift Chronicles reaches a diverse and global audience.
