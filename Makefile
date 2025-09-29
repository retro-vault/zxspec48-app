# ---------- project ----------
TARGET ?= zxspec48-app

# ---------- docker ----------
# Prebuilt toolchain image (no local build step needed)
DOCKER_IMAGE ?= wischner/sdcc-z80-zx-spectrum:latest

# Mount the repo read/write and run make in /work
# Ensure SDCC is on PATH (image uses /opt/sdcc/bin)
WORKDIR      := $(PWD)
DOCKER_RUN   = docker run --rm -v "$(WORKDIR):/work" -w /work \
               $(DOCKER_IMAGE) env PATH=/opt/sdcc/bin:$$PATH

# ---------- targets ----------
# Default: build inside docker (artifacts -> ./build & ./bin via src/Makefile)
all: $(TARGET)

$(TARGET):
	@echo "[host] building (inside docker) -> bin/$(TARGET).tap"
	@$(DOCKER_RUN) sh -c 'make -C src TARGET=$(TARGET) all'

build: $(TARGET)

rebuild:
	@$(DOCKER_RUN) sh -c 'make -C src TARGET=$(TARGET) clean'
	@$(MAKE) all

clean:
	@echo "[host] removing ./build and ./bin"
	@rm -rf build
	@rm -rf bin

# Optional convenience: pull the image explicitly (not required for build)
docker-pull:
	@echo "[host] pulling docker image $(DOCKER_IMAGE) ..."
	@docker pull $(DOCKER_IMAGE)

.PHONY: all $(TARGET) build rebuild clean docker-pull