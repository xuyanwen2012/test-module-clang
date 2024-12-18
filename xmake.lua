add_rules("mode.debug", "mode.release")

set_languages("c++20")
set_toolchains("clang")
set_warnings("all", "extra")


add_requires("benchmark", "gtest")
add_requires("cli11", "spdlog")

add_requires("yaml-cpp")
add_requires("glm")

add_requires("vulkan-hpp 1.3.290")
add_requires("vulkan-memory-allocator")
add_requires("shaderc", "spirv-reflect")

target("test-module-clang")
    set_kind("binary")
    add_files("src/*.cpp")
    add_packages("benchmark", "gtest", "cli11", "spdlog", "yaml-cpp", "glm", "vulkan-hpp", "vulkan-memory-allocator", "shaderc", "spirv-reflect")
