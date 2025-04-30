cmake_minimum_required(VERSION 3.26)
project(t2 C)

set(CMAKE_C_STANDARD 23)

add_executable(t2 main.c
        utils.c
        utils.h
        funcao.c
        funcao.h
        algoritmo.c
        algoritmo.h)
