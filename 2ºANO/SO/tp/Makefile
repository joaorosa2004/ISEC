CC = gcc
CFLAGS = -Wall -g
LDFLAGS = 

SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin

FEED = $(BIN_DIR)/Feed
BROKER = $(BIN_DIR)/Manager

FEED_SRC = $(SRC_DIR)/Feed.c
BROKER_SRC = $(SRC_DIR)/Manager.c

FEED_OBJ = $(OBJ_DIR)/Feed.o
BROKER_OBJ = $(OBJ_DIR)/Manager.o

all: $(FEED) $(BROKER)

$(FEED): $(FEED_OBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)	

$(BROKER): $(BROKER_OBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

$(OBJ_DIR)/Feed.o: $(FEED_SRC)
	$(CC) $(CFLAGS) -c -o $@ $<

$(OBJ_DIR)/Manager.o: $(BROKER_SRC)
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -rf $(OBJ_DIR)/*.o $(BIN_DIR)/*

$(OBJ_DIR) $(BIN_DIR):
	mkdir -p $@
