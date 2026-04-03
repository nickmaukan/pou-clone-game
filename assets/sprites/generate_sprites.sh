#!/bin/bash
# Script to generate Pou game sprites using PixelLab API

API_KEY="224426c8-0c90-4ecf-8cd6-9b4f27e3da68"
SPRITES_DIR="/Users/nickmaukan/.openclaw/workspace/pou_game/assets/sprites"

generate_sprite() {
    local filename=$1
    local description=$2
    local size=${3:-64}
    
    echo "Generating: $filename ($description)"
    
    response=$(curl -s -X POST "https://api.pixellab.ai/v1/generate-image-pixflux" \
        -H "Authorization: Bearer $API_KEY" \
        -H "Content-Type: application/json" \
        -d "{
            \"description\": \"$description\",
            \"image_size\": {\"width\": $size, \"height\": $size},
            \"no_background\": true
        }")
    
    # Extract base64 image
    echo "$response" | python3 -c "
import sys, json, base64
try:
    data = json.load(sys.stdin)
    if 'image' in data and 'base64' in data['image']:
        img_data = data['image']['base64']
        with open('$SPRITES_DIR/$filename', 'wb') as f:
            f.write(base64.b64decode(img_data))
        print('  -> Saved: $filename')
    else:
        print('  -> Error: No image in response')
        print('  -> Response:', data)
except Exception as e:
    print('  -> Error:', e)
    print('  -> Raw:', sys.stdin.read()[:200])
"
}

# Create sprites directory
mkdir -p "$SPRITES_DIR"

echo "=== Generating Pou Character Sprites ==="
generate_sprite "pou_happy.png" "cute round green virtual pet character, big happy eyes smile, pixel art style transparent background"
generate_sprite "pou_sad.png" "cute round green virtual pet character, sad crying eyes, pixel art style transparent background"
generate_sprite "pou_hungry.png" "cute round green virtual pet character, hungry mouth open, pixel art style transparent background"
generate_sprite "pou_sick.png" "cute round green virtual pet character, sick fever dizzy, pixel art style transparent background"
generate_sprite "pou_tired.png" "cute round green virtual pet character, tired sleepy eyes, pixel art style transparent background"
generate_sprite "pou_neutral.png" "cute round green virtual pet character, neutral expression, pixel art style transparent background"
generate_sprite "pou_eating.png" "cute round green virtual pet character, eating chewing, pixel art style transparent background"
generate_sprite "pou_sleeping.png" "cute round green virtual pet character, sleeping closed eyes, pixel art style transparent background"

echo ""
echo "=== Generating Food Sprites ==="
generate_sprite "food_apple.png" "pixel art red apple with leaf, transparent background"
generate_sprite "food_pizza.png" "pixel art pizza slice with toppings, transparent background"
generate_sprite "food_burger.png" "pixel art hamburger with layers, transparent background"
generate_sprite "food_icecream.png" "pixel art ice cream cone, transparent background"
generate_sprite "food_coffee.png" "pixel art coffee cup with steam, transparent background"
generate_sprite "food_water.png" "pixel art water glass, transparent background"
generate_sprite "food_cake.png" "pixel art birthday cake, transparent background"
generate_sprite "food_carrot.png" "pixel art orange carrot, transparent background"
generate_sprite "food_banana.png" "pixel art yellow banana, transparent background"
generate_sprite "food_grapes.png" "pixel art purple grapes bunch, transparent background"

echo ""
echo "=== Generating Potions ==="
generate_sprite "potion_green.png" "pixel art green potion bottle, transparent background"
generate_sprite "potion_blue.png" "pixel art blue potion bottle, transparent background"
generate_sprite "potion_red.png" "pixel art red potion bottle, transparent background"

echo ""
echo "=== Generating Room Backgrounds ==="
generate_sprite "bg_living_room.png" "pixel art cozy living room interior, wooden floor, window, sofa, transparent background" 128
generate_sprite "bg_kitchen.png" "pixel art kitchen interior, tile floor, counter, transparent background" 128
generate_sprite "bg_bathroom.png" "pixel art bathroom interior, white tiles, bathtub, transparent background" 128

echo ""
echo "=== All Sprites Generated ==="
ls -la "$SPRITES_DIR"