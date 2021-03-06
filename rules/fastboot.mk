# fastboot host tool
# =========================================================

fastboot_version := $(shell git submodule status core | cut -c2-9)-android

FASTBOOT_BINARY := obj/fastboot/fastboot

FASTBOOT_CXXFLAGS := \
    -DFASTBOOT_VERSION='"$(fastboot_version)"' \
    -include sys/select.h \
    -I$(srcdir)/boringssl/third_party/googletest/include \
    -I$(srcdir)/core/base/include \
    -I$(srcdir)/core/diagnose_usb/include \
    -I$(srcdir)/core/fastboot \
    -I$(srcdir)/core/include \
    -I$(srcdir)/core/libsparse/include \
    -I$(srcdir)/core/libziparchive/include \
    -I$(srcdir)/core/mkbootimg/include/bootimg \
    -I$(srcdir)/extras/ext4_utils/include \
    -I$(srcdir)/extras/f2fs_utils \
    -I$(srcdir)/include \

FASTBOOT_LDFLAGS := \
    -lz \

FASTBOOT_LIBS := \
    libbase \
    libcutils \
    libdiagnose_usb \
    libext4_utils \
    libselinux \
    libsparse \
    libziparchive \
    liblog \
    libpcre \
    libutils \

FASTBOOT_SRC_FILES := \
    bootimg_utils.cpp \
    engine.cpp \
    fastboot.cpp \
    fs.cpp \
    main.cpp \
    protocol.cpp \
    socket.cpp \
    tcp.cpp \
    udp.cpp \
    usb_linux.cpp \
    util.cpp \

FASTBOOT_LIB_DEPS := \
    $(foreach lib,$(FASTBOOT_LIBS),obj/$(lib)/$(lib).a)

FASTBOOT_OBJ_FILES := \
    $(patsubst %.cpp,obj/fastboot/%.o,$(FASTBOOT_SRC_FILES))

BINS += $(FASTBOOT_BINARY)
DIRS += $(dir $(FASTBOOT_OBJ_FILES))

fastboot: $(FASTBOOT_BINARY)

$(FASTBOOT_BINARY): $(FASTBOOT_OBJ_FILES) $(FASTBOOT_LIB_DEPS) | dirs
	$(CXX) $(CXXFLAGS) $(FASTBOOT_CXXFLAGS) -o $@ $^ $(LDFLAGS) $(FASTBOOT_LDFLAGS)

$(FASTBOOT_OBJ_FILES): obj/fastboot/%.o: $(srcdir)/core/fastboot/%.cpp | dirs
	$(CXX) $(CXXFLAGS) $(FASTBOOT_CXXFLAGS) -c -o $@ $^
