#!/usr/bin/env python3
"""Generate placeholder assets for Pou game using Pillow with emoji characters."""

import os
from PIL import Image, ImageDraw, ImageFont

# Base directory for assets
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
ASSETS_DIR = os.path.join(BASE_DIR, "..", "assets")

def get_font(size=64):
    """Get a usable font for emoji rendering."""
    font_paths = [
        "/System/Library/Fonts/Apple Color Emoji.ttc",
        "/System/Library/Fonts/NotoColorEmoji.ttf",
        "/System/Library/Fonts/CoreUI/AppleColorEmoji.ttc",
    ]
    for path in font_paths:
        if os.path.exists(path):
            try:
                return ImageFont.truetype(path, size)
            except:
                continue
    return ImageFont.load_default()

def create_emoji_image(emoji_char, size=(128, 128), output_path=None):
    """Create an image with a single emoji character centered."""
    img = Image.new('RGBA', size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    font = get_font(80)

    # Get text bounding box and center it
    try:
        bbox = draw.textbbox((0, 0), emoji_char, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        x = (size[0] - text_width) // 2 - bbox[0]
        y = (size[1] - text_height) // 2 - bbox[1]
    except:
        x, y = size[0] // 4, size[1] // 4

    draw.text((x, y), emoji_char, font=font, embedded=True)
    if output_path:
        img.save(output_path)
    return img

def create_colored_rect(size, color, output_path=None, corner_radius=20):
    """Create a colored rectangle with rounded corners."""
    img = Image.new('RGBA', size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Draw rounded rectangle
    draw.rounded_rectangle([(0, 0), (size[0]-1, size[1]-1)], radius=corner_radius, fill=color)

    if output_path:
        img.save(output_path)
    return img

def create_room_background(room_name, room_emoji, size=(1080, 1920), output_path=None):
    """Create a placeholder room background."""
    img = Image.new('RGBA', size, (200, 200, 200, 255))
    draw = ImageDraw.Draw(img)

    # Room color scheme
    colors = {
        'living_room': (135, 206, 235, 255),   # Sky blue
        'kitchen': (255, 228, 196, 255),        # Bisque
        'bathroom': (224, 255, 255, 255),       # Light cyan
        'lab': (147, 112, 219, 255),           # Medium purple
        'game_room': (50, 50, 50, 255),          # Dark gray with neon
        'closet': (255, 182, 193, 255),         # Light pink
    }

    bg_color = colors.get(room_name, (200, 200, 200, 255))
    img = Image.new('RGBA', size, bg_color)
    draw = ImageDraw.Draw(img)

    # Add room label
    font = get_font(120)
    room_text = room_name.replace('_', ' ').title()
    bbox = draw.textbbox((0, 0), room_emoji, font=font)
    text_width = bbox[2] - bbox[0]
    x = (size[0] - text_width) // 2 - bbox[0]
    y = size[1] // 3

    draw.text((x, y), room_emoji, font=font, embedded=True)

    # Draw decorative frame
    draw.rectangle([(50, 50), (size[0]-50, size[1]-50)], outline=(100, 100, 100, 255), width=10)

    if output_path:
        img.save(output_path)
    return img

def create_food_item(name, emoji, output_path=None):
    """Create a food item image."""
    return create_emoji_image(emoji, size=(120, 120), output_path=output_path)

def create_potion(name, color, output_path=None):
    """Create a potion image."""
    size = (80, 100)
    img = Image.new('RGBA', size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Bottle shape
    draw.rounded_rectangle([(20, 30), (60, 90)], radius=10, fill=color)
    draw.rectangle([(30, 10), (50, 35)], fill=(200, 200, 200, 255))

    if output_path:
        img.save(output_path)
    return img

def create_hat(name, emoji, output_path=None):
    """Create a hat item image."""
    return create_emoji_image(emoji, size=(100, 80), output_path=output_path)

def create_glasses(name, emoji, output_path=None):
    """Create glasses item image."""
    return create_emoji_image(emoji, size=(120, 60), output_path=output_path)

def create_outfit(name, emoji, output_path=None):
    """Create outfit item image."""
    return create_emoji_image(emoji, size=(150, 180), output_path=output_path)

def create_ui_element(name, emoji, size=(100, 100), output_path=None):
    """Create UI element image."""
    return create_emoji_image(emoji, size=size, output_path=output_path)

def create_sound_file(filename, duration=1.0):
    """Create a placeholder sound file (empty WAV)."""
    import struct
    import wave

    output_path = os.path.join(ASSETS_DIR, "sounds", filename)
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    # Create a minimal silent WAV file
    sample_rate = 44100
    num_samples = int(sample_rate * duration)
    with wave.open(output_path, 'w') as wav:
        wav.setnchannels(1)
        wav.setsampwidth(2)
        wav.setframerate(sample_rate)
        wav.writeframes(b'\x00' * num_samples * 2)

    print(f"Created sound: {filename}")

def main():
    print("Generating Pou game placeholder assets...")

    # Create directories
    dirs = [
        "images/pou",
        "images/rooms",
        "images/food",
        "images/items/clothing/hats",
        "images/items/clothing/glasses",
        "images/items/clothing/outfits",
        "images/items/accessories",
        "images/potions",
        "images/ui",
        "sounds",
    ]
    for d in dirs:
        os.makedirs(os.path.join(ASSETS_DIR, d), exist_ok=True)

    # === POU SPRITES ===
    pou_states = {
        'idle': ['😐', '😐', '😑', '😐'],
        'happy': ['😊', '😄', '😁'],
        'sad': ['😢', '😭', '😢'],
        'eating': ['😋', '🤤', '😋', '😋'],
        'bathing': ['🛁', '😌', '💦', '🛁'],
        'sleeping': ['😴', '💤'],
        'playing': ['🤩', '🎉', '🤪', '🎮'],
        'drinking': ['🧪', '💊', '😵'],
    }

    for state, frames in pou_states.items():
        for i, emoji in enumerate(frames):
            filename = f"{state}_{i+1}.png"
            path = os.path.join(ASSETS_DIR, "images/pou", filename)
            create_emoji_image(emoji, size=(256, 256), output_path=path)
            print(f"Created pou sprite: {filename}")

    # Level variants
    for level in ['baby', 'child', 'adult', 'royal', 'alien']:
        emoji = {'baby': '👶', 'child': '🧒', 'adult': '🧑', 'royal': '👑', 'alien': '👽'}[level]
        path = os.path.join(ASSETS_DIR, "images/pou", f"level_{level}.png")
        create_emoji_image(emoji, size=(256, 256), output_path=path)
        print(f"Created pou level: {level}")

    # === ROOM BACKGROUNDS ===
    rooms = {
        'living_room': '🏠',
        'kitchen': '🍳',
        'bathroom': '🚿',
        'lab': '🧪',
        'game_room': '🎮',
        'closet': '👗',
    }

    for room, emoji in rooms.items():
        filename = f"{room}.png"
        path = os.path.join(ASSETS_DIR, "images/rooms", filename)
        create_room_background(room, emoji, size=(1080, 1920), output_path=path)
        print(f"Created room: {filename}")

    # === FOOD ITEMS ===
    foods = [
        ('apple', '🍎'), ('banana', '🍌'), ('orange', '🍊'), ('grapes', '🍇'),
        ('strawberry', '🍓'), ('watermelon', '🍉'), ('pineapple', '🍍'), ('mango', '🥭'),
        ('cherry', '🍒'), ('pizza', '🍕'), ('burger', '🍔'), ('hotdog', '🌭'),
        ('fries', '🍟'), ('taco', '🌮'), ('sushi', '🍣'), ('ramen', '🍜'),
        ('donut', '🍩'), ('cupcake', '🧁'), ('popcorn', '🍿'), ('ice_cream', '🍦'),
        ('cookie', '🍪'), ('chocolate', '🍫'), ('candy', '🍬'), ('pretzel', '🥨'),
        ('chips', '🥔'), ('jellybeans', '🫘'), ('water', '💧'), ('juice', '🧃'),
        ('soda', '🥤'), ('milkshake', '🥛'), ('coffee', '☕'), ('tea', '🍵'),
        ('steak', '🥩'), ('lobster', '🦞'), ('golden_apple', '✨🍎'), ('rainbow_candy', '🌈'),
        ('bread', '🍞'), ('egg', '🥚'), ('cheese', '🧀'), ('pizza_slice', '🍕'),
    ]

    for name, emoji in foods:
        path = os.path.join(ASSETS_DIR, "images/food", f"{name}.png")
        create_food_item(name, emoji, output_path=path)
        print(f"Created food: {name}.png")

    # === POTIONS ===
    potions = [
        ('blue_simple', (0, 100, 255, 200)),
        ('blue_strong', (0, 50, 200, 255)),
        ('red_simple', (255, 50, 50, 200)),
        ('red_strong', (200, 0, 0, 255)),
        ('green_simple', (50, 200, 50, 200)),
        ('green_strong', (0, 150, 0, 255)),
        ('yellow_simple', (255, 220, 0, 200)),
        ('yellow_strong', (255, 180, 0, 255)),
        ('rainbow', (255, 0, 200, 200)),
        ('sleep', (100, 0, 150, 200)),
        ('vitamin', (255, 150, 0, 200)),
        ('energy_drink', (0, 255, 100, 200)),
        ('miracle', (255, 215, 0, 255)),
        ('poison', (0, 100, 0, 200)),
        ('love', (255, 100, 150, 200)),
        ('growth', (0, 255, 50, 200)),
    ]

    for name, color in potions:
        path = os.path.join(ASSETS_DIR, "images/potions", f"{name}.png")
        create_potion(name, color, output_path=path)
        print(f"Created potion: {name}.png")

    # === HATS ===
    hats = [
        ('cap_red', '🧢'), ('cap_blue', '🧢'), ('beanie', '🎿'), ('crown', '👑'),
        ('chef_hat', '👨‍🍳'), ('party_hat', '🎉'), ('top_hat', '🎩'), ('cowboy_hat', '🤠'),
        ('crown_royal', '👑'), ('pirate_hat', '🏴‍☠️'), ('angel_halo', '😇'), ('devil_horns', '😈'),
        ('bow', '🎀'), ('flower_crown', '🌸'), ('headband_sport', '🏃'), ('wizard_hat', '🧙'),
        ('viking_helmet', '🪖'), ('princess_tiara', '💎'), ('robot_helmet', '🤖'),
        ('superhero_mask', '🦸'), ('astronaut_helmet', '👨‍🚀'), ('crown_diamond', '💠'),
        ('rainbow_crown', '🌈'), ('galaxy_helmet', '🌌'), ('golden_phoenix', '🔥'),
        ('alien_antenna', '👽'), ('crown_infinite', '♾️'),
    ]

    for name, emoji in hats:
        path = os.path.join(ASSETS_DIR, "images/items/clothing/hats", f"{name}.png")
        create_hat(name, emoji, output_path=path)
        print(f"Created hat: {name}.png")

    # === GLASSES ===
    glasses = [
        ('round_classic', '👓'), ('square_black', '🕶️'), ('aviator', '🛩️'),
        ('cat_eyes', '😼'), ('sport', '🏋️'), ('3d_glasses', '🎥'),
        ('cyberpunk', '🤖'), ('heart_shaped', '💕'), ('star_glasses', '⭐'),
        ('pixel_glasses', '👾'), ('laser_eyes', '⚡'), ('rainbow_glasses', '🌈'),
        ('diamond_eyes', '💎'), ('vr_headset', '🎮'),
    ]

    for name, emoji in glasses:
        path = os.path.join(ASSETS_DIR, "images/items/clothing/glasses", f"{name}.png")
        create_glasses(name, emoji, output_path=path)
        print(f"Created glasses: {name}.png")

    # === OUTFITS ===
    outfits = [
        ('casual_blue', '👕'), ('formal_suit', '🤵'), ('superhero', '🦸'),
        ('robot', '🤖'), ('astronaut', '👨‍🚀'), ('prince_princess', '👸'),
        ('pirate', '🏴‍☠️'), ('chef', '👨‍🍳'), ('doctor', '👨‍⚕️'),
        ('ninja', '🥷'), ('alien_suit', '👽'), ('dragon', '🐉'),
        ('rainbow', '🌈'), ('golden', '✨'), ('diamond', '💎'),
    ]

    for name, emoji in outfits:
        path = os.path.join(ASSETS_DIR, "images/items/clothing/outfits", f"{name}.png")
        create_outfit(name, emoji, output_path=path)
        print(f"Created outfit: {name}.png")

    # === ACCESSORIES ===
    accessories = [
        ('mustache', '🥸'), ('blush', '💄'), ('lipstick', '💋'),
        ('earrings', '📿'), ('necklace', '📿'), ('scarf', '🧣'),
        ('wings_angel', '😇'), ('wings_devil', '😈'), ('wings_fairy', '🧚'),
        ('tail', '🐕'), ('bow_tie', '🎀'), ('cape', '🃏'),
        ('backpack', '🎒'), ('wings_butterfly', '🦋'),
    ]

    for name, emoji in accessories:
        path = os.path.join(ASSETS_DIR, "images/items/accessories", f"{name}.png")
        create_emoji_image(emoji, size=(100, 100), output_path=path)
        print(f"Created accessory: {name}.png")

    # === UI ELEMENTS ===
    ui_elements = [
        ('coin', '🪙'), ('heart', '❤️'), ('star', '⭐'),
        ('energy', '⚡'), ('food', '🍎'), ('potion', '🧪'),
        ('button_primary', '🔴'), ('button_secondary', '⚪'),
        ('shop_icon', '🏪'), ('settings_icon', '⚙️'),
    ]

    for name, emoji in ui_elements:
        size = (100, 100) if 'button' not in name else (300, 80)
        path = os.path.join(ASSETS_DIR, "images/ui", f"{name}.png")
        create_ui_element(name, emoji, size=size, output_path=path)
        print(f"Created UI: {name}.png")

    # === SOUND FILES ===
    sounds = [
        'ui_click.wav', 'door_open.wav', 'door_close.wav',
        'purchase.wav', 'coins.wav', 'victory.wav', 'gameover.wav',
        'eating.wav', 'drinking.wav', 'water_splash.wav',
        'magic.wav', 'notification.wav',
    ]

    for sound in sounds:
        create_sound_file(sound, duration=0.5)

    # Background music tracks
    bg_music = [
        'living_room.wav', 'kitchen.wav', 'bathroom.wav',
        'lab.wav', 'game_room.wav', 'closet.wav',
    ]

    for music in bg_music:
        create_sound_file(music, duration=2.0)

    print("\n✅ All assets generated successfully!")
    print(f"Total files created in: {ASSETS_DIR}")

if __name__ == '__main__':
    main()