PROJECT="x16-racer"
EMU_DIR="../x16-emulator"
EMULATOR="x16emu"
ASM="../cc65/bin/cl65"
CFGPATH="../cc65/cfg"
LIBPATH="../cc65/lib"
DEBUG_OPTS="-vm -m ${PROJECT}.map -g -l ${PROJECT}.list -Wl --dbgfile,${PROJECT}.dbg"

all:
	${ASM} -o ${PROJECT}.prg -DCX16 --lib-path ${LIBPATH} --cfg-path ${CFGPATH} ${PROJECT}.asm

run: 
	${EMU_DIR}/${EMULATOR} -run -prg $(PROJECT).prg

clean:
	rm -f *.prg disk.d64 *.o