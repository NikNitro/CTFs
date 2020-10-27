#! /bin/bash


# Exiftool
sudo apt-get install exiftool -y
# Radare2
git clone https://github.com/radareorg/radare2.git
cd radare2/sys
./user.sh
PATH=$PATH:/home/$USER/bin


# 
# > r2 rop-and-roll
# pd para desensamblar el putno en el que entramos
# / string para buscar "string" en el codigo
# 
# db 0x00402031 pone un breackpoint en esa linea
# aaa analiza con all flags (strings, funciones, flags..)
# afl busca todas las funciones disponibles
#     Con la opción «afl», buscamos todas las funciones disponibles en busca del main y con «s» buscamos la dirección virtual de la función en el binario. En este caso conocemos la función main, pero si tuviese el nombre correspondiente a la dirección de memoria, podemos hacer uso de !!rabin2 -z en busca de los strings en el binario con el prompt de r2. Si ejecutamos iz hace lo mismo, y con izz busca Strings en todo el binario no solo en .data.
# s 0x004011b4 apunta a esa dirección de memoria. También sirve:
# s main
# pdf desensambla la función apuntada
# 
# # https://fwhibbit.es/introduccion-reversing-0x00-introduccion
# EAX,EBX,ECX,EDX: Son registros de propósito general. Acumulador, base, contador y datos respectivamente. Pueden guardar tanto datos como direcciones.
# La instrucción MOV: Nos permite mover contenido o direcciones de memoria del origen a destino, siguiendo esta estructura 
# mov dest,orig. 
# 	ADD permite sumar quedándose almacenado el resultado en destino
# 	EBP,ESP: Son registros puntero de base y de pila. 
# 		ESP(Extended Stack Pointer) es el puntero actual del stack o pila. 
# 		EBP es la actual base del marco de pila, se usa para hacer referencia en las instrucciones de una función las variables locales.
# 	EIP: Es el puntero de registro de la siguiente instrucción a ejecutar.
# 	EDI y ESI. Punteros de destino y origen.
# 
# 
# Memoria asignada
# 	El segmento de texto contiene el código máquina del programa compilado
#     El segmento de datos almacena los datos del programa. Estos datos podrían ser en forma de variables inicializadas o no inicializadas (segmento bss)
# 
#     >> size rop-and-roll   
#     text	   data	    bss	    dec	    hex	filename
#     2055	    592	     32	   2679	    a77	rop-and-roll
# 
#     El segmento Heap no es administrada automáticamente, es una tarea manual controlado por el desarrollador.
# 
# 
# Funciones
#     Funciones prologo: las tres primeras instrucciones configuran la pila. Son:
#         0x00401182      55             push ebp
#         0x00401183      4889e5         mov ebp, esp
#         0x00401186      4883ec40       sub esp, 0x40
