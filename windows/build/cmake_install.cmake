# Install script for directory: C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "$<TARGET_FILE_DIR:Generacion_de_Contratos>")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/flutter/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/plugins/file_saver/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/plugins/printing/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/plugins/syncfusion_pdfviewer_windows/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/plugins/url_launcher_windows/cmake_install.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Debug/Generacion_de_Contratos.exe")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Debug" TYPE EXECUTABLE FILES "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Debug/Generacion_de_Contratos.exe")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Profile/Generacion_de_Contratos.exe")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Profile" TYPE EXECUTABLE FILES "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Profile/Generacion_de_Contratos.exe")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Release/Generacion_de_Contratos.exe")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Release" TYPE EXECUTABLE FILES "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Release/Generacion_de_Contratos.exe")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Debug/data/icudtl.dat")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Debug/data" TYPE FILE FILES "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/flutter/ephemeral/icudtl.dat")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Profile/data/icudtl.dat")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Profile/data" TYPE FILE FILES "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/flutter/ephemeral/icudtl.dat")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Release/data/icudtl.dat")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Release/data" TYPE FILE FILES "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/flutter/ephemeral/icudtl.dat")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Debug/flutter_windows.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Debug" TYPE FILE FILES "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/flutter/ephemeral/flutter_windows.dll")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Profile/flutter_windows.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Profile" TYPE FILE FILES "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/flutter/ephemeral/flutter_windows.dll")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Release/flutter_windows.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Release" TYPE FILE FILES "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/flutter/ephemeral/flutter_windows.dll")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Debug/file_saver_plugin.dll;C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Debug/printing_plugin.dll;C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Debug/pdfium.dll;C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Debug/syncfusion_pdfviewer_windows_plugin.dll;C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Debug/pdfium.dll;C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Debug/url_launcher_windows_plugin.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Debug" TYPE FILE FILES
      "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/plugins/file_saver/Debug/file_saver_plugin.dll"
      "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/plugins/printing/Debug/printing_plugin.dll"
      "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/pdfium-src/bin/pdfium.dll"
      "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/plugins/syncfusion_pdfviewer_windows/Debug/syncfusion_pdfviewer_windows_plugin.dll"
      "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/pdfium-src/bin/pdfium.dll"
      "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/plugins/url_launcher_windows/Debug/url_launcher_windows_plugin.dll"
      )
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Profile/file_saver_plugin.dll;C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Profile/printing_plugin.dll;C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Profile/pdfium.dll;C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Profile/syncfusion_pdfviewer_windows_plugin.dll;C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Profile/pdfium.dll;C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Profile/url_launcher_windows_plugin.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Profile" TYPE FILE FILES
      "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/plugins/file_saver/Profile/file_saver_plugin.dll"
      "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/plugins/printing/Profile/printing_plugin.dll"
      "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/pdfium-src/bin/pdfium.dll"
      "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/plugins/syncfusion_pdfviewer_windows/Profile/syncfusion_pdfviewer_windows_plugin.dll"
      "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/pdfium-src/bin/pdfium.dll"
      "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/plugins/url_launcher_windows/Profile/url_launcher_windows_plugin.dll"
      )
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Release/file_saver_plugin.dll;C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Release/printing_plugin.dll;C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Release/pdfium.dll;C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Release/syncfusion_pdfviewer_windows_plugin.dll;C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Release/pdfium.dll;C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Release/url_launcher_windows_plugin.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Release" TYPE FILE FILES
      "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/plugins/file_saver/Release/file_saver_plugin.dll"
      "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/plugins/printing/Release/printing_plugin.dll"
      "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/pdfium-src/bin/pdfium.dll"
      "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/plugins/syncfusion_pdfviewer_windows/Release/syncfusion_pdfviewer_windows_plugin.dll"
      "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/pdfium-src/bin/pdfium.dll"
      "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/plugins/url_launcher_windows/Release/url_launcher_windows_plugin.dll"
      )
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Debug/")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Debug" TYPE DIRECTORY FILES "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/build/native_assets/windows/")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Profile/")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Profile" TYPE DIRECTORY FILES "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/build/native_assets/windows/")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Release/")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Release" TYPE DIRECTORY FILES "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/build/native_assets/windows/")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    
  file(REMOVE_RECURSE "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Debug/data/flutter_assets")
  
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    
  file(REMOVE_RECURSE "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Profile/data/flutter_assets")
  
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    
  file(REMOVE_RECURSE "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Release/data/flutter_assets")
  
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Debug/data/flutter_assets")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Debug/data" TYPE DIRECTORY FILES "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/build//flutter_assets")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Profile/data/flutter_assets")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Profile/data" TYPE DIRECTORY FILES "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/build//flutter_assets")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Release/data/flutter_assets")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Release/data" TYPE DIRECTORY FILES "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/build//flutter_assets")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Profile/data/app.so")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Profile/data" TYPE FILE FILES "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/build/windows/app.so")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Release/data/app.so")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/runner/Release/data" TYPE FILE FILES "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/build/windows/app.so")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_COMPONENT MATCHES "^[a-zA-Z0-9_.+-]+$")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
  else()
    string(MD5 CMAKE_INST_COMP_HASH "${CMAKE_INSTALL_COMPONENT}")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INST_COMP_HASH}.txt")
    unset(CMAKE_INST_COMP_HASH)
  endif()
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
  file(WRITE "C:/Users/bayro/OneDrive/Documentos/GitHub/Appa-Front/windows/build/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
