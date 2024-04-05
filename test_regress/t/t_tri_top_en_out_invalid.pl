#!/usr/bin/env perl
if (!$::Driver) { use FindBin; exec("$FindBin::Bin/bootstrap.pl", @ARGV, $0); die; }
# DESCRIPTION: Verilator: Verilog Test driver/expect definition
#
# Copyright 2024 by Wilson Snyder. This program is free software; you
# can redistribute it and/or modify it under the terms of either the GNU
# Lesser General Public License Version 3 or the Perl Artistic License
# Version 2.0.
# SPDX-License-Identifier: LGPL-3.0-only OR Artistic-2.0

scenarios(vlt => 1);

if (system("valgrind --version")) {
   skip("No valgrind installed");
}
elsif (system("$ENV{VERILATOR_ROOT}/bin/verilator -get-supported COROUTINES | grep 1")) {
   skip("No COROUTINES supported")
}
else {

  compile(
    make_top_shell => 0,
    make_main => 0,
    verilator_flags2 => ["--exe --timing --pins-inout-enables", "$Self->{t_dir}/t_tri_top_en_out.cpp"],
    );

  if ($Self->{errors}) {
   print "Compile fails, but expected and required\n";
   $Self->{errors} = 0;
   ok(1)
  } else {
    error("Compile should have failed but did not");
  }
}
1;
