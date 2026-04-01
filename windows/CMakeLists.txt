cmake_minimum_required(VERSION 3.14)
project(smart_splash_kit_plugin LANGUAGES CXX)

add_library(smart_splash_kit_plugin SHARED
  smart_splash_kit_plugin.cpp
  smart_splash_kit_plugin.h
)

target_link_libraries(smart_splash_kit_plugin PUBLIC flutter_wrapper_plugin)
target_compile_definitions(smart_splash_kit_plugin PUBLIC FLUTTER_PLUGIN_IMPL)

set(smart_splash_kit_plugin_bundled_libraries
  ""
  PARENT_SCOPE
)
