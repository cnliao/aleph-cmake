target_sources(${ALEPH_TARGET_LIB} PRIVATE lib.cpp)

if(${ALEPH_PYTHON})
  target_sources(${ALEPH_TARGET_LIB} PRIVATE py_init.cpp)
  target_sources(${ALEPH_TARGET_PYEXT} PRIVATE py_ext.cpp)
endif()
