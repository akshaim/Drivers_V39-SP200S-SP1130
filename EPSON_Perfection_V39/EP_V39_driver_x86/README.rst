Image Scan v3
=============

Copyright (C) 2015  SEIKO EPSON CORPORATION

For the impatient
-----------------

Change to the folder where you downloaded the scanner driver bundle,
extract it and install all components with

::

   tar xaf imagescan-bundle-ubuntu-16.04-1.3.22.x86.deb.tar.gz
   cd imagescan-bundle-ubuntu-16.04-1.3.22.x86.deb
   ./install.sh

in a terminal window.

You will be asked for your password to acquire the privileges needed
to install software on your system.  This works the same way as with
your regular software installation procedure.

What is all this?
-----------------

This scanner driver bundle contains all components of Image Scan v3
that are needed for the scanner you selected as well as a convenience
``install.sh`` script.  The script can be used to install everything
with a single command.

If you are curious about what the script does, run it as follows

::

   ./install.sh --dry-run

That will display the command(s) it will run to install everything.
For a simple help message, try the ``--help`` option.

Non-free components
-------------------

The components in the ``plugins/`` folder are non-free, in the sense
that they do not give you all the freedoms normally associated with
`Free Software`_.

.. _Free Software: https://en.wikipedia.org/wiki/Free_software

The non-free "networkscan" plugin, however, is optional.  If you only
connect your scanner via a USB cable then you do not need it.  To tell
the ``install.sh`` script that you do not want it installed, use

::

   ./install.sh --without-network

The "networkscan" plugin is installed by default because all supported
EPSON scanners and all-in-ones support access via a (wireless) network
connection.

The OCR Engine is also non-free and optional.  To prevent this plugin
from getting installed use the ``--without-ocr-engine`` option.  Doing
so will disable support for automatic document rotation.

Note that tesseract-3.03 or later can be used as a free alternative.

Troubleshooting
---------------

While the ``install.sh`` script is expected to work as intended in the
vast majority of scenarios it might not work as intended for you.  If
that is the case, please pay attention to the error messages in the
output that is produced.  That should help you find a workaround by
yourself or in the list below.

No permission/privileges to install
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is likely to give messages that include phrases such as ``are you
root?``, ``Root privileges are required`` and ``you need to be root``
(possibly in your language).  The ``install.sh`` script assumes that
you can use ``sudo`` to obtain ``root`` status.  If that is not the
case the install will fail.  You can try

::

   su -c './install.sh'

and provide the ``root`` password in this case.  If you want to use
the ``--without-network`` option, make sure to put it inside the
quotes.

Note, however, that many distributions disable ``root`` logins these
days and instead set up the first user account created during initial
installation so that it can obtain ``root`` status via ``sudo``.  If
that is not your account, get the owner of that account to install the
bundle.

Package conflicts
~~~~~~~~~~~~~~~~~

There is a small chance that the scanner bundle requires other
software to be installed that conflicts with software you have already
installed.  Before you can install the scanner bundle, you will need
to resolve any such conflicts.

The straightforward way is simply to remove any conflicting software
that is already installed.  Your package manager may suggest ways to
resolve the conflict that are less drastic, though.

Package manager or ``apt-get`` command not found
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``install.sh`` script assumes that you have one of the common
higher level package managers for RPM or Debian packages installed.
It also assumes that the binary packages in the bundle are in the
package format that your distribution expects.

In the unlikely case that no supported package manager is available
you can still install manually using the low-level package managers
``rpm`` or ``dpkg``.  First run

::

   ./install.sh --dry-run

and note the list of ``.rpm`` or ``.deb`` files that shows.  You can
use the ``--without-network`` option with the above command if you
wish.  Next, try to install those packages with one of

::

   rpm --install $list_of_rpm_files
   dpkg --install $list_of_deb_files

This will likely fail due to missing dependencies.  In case you used
``rpm``, then install all of the required packages that are mentioned
in the error output using your regular software installation method
and run the same command again.  This time it ought to succeed.

After a failed ``dpkg``, first remove the failed packages.

::

   dpkg --remove $list_of_packages

Note this requires the package names listed at the end of the error
message, *not* the package files you used to install.  Once removed,
you can use your regular software installation method to install any
missing dependencies and run the ``dpkg --install`` command again.

Of course, all ``rpm``, ``dpkg`` and ``apt-get`` invocations require
``root`` privileges.  Use ``sudo`` or ``su -c`` to obtain them.

``getopt`` command not found
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Very unlikely to happen but if it does, install ``util-linux`` and try
again.
