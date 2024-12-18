add_rules("mode.debug", "mode.release")

set_languages("c++20")
set_toolchains("clang")
set_warnings("all", "extra")

if is_plat("android") then
    package("benchmark")
        set_kind("library")
        add_deps("cmake")
        set_urls("https://github.com/google/benchmark.git")
        add_versions("v1.9.0", "12235e24652fc7f809373e7c11a5f73c5763fc4c")
        
        -- Add description and homepage for better package management
        set_description("A microbenchmark support library")
        set_homepage("https://github.com/google/benchmark")

        on_install(function(package)
            local configs = {
                "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"),
                "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"),
                "-DBENCHMARK_DOWNLOAD_DEPENDENCIES=on",
                "-DHAVE_THREAD_SAFETY_ATTRIBUTES=0"
            }
            import("package.tools.cmake").install(package, configs)
        end)
    package_end()

    package("gtest")
    set_homepage("https://github.com/google/googletest")
    set_description("Google Testing and Mocking Framework.")
    set_license("BSD-3")

    add_urls("https://github.com/google/googletest/archive/refs/tags/$(version).zip", {alias = "archive"})
    add_urls("https://github.com/google/googletest.git", {alias = "github"})
    add_versions("github:v1.8.1", "release-1.8.1")
    add_versions("archive:v1.8.1", "927827c183d01734cc5cfef85e0ff3f5a92ffe6188e0d18e909c5efebf28a0c7")
    add_versions("github:v1.10.0", "release-1.10.0")
    add_versions("archive:v1.10.0", "94c634d499558a76fa649edb13721dce6e98fb1e7018dfaeba3cd7a083945e91")
    add_versions("github:v1.11.0", "release-1.11.0")
    add_versions("archive:v1.11.0", "353571c2440176ded91c2de6d6cd88ddd41401d14692ec1f99e35d013feda55a")
    add_versions("github:v1.12.0", "release-1.12.0")
    add_versions("archive:v1.12.0", "ce7366fe57eb49928311189cb0e40e0a8bf3d3682fca89af30d884c25e983786")
    add_versions("github:v1.12.1", "release-1.12.1")
    add_versions("archive:v1.12.1", "24564e3b712d3eb30ac9a85d92f7d720f60cc0173730ac166f27dda7fed76cb2")
    add_versions("v1.13.0", "ffa17fbc5953900994e2deec164bb8949879ea09b411e07f215bfbb1f87f4632")
    add_versions("v1.14.0", "1f357c27ca988c3f7c6b4bf68a9395005ac6761f034046e9dde0896e3aba00e4")
    add_versions("v1.15.2", "f179ec217f9b3b3f3c6e8b02d3e7eda997b49e4ce26d6b235c9053bec9c0bf9f")

    add_configs("main",  {description = "Link to the gtest_main entry point.", default = false, type = "boolean"})
    add_configs("gmock", {description = "Link to the googlemock library.", default = true, type = "boolean"})

    if is_plat("linux") then
        add_syslinks("pthread")
    end

    on_install(function (package)
        io.writefile("xmake.lua", [[
            target("gtest")
                set_kind("static")
                set_languages("cxx14")
                add_files("googletest/src/gtest-all.cc")
                add_includedirs("googletest/include", "googletest")
                add_headerfiles("googletest/include/(**.h)")

            target("gtest_main")
                set_kind("static")
                set_languages("cxx14")
                set_default(]] .. tostring(package:config("main")) .. [[)
                add_files("googletest/src/gtest_main.cc")
                add_includedirs("googletest/include", "googletest")
                add_headerfiles("googletest/include/(**.h)")

            target("gmock")
                set_kind("static")
                set_languages("cxx14")
                set_default(]] .. tostring(package:config("gmock")) .. [[)
                add_files("googlemock/src/gmock-all.cc")
                add_includedirs("googlemock/include", "googlemock", "googletest/include", "googletest")
                add_headerfiles("googlemock/include/(**.h)")
        ]])
        import("package.tools.xmake").install(package)
    end)

    package_end()
end


add_requires("benchmark", "gtest", {system = false})
add_requires("cli11", "spdlog")

add_requires("yaml-cpp")
add_requires("glm")

add_requires("vulkan-hpp 1.3.290")
add_requires("vulkan-memory-allocator")
add_requires("shaderc")
add_requires("spirv-reflect")

target("test-module-clang")
    set_kind("binary")
    add_files("src/*.cpp")
    add_packages("benchmark", "gtest", "cli11", "spdlog", "yaml-cpp", "glm", "vulkan-hpp", "vulkan-memory-allocator", "shaderc", "spirv-reflect")
