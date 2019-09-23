.ifndef RACE_ASM
RACE_ASM=1

.include "vera.inc"
.include "system.inc"
.include "graphics.inc"

RACE_MOUNTAINS_BG_ADDR=0
RACE_MOUNTAINS_BG_SIZE=$4000 ; 128*64*2

RACE_FOREST_BG_ADDR=$4000
RACE_FOREST_BG_SIZE=$4000 ; 128*64*2

RACE_MOUNTAINS_BG_TILES_ADDR=$8000
RACE_MOUNTAINS_BG_TILES_SIZE=$80 ; ((4 * 8) * 4) ; 4 tiles

RACE_FOREST_BG_TILES_ADDR=$8080 ; (RACE_MOUNTAINS_BG_TILES_ADDR + RACE_MOUNTAINS_BG_TILES_SIZE)
RACE_FOREST_BG_TILES_SIZE=$40 ; ((4 * 8) * 2) ; 2 tiles

RACE_CAR_ADDR=$80C0 ; (RACE_FOREST_BG_TILES_ADDR + RACE_FOREST_BG_TILES_SIZE), aligned to 5 bits
RACE_CAR_SIZE=$1000 ; ((64 * 64) * 1)

;=================================================
;=================================================
; 
;   Code
;
;-------------------------------------------------
;
; Do a RACE screen with my logo.
; Return to caller when done.
;
race_do:
    ; Copy data into video memory
    VERA_SELECT_ADDR 0
    VERA_STREAM_OUT Race_mountains_map, RACE_MOUNTAINS_BG_ADDR, RACE_MOUNTAINS_BG_SIZE
    VERA_STREAM_OUT Race_forest_map, RACE_FOREST_BG_ADDR, RACE_FOREST_BG_SIZE
    VERA_STREAM_OUT Race_mountains_tiles, RACE_MOUNTAINS_BG_TILES_ADDR, RACE_MOUNTAINS_BG_SIZE
    VERA_STREAM_OUT Race_forest_tiles, RACE_FOREST_BG_TILES_ADDR, RACE_FOREST_BG_SIZE
    VERA_STREAM_OUT Race_car, RACE_CAR_ADDR, RACE_CAR_SIZE
    VERA_STREAM_OUT Race_mountains_palette, VRAM_palette0, 6*2
    VERA_STREAM_OUT Race_forest_palette, VRAM_palette1, 6*2
    VERA_STREAM_OUT Race_car_palette, VRAM_palette2, 6*2

__race__setup_scene:
    VERA_CONFIGURE_TILE_LAYER 0, 0, 3, 0, 0, 2, 1, RACE_MOUNTAINS_BG_ADDR, RACE_MOUNTAINS_BG_TILES_ADDR
    VERA_CONFIGURE_TILE_LAYER 1, 0, 3, 0, 0, 2, 1, RACE_FOREST_BG_ADDR, RACE_FOREST_BG_TILES_ADDR

    VERA_SET_SPRITE 0
    VERA_CONFIGURE_SPRITE RACE_CAR_ADDR, 0, (320-32), (240-32), 0, 0, 1, 2, 3, 3

__race__begin:
    VERA_ENABLE_SPRITES
    VERA_ENABLE_LAYER 0
    ; VERA_ENABLE_ALL

    lda #0
    jsr sys_wait_for_frame
    jmp *

__race__cleanup:
    VERA_DISABLE_SPRITES
    rts

Race_mountains_palette:
    .word $0000, $0008, $000F, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
Race_palette_end:
Race_forest_palette:
    .word $0000, $0080, $00F0, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
Race_forest_palette_end:
Race_car_palette:
    .word $0000, $0800, $0F00, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
Race_car_palette_end:

Race_tiles:
Race_mountains_tiles:
Race_mountains_blank_tile:
    .byte $00, $00, $00, $00
    .byte $00, $00, $00, $00
    .byte $00, $00, $00, $00
    .byte $00, $00, $00, $00
    .byte $00, $00, $00, $00
    .byte $00, $00, $00, $00
    .byte $00, $00, $00, $00
    .byte $00, $00, $00, $00

Race_mountains_tile_sky:
    .byte $22, $22, $22, $22
    .byte $22, $22, $22, $22
    .byte $22, $22, $22, $22
    .byte $22, $22, $22, $22
    .byte $22, $22, $22, $22
    .byte $22, $22, $22, $22
    .byte $22, $22, $22, $22
    .byte $22, $22, $22, $22

Race_mountains_tile_sky_cloud:
    .byte $22, $22, $22, $22
    .byte $22, $22, $44, $42
    .byte $22, $44, $44, $44
    .byte $24, $44, $44, $44
    .byte $44, $44, $44, $44
    .byte $44, $44, $44, $44
    .byte $24, $44, $44, $44
    .byte $22, $24, $44, $24

Race_mountains_tile_mountain:
    .byte $22, $22, $22, $22
    .byte $22, $22, $22, $21
    .byte $22, $22, $22, $11
    .byte $22, $22, $21, $11
    .byte $22, $22, $11, $11
    .byte $22, $21, $11, $11
    .byte $22, $11, $11, $11
    .byte $21, $11, $11, $11
Race_mountains_tiles_end:

Race_forest_tiles:
Race_forest_blank_tile:
    .byte $00, $00, $00, $00
    .byte $00, $00, $00, $00
    .byte $00, $00, $00, $00
    .byte $00, $00, $00, $00
    .byte $00, $00, $00, $00
    .byte $00, $00, $00, $00
    .byte $00, $00, $00, $00
    .byte $00, $00, $00, $00

Race_forest_tile_top:
    .byte $44, $44, $44, $44
    .byte $44, $44, $44, $44
    .byte $44, $44, $44, $44
    .byte $44, $44, $44, $44
    .byte $44, $44, $44, $44
    .byte $44, $44, $44, $44
    .byte $44, $44, $44, $44
    .byte $44, $44, $44, $44
Race_forest_tiles_end:

Race_car:
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00
    .byte $00, $00, $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00
    .byte $00, $00, $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00
    .byte $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00
    .byte $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00
    .byte $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $00, $00, $11, $00
    .byte $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $00, $00, $11, $00
    .byte $00, $11, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $00, $00
    .byte $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $00, $00
    .byte $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $00, $00, $00, $00
    .byte $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $00, $00, $00, $00
    .byte $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $11, $11, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $00, $00, $11, $11, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00, $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $11, $00, $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $11, $00, $00, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
Race_car_end:

Race_mountains_map: 
; In row-major order
.repeat 20, i
    .repeat 128, j
        .word $0000
    .endrep
.endrep

.repeat 20, i
    .repeat 128, j
        .word $0001
    .endrep
.endrep

.repeat 20, i
    .repeat 128, j
        .word $0002
    .endrep
.endrep

; ; In column-major order
; !for i, 1, 80 {
;     .word $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0003, $0003, $0003, $0003, $0003, $0003, $0003, $0003, $0003, $0003, $0003, $0003, $0003, $0003, $0003, $0003, $0003, $0003, $0003, $0003, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
; }
Race_mountains_map_end:
Race_forest_map:
.repeat 20, i
    .repeat 128, j
        .word $0101
    .endrep
.endrep

.repeat 20, i
    .repeat 128, j
        .word $0101
    .endrep
.endrep

.repeat 20, i
    .repeat 128, j
        .word $0101
    .endrep
.endrep

Race_forest_map_end:

.include "system.asm"
.endif ; RACE_ASM