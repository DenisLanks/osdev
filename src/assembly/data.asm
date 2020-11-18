msg: db "Hello from Bootloader!",LF,CR,0
title: db "Lanks Bootloader",0
headerPart: db "Opcao Num Disco Num Part. Tipo  Tamanho",0
headerLine: db "_____ _________ _________ _____ _______",0
msgInfo: db ">",0
hexstr: db "0123456789ABCDEF",0
unknownpart: db "UNKN",0
fatpart: db "FAT",0
fat12part: db "FAT12",0
fat16part: db "FAT16",0
fat32part: db "FAT32",0
;tmpNumStr: db 0,0,0,0,0,0