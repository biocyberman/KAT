# ============================================================================
#  http://www.gnu.org/software/autoconf-archive/ax_boost_program_options.html
# ============================================================================
#
# SYNOPSIS
#
#   AX_BOOST_PROGRAM_OPTIONS
#
# DESCRIPTION
#
#   Test for program options library from the Boost C++ libraries. The macro
#   requires a preceding call to AX_BOOST_BASE. Further documentation is
#   available at <http://randspringer.de/boost/index.html>.
#
#   This macro calls:
#
#     AC_SUBST(BOOST_PROGRAM_OPTIONS_LIB)
#
#   And sets:
#
#     HAVE_BOOST_PROGRAM_OPTIONS
#
# LICENSE
#
#   Copyright (c) 2009 Thomas Porschberg <thomas@randspringer.de>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved. This file is offered as-is, without any
#   warranty.

#serial 24

AC_DEFUN([AX_BOOST_PROGRAM_OPTIONS],
[
	AC_ARG_WITH([boost-program-options],
		AS_HELP_STRING([--with-boost-program-options@<:@=special-lib@:>@],
                       [use the program options library from boost - it is possible to specify a certain library for the linker
                        e.g. --with-boost-program-options=boost_program_options-gcc-mt-1_33_1 ]),
        [
        if test "$withval" = "no"; then
			want_boost="no"
        elif test "$withval" = "yes"; then
            want_boost="yes"
            ax_boost_user_program_options_lib=""
        else
		    want_boost="yes"
		ax_boost_user_program_options_lib="$withval"
		fi
        ],
        [want_boost="yes"]
	)

	if test "x$want_boost" = "xyes"; then
        AC_REQUIRE([AC_PROG_CC])
	    export want_boost
		CPPFLAGS_SAVED="$CPPFLAGS"
		CPPFLAGS="$CPPFLAGS $BOOST_CPPFLAGS"
		export CPPFLAGS
		LDFLAGS_SAVED="$LDFLAGS"
		LDFLAGS="$LDFLAGS $BOOST_LDFLAGS"
		export LDFLAGS
		AC_CACHE_CHECK([whether the Boost::Program_Options library is available],
					   ax_cv_boost_program_options,
					   [AC_LANG_PUSH(C++)
				AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[@%:@include <boost/program_options/errors.hpp>
                                                          ]],
                                  [[boost::program_options::error err("Error message");
                                   return 0;]])],
                           ax_cv_boost_program_options=yes, ax_cv_boost_program_options=no)
					AC_LANG_POP([C++])
		])
		if test "x$ax_cv_boost_program_options" = "xyes"; then
            AC_SUBST(BOOST_CPPFLAGS)

            AC_DEFINE(HAVE_BOOST_PROGRAM_OPTIONS,,[define if the Boost::Program_Options library is available])
            BOOSTLIBDIR=`echo $BOOST_LDFLAGS | sed -e 's/@<:@^\/@:>@*//'`

            LDFLAGS_SAVE=$LDFLAGS
            if test "x$ax_boost_user_program_options_lib" = "x"; then
                for libextension in `ls $BOOSTLIBDIR/libboost_program_options*.so* $BOOSTLIBDIR/libboost_program_options*.dylib* 2>/dev/null | sed 's,.*/,,' | sed -e 's;^lib\(boost_program_options.*\)\.so.*$;\1;' -e 's;^lib\(boost_program_options.*\)\.dylib.*$;\1;'` ; do
                    ax_lib=${libextension}
                    AC_CHECK_LIB($ax_lib, exit,
                        [BOOST_PROGRAM_OPTIONS_LIB="-l$ax_lib"; AC_SUBST(BOOST_PROGRAM_OPTIONS_LIB) link_program_options="yes"; break],
                        [link_program_options="no"])
                done
                if test "x$link_program_options" != "xyes"; then
                    for libextension in `ls $BOOSTLIBDIR/boost_program_options*.dll* 2>/dev/null | sed 's,.*/,,' | sed -e 's;^\(boost_program_options.*\)\.dll.*$;\1;'` ; do
                        ax_lib=${libextension}
                        AC_CHECK_LIB($ax_lib, exit,
                            [BOOST_PROGRAM_OPTIONS_LIB="-l$ax_lib"; AC_SUBST(BOOST_PROGRAM_OPTIONS_LIB) link_program_options="yes"; break],
                            [link_program_options="no"])
                    done
                fi
                for libextension in `ls $BOOSTLIBDIR/libboost_program_options*.a* 2>/dev/null` ; do
                    ax_static_lib=${libextension}
                    AC_CHECK_FILE($ax_static_lib,
                        [BOOST_PROGRAM_OPTIONS_STATIC_LIB="$ax_static_lib"; AC_SUBST(BOOST_PROGRAM_OPTIONS_STATIC_LIB) link_program_options_static="yes"; break],
                        [link_program_options_static="no"])
                done

                no_find="no"
                if [[ -z "$ax_lib" ]] && [[ -z "$ax_static_lib" ]]; then
                    no_find="yes"
                fi

                no_link="no"
                if [[ "$link_program_options" == "no" ]] && [[ "$link_program_options_static" == "no" ]]; then
                    no_link="yes"
                fi

            else
                for ax_lib in $ax_boost_user_program_options_lib boost_program_options-$ax_boost_user_program_options_lib; do
                    AC_CHECK_LIB($ax_lib, exit,
                        [BOOST_PROGRAM_OPTIONS_LIB="-l$ax_lib"; AC_SUBST(BOOST_PROGRAM_OPTIONS_LIB) link_program_options="yes"; break],
                        [link_program_options="no"])
                done

            fi
            if [[ -z "$ax_lib" ]]; then
                AC_MSG_WARN(Could not find a dynamic version of boost_program_options)
            fi
            if [[ -z "$ax_static_lib" ]]; then
                AC_MSG_WARN(Could not find a static version of boost_program_options)
            fi
            if [[ "$no_find" == "yes" ]]; then
                AC_MSG_ERROR(Could not find any version boost_program_options to link to)
            fi

            if [[ "$link_program_options" = "no" ]]; then
                AC_MSG_WARN(Could not dynamic link against $ax_lib)
            fi
            if [[ "$link_program_options_static" == "no" ]]; then
                AC_MSG_WARN(Could not static link against $ax_static_lib)
            fi
            if [[ "$no_link" == "yes" ]]; then
                AC_MSG_ERROR(Could not link against any boost_program_options lib)
            fi

        fi
        
        CPPFLAGS="$CPPFLAGS_SAVED"
	LDFLAGS="$LDFLAGS_SAVED"
    fi
])
