LOCAL_PATH:= $(call my-dir)

MTCP_LOCAL_CFLAGS:=-DHIGHEST_VA='(VA)0xffffe000' -fno-stack-protector

include $(CLEAR_VARS)
LOCAL_SRC_FILES:= mtcp.c mtcp_restart_nolibc.c \
        mtcp_maybebpt.c mtcp_printf.c mtcp_util.c \
        mtcp_safemmap.c mtcp_safe_open.c \
        mtcp_state.c mtcp_check_vdso.c mtcp_sigaction.c mtcp_fastckpt.c \
        bionic_pthread.c \
        getcontest-x86.S setcontest-x86.S clone-x86.S
LOCAL_C_INCLUDES := bionic/libc/private/ \
                    bionic/libc/bionic/

# Define ANDROID_SMP appropriately.
ifeq ($(TARGET_CPU_SMP),true)
    LOCAL_CFLAGS += -DANDROID_SMP=1
else
    LOCAL_CFLAGS += -DANDROID_SMP=0
endif
LOCAL_CFLAGS+= $(MTCP_LOCAL_CFLAGS) -fno-pic -DDEBUG -DTIMING -g3 -O0
LOCAL_LDFLAGS:= -T $(LOCAL_PATH)/mtcp.t -Wl,-Map,$(LOCAL_PATH)/mtcp.map
LOCAL_MODULE := libmtcp
LOCAL_SHARED_LIBRARIES := libc libdl
LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := readmtcp.c
LOCAL_CFLAGS+= -O0 -g3 -DDEBUG -DTIMING -U__PIC__ $(MTCP_LOCAL_CFLAGS)
LOCAL_MODULE := readmtcp
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := mtcp_restart.c \
        mtcp_printf.c mtcp_util.c mtcp_maybebpt.c \
        mtcp_safemmap.c mtcp_state.c mtcp_safe_open.c \
        mtcp_check_vdso.c mtcp_fastckpt.c
LOCAL_CFLAGS+= -O0 -g3 -DDEBUG -DTIMING $(MTCP_LOCAL_CFLAGS)
LOCAL_MODULE := mtcp_restart
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := testmtcp.c
LOCAL_CFLAGS+= -O0 -g3 -DDEBUG -DTIMING
LOCAL_LDFLAGS:= -Wl,--export-dynamic
LOCAL_MODULE := testmtcp
LOCAL_SHARED_LIBRARIES := libmtcp
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := testmtcp3.c
LOCAL_CFLAGS+= -O0 -g3 -DDEBUG -DTIMING
LOCAL_LDFLAGS:= -Wl,--export-dynamic
LOCAL_MODULE := testmtcp3
LOCAL_SHARED_LIBRARIES := libmtcp
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := testmtcp4.c
LOCAL_CFLAGS+= -O0 -g3 -DDEBUG -DTIMING
LOCAL_LDFLAGS:= -Wl,--export-dynamic
LOCAL_MODULE := testmtcp4
LOCAL_SHARED_LIBRARIES := libmtcp
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := testmtcp5.c
LOCAL_CFLAGS+= -O0 -g3 -DDEBUG -DTIMING
LOCAL_LDFLAGS:= -Wl,--export-dynamic
LOCAL_MODULE := testmtcp5
LOCAL_SHARED_LIBRARIES := libmtcp
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)