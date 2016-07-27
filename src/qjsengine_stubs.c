/* -*- c++ -*- */

#define CAML_NAME_SPACE

#include <QCoreApplication>
#include <QJSEngine>
#include <QDebug>

// OCaml declarations
#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/memory.h>
#include <caml/custom.h>
#include <caml/fail.h>

#include <iostream>
#include <string>

extern "C" {

  CAMLprim value
  test_me(value unit)
  {
    printf("123\n");
    return Val_unit;
  }
}
